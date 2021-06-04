from flask import Flask, jsonify, session, request
from flask_cors import CORS
app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}}, supports_credentials=True)

# for database
from flask_sqlalchemy import SQLAlchemy
app.config.from_pyfile('config.py')
app.config['SECRET_KEY'] = '1234567'
db = SQLAlchemy(app)

from backend import views, commands, error
