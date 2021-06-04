from backend import app, db
from backend.models import Post, User
from backend.utils import makehash

import click

@app.cli.command()
@click.option('--drop', is_flag=True, help='Create after drop.')
def initdb(drop):
    if drop:
        db.drop_all()

    db.create_all()
    click.echo('Initialized database')

@app.cli.command()
def forge():
    db.create_all()

    posts = list(map(lambda postid: Post(postid=postid, title=str(postid), author='Steiner', content='hello world at {}'.format(postid)), range(1, 11)))

    for post in posts:
        db.session.add(post)

    user = User(userid=1, name='Steiner', isadmin=False, passhash=makehash('1234567'))
    admin = User(userid=0, name='Admin', isadmin=True, passhash=makehash('hello worl'))

    db.session.add(user)
    db.session.add(admin)
    db.session.commit()
    click.echo('Done.')
        

    
