from flask import Flask, jsonify, request

app = Flask(__name__)

# Root path
@app.route('/', defaults={'path': ''}, methods=['GET','POST','PUT','DELETE'])
# Any other path
@app.route('/<path:path>', methods=['GET','POST','PUT','DELETE'])
def catch_all(path):

    proxy_header = request.headers.get("x-source")

    # Validate header
    if proxy_header != "apisix":
        return jsonify({
            "error": "Forbidden",
            "message": "Missing or invalid x-source header"
        }), 403

    # If header is valid
    return jsonify({
        "message": "Hello Mani! Header validated successfully",
        "requested_path": "/" + path,
        "method": request.method
    }), 200


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=1407)