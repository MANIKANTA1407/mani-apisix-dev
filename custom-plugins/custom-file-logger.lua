local core = require("apisix.core")
local cjson = require("cjson.safe")

local plugin_name = "custom-file-logger"

local schema = {
    type = "object",
    properties = {}
}

local _M = {
    version = 0.2,
    priority = 10,
    name = plugin_name,
    schema = schema
}

function _M.check_schema(conf)
    return core.schema.check(schema, conf)
end

-- Mask sensitive headers
local function mask_sensitive_headers(headers)
    if not headers then
        return headers
    end

    local sensitive = {
        authorization = true,
        cookie = true,
        ["x-api-key"] = true
    }

    for k, _ in pairs(headers) do
        if sensitive[string.lower(k)] then
            headers[k] = "***masked***"
        end
    end

    return headers
end

-- Log phase
function _M.log(conf, ctx)

    local host = core.request.get_host()
    local route = ctx.matched_route and ctx.matched_route.value.uri
    local service = ctx.matched_route and ctx.matched_route.value.service_id
    local status = ngx.status

    local req_headers = core.request.headers()
    local resp_headers = ngx.resp.get_headers()

    req_headers = mask_sensitive_headers(req_headers)
    resp_headers = mask_sensitive_headers(resp_headers)

    -- Latency calculation
    local request_time = tonumber(ctx.var.request_time) or 0
    local upstream_latency = tonumber(ctx.var.upstream_response_time) or 0

    local apisix_latency = request_time - upstream_latency
    if apisix_latency < 0 then
        apisix_latency = 0
    end

    -- Convert to milliseconds (recommended)
    apisix_latency = apisix_latency * 1000
    upstream_latency = upstream_latency * 1000

    local log_entry = {
        timestamp = ngx.localtime(),
        host = host,
        service_id = service,
        route = route,
        status = status,
        request_headers = req_headers,
        response_headers = resp_headers,
        apisix_latency_ms = apisix_latency,
        upstream_latency_ms = upstream_latency
    }

    -- Log to Docker stdout
    core.log.warn(cjson.encode(log_entry))
end

return _M