from backend import app, jsonify

@app.errorhandler(400)
def login_failed(e):
    jsonDict = {
        'code': e.code,
        'name': e.name,
        'description': e.description,
    }

    return jsonify(jsonDict), 400
