local core = require("apisix.core")

local plugin_name = "header-injector"

local schema = {
    type = "object",
    properties = {
        request_headers = {
            type = "object",
            additionalProperties = {
                type = "string"
            }
        },
        response_headers = {
            type = "object",
            additionalProperties = {
                type = "string"
            }
        }
    }
}

local _M = {
    version = 1,
    priority = 1000,
    name = plugin_name,
    schema = schema
}

function _M.check_schema(conf)
    return core.schema.check(schema, conf)
end

-- Inject Request Headers
function _M.rewrite(conf, ctx)
    if conf.request_headers then
        for header_name, header_value in pairs(conf.request_headers) do
            local existing = core.request.header(ctx, header_name)
            if not existing then 
                core.request.set_header(header_name, header_value)
            end
        end
    end
end

-- Inject Response Headers
function _M.header_filter(conf, ctx)
    if conf.response_headers then
        for header_name, header_value in pairs(conf.response_headers) do
            local existing = ngx.header[header_name]
            if not existing then
                core.response.set_header(header_name, header_value)
            end
        end
    end
end

return _M