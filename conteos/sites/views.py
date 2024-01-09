import json
from django.core import serializers
from django.http import HttpResponse

from sites.models import CountSite


def index(request):
    return HttpResponse("Index.")


def get_all(request):

    raw_data = serializers.serialize('json', CountSite.objects.all())

    # Convert JSON to Python dictionary
    data_dict = {'data': json.loads(raw_data)}

    # Convert dictionary to JSON
    json_data = json.dumps(data_dict)

    # Return JSON as HTTP response
    return HttpResponse(json_data, content_type='application/json')
