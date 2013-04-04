from django.shortcuts import render_to_response
from django.template import RequestContext

def index(request):
    #TODO: Fill context with relevant data
    context = {}
    return render_to_response('misc/index.html', context, RequestContext(request))

def about(request):
    #TODO: Fill context with relevant data
    context = {}
    return render_to_response('misc/about.html', context, RequestContext(request))
