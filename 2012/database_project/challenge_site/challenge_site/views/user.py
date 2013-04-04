from django.contrib.auth import login, authenticate
from django.contrib.auth.decorators import login_required
from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth.models import User
from django.http import HttpResponseRedirect
from django.shortcuts import render_to_response
from django.template import RequestContext
from challenge_site.models import UserProfile, Challenge

@login_required(login_url="/login/")
def my_profile(request):
    user_profile = request.user.get_profile()
    entered_challenges = Challenge.objects.filter(entries__owner=user_profile)
    context = {
        "user_profile":user_profile,
        "entered_challenges":entered_challenges,
    }
    return render_to_response('user/my_profile.html', context, RequestContext(request))
    
def register(request):
    context = {}
    if request.method == 'POST':
        form = UserCreationForm(request.POST)
        if form.is_valid():   
            form.save()
            user = authenticate(username=form.cleaned_data['username'], password=form.cleaned_data['password1'])
            user.is_active=False
            login(request, user)
            return HttpResponseRedirect("/register_thanks/")
        else:
            context['form']=form
            return render_to_response('auth/register.html', context, RequestContext(request))
    else:
        context['form']=UserCreationForm()
        return render_to_response('auth/register.html', context, RequestContext(request))
