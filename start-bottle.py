from bottle.ext import sqlalchemy
from sqlalchemy import create_engine
from bottle import Bottle, run

from conteos.db_config import Base
from conteos.home import app

engine = create_engine('sqlite:///:memory:', echo=True)
plugin = sqlalchemy.Plugin(
    engine, # SQLAlchemy engine created with create_engine function.
    Base.metadata, # SQLAlchemy metadata, required only if create=True.
    keyword='db', # Keyword used to inject session database in a route (default 'db').
    create=True, # If it is true, execute `metadata.create_all(engine)` when plugin is applied (default False).
    commit=True, # If it is true, plugin commit changes after route is executed (default True).
    use_kwargs=False # If it is true and keyword is not defined, plugin uses **kwargs argument to inject session database (default False).
)

app.install(plugin)

run(app, host='localhost', port=8080, debug=True)
