from bottle import route, error
import logging

from conteos.models import User, CountSite
from bottle import Bottle

PREFIX_ROUTE = ''

app = Bottle()


@app.route(PREFIX_ROUTE + '/hello')
def hello():
    return "Hello World!"


@app.route(PREFIX_ROUTE + '/users')
def faune_from_google_maps(db):
    users = db.query(User).order_by('username').all()
    return dict(users=[user.to_json() for user in users])


@app.route(PREFIX_ROUTE + "/sites")
def sites_api(db):
    sites = db.query(CountSite).order_by('id').all()
    return dict(sites=[site.to_dict() for site in sites])


@app.error(500)
def error500(error):
    logging.info(error)
    print(error)    
    return 'Oups, une erreur est survenue'
