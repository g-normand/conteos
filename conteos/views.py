# from sites.models import CountSite
import os
from flask import Flask
from flask_admin import Admin
from flask_admin.contrib.sqla import ModelView

from models import User, CountSite
from db_config import db


def create_app(test_config=None):
    # create and configure the app
    app = Flask(__name__, instance_relative_config=True)
    app.config.from_mapping(
        SECRET_KEY='dev',
        SQLALCHEMY_DATABASE_URI=f"sqlite:///{os.path.abspath(os.getcwd())}/instance/project.db"
    )

    db.init_app(app)
    with app.app_context():
        # create_all does not update tables if they are already in the database.
        db.create_all()

    if test_config is None:
        # load the instance config, if it exists, when not testing
        app.config.from_pyfile('config.py', silent=True)
    else:
        # load the test config if passed in
        app.config.from_mapping(test_config)

    # ensure the instance folder exists
    try:
        os.makedirs(app.instance_path)
    except OSError:
        pass

    # set optional bootswatch theme
    app.config['FLASK_ADMIN_SWATCH'] = 'cosmo'

    admin = Admin(app, name='conteos', template_mode='bootstrap3')
    admin.add_view(ModelView(User, db.session))
    admin.add_view(ModelView(CountSite, db.session))

    # a simple page that says hello
    @app.route('/hello')
    def hello():
        return 'Hello, World!'

    @app.route("/users")
    def users_api():
        users = db.session.execute(db.select(User).order_by(User.username)).scalars()
        return dict(users=[user.to_json() for user in users])

    @app.route("/sites")
    def sites_api():
        sites = db.session.execute(db.select(CountSite).order_by(CountSite.id)).scalars()
        return dict(sites=[site.to_dict() for site in sites])

    return app

