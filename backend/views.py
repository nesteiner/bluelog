from backend import app, jsonify, session, request, db
from backend.models import Post, User
from backend.utils import makehash
from flask import abort

# /login
@app.route('/login', methods=['POST'])
def login():
    username = request.json.get('username')
    passhash = request.json.get('passhash')
    usertype = request.json.get('usertype')

    # STUB replace original code
    matchedUser = User.query.filter_by(name=username, passhash=passhash, isadmin=usertype == 'admin').first()
    
    if matchedUser is None:
        error = 'login failed, no such user or password incorrect'
        abort(400, description=error)
    else:
        session['usertype'] = usertype
        session['curuser'] = username
        return jsonify({
            'status': 'login success',
            'curuser': session.get('curuser') # to check if code works right
        })

    
# MODULE for user view
@app.route('/posts', methods=['POST'])
def posts():
    username = request.json.get('username')
    # username = session.get('curuser')
    return jsonify({
        'status': 'get post success',
        'posts': list(map(lambda x: x.serialize(), Post.query.filter(Post.author == username).all())),
        'username': username
    })

# MODULE for admin view
@app.route('/admin', methods=['POST'])
def admin():
    return jsonify({
        'users': list(map(lambda x: x.serialize(), User.query.filter(User.isadmin == False).all()))
    })

# /session/curuser
@app.route('/session/curuser')
def curuser():
    username = session.get('curuser')

    return jsonify({
        'curuser': username,
        'isadmin': session.get('usertype') == 'admin',
    })

# /logout
@app.route('/logout')
def logout():
    session.pop('curuser', None)

    return jsonify({
        'status': 'logout success'
    })

