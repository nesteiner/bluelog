from backend import db

class Post(db.Model):
    __tablename__ = 'Post'
    
    postid = db.Column(db.Integer, primary_key=True)
    title  = db.Column(db.String(20))
    author = db.Column(db.String(20))
    content = db.Column(db.String(100))

    def serialize(self):
        return {
            'postid': self.postid,
            'title': self.title,
            'author': self.author,
            'content': self.content,
        }

class User(db.Model):
    __tablename__ = 'User'

    userid = db.Column(db.Integer, primary_key=True)
    name   = db.Column(db.String(20))
    passhash = db.Column(db.String(128))
    isadmin = db.Column(db.Boolean)

    def serialize(self):
        return {
            'userid': self.userid,
            'name': self.name,
            'isadmin': self.isadmin
        }