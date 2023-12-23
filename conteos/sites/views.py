from django.shortcuts import render

from django.core import serializers
from django.http import HttpResponse

from sites.models import CountSite


def index(request):
    return HttpResponse("Index.")


def get_all(request):

    raw_data = serializers.serialize('json', CountSite.objects.all())
    return HttpResponse(raw_data)
