from django.conf.urls import patterns, include, url
from django.contrib.auth.views import login, logout
from django.views.generic import DetailView, ListView
from django.views.generic.simple import direct_to_template
from challenge_site.models import UserProfile, League, Challenge, ChallengeEntry, ValidEntry
from challenge_site.views import user
from challenge_site.views.challenge import ChallengeCreate, ChallengeUpdate, ChallengeDelete
from challenge_site.views.challenge_entry import ChallengeEntryCreate, ChallengeEntryUpdate, ChallengeEntryDelete
from challenge_site.views.league import LeagueCreate, LeagueUpdate, LeagueDelete
from challenge_site.views.valid_entry import ValidEntryCreate, ValidEntryUpdate, ValidEntryDelete

# Uncomment the next two lines to enable the admin:
from django.contrib import admin
from django.views.generic.detail import DetailView
admin.autodiscover()

urlpatterns = patterns('',
    #Misc URLs
    url(r'^$',  direct_to_template, {
        "template":"index.html",
    }),
    url(r'^about/$',  direct_to_template, {
        "template":"about.html",
    }),
    
    #READ URLs
    url(r'^my_profile/$', user.my_profile, name="my_profile"),
        
    #...List URLs
    url(r'^user_profiles/$', 
     ListView.as_view(
        queryset=UserProfile.objects.filter(user__is_active=True),
        context_object_name="user_profiles",
        template_name="user/user_profiles.html"
     ),
     name="user_profile_list"),
                       
    url(r'^challenges/$', 
     ListView.as_view(
        queryset=Challenge.objects.all(),
        context_object_name="challenges",
        template_name="challenge/challenges.html"
     ),
     name="challenge_list"),
                       
    url(r'^leagues/$', 
     ListView.as_view(
        queryset=League.objects.all(),
        context_object_name="leagues",
        template_name="league/leagues.html"
     ),
     name="league_list"),
                       
    url(r'^challenge_entries/$', 
     ListView.as_view(
        queryset=ChallengeEntry.objects.all(),
        context_object_name="challenge_entries",
        template_name="challenge_entry/challenge_entries.html"
     ),
     name="challenge_entry_list"),
                       
    url(r'^valid_entries/$', 
     ListView.as_view(
        queryset=ValidEntry.objects.all(),
        context_object_name="valid_entries",
        template_name="valid_entry/valid_entries.html"
     ),
     name="valid_entry_list"),

    #...Detail URLs
    url(r'^user_profile/(?P<pk>\d+)/$',
     DetailView.as_view(
        model=UserProfile,
        queryset=UserProfile.objects.filter(user__is_active=True),
        context_object_name="user_profile",
        template_name="user/user_profile_detail.html"
     ),
     name="user_profile_detail"
    ),
                       
    url(r'^challenge/(?P<pk>\d+)$',
     DetailView.as_view(
        model=Challenge,
        context_object_name="challenge",
        template_name="challenge/challenge_detail.html"
        ),
     name="challenge_detail"
    ),
                       
    url(r'^league/(?P<pk>\d+)$',
     DetailView.as_view(
        model=League,
        context_object_name="league",
        template_name="league/league_detail.html"
     ),
     name="league_detail"
    ),
                       
    url(r'^challenge_entry/(?P<pk>\d+)$',
     DetailView.as_view(
        model=ChallengeEntry,
        context_object_name="challenge_entry",
        template_name="challenge_entry/challenge_entry_detail.html"
     ),
     name="challenge_entry_detail"
    ),
                       
    url(r'^valid_entry/(?P<pk>\d+)$',
     DetailView.as_view(
        model=ValidEntry,
        context_object_name="valid_entry",
        template_name="valid_entry/valid_entry_detail.html"
     ),
     name="valid_entry_detail"
    ), 

    #Create URLs
    url(r'^challenge/add/$', ChallengeCreate.as_view(), name="challenge_add"),
    url(r'^league/add/$', LeagueCreate.as_view(), name="league_add"),
    url(r'^challenge_entry/add/$', ChallengeEntryCreate.as_view(), name="challenge_entry_add"),
    url(r'^valid_entry/add/$', ValidEntryCreate.as_view(), name="valid_entry_add"),
    
    #...Create Success URLs
    url(r'^challenge/add_success/$', direct_to_template, {
        "template":"message.html","extra_context":{
            "message":"Challenge Successfully Added."
        }
    }),
    url(r'^league/add_success/$', direct_to_template, {
        "template":"message.html","extra_context":{
            "message":"League Successfully Added."
        }
    }),
    url(r'^challenge_entry/add_success/$', direct_to_template, {
        "template":"message.html","extra_context":{
            "message":"Challenge Entry Successfully Added."
        }
    }),
    url(r'^valid_entry/add_success/$', direct_to_template, {
        "template":"message.html","extra_context":{
            "message":"Valid Entry Successfully Added."
        }
    }),
    
    #Update URLs
    url(r'^challenge/(?P<pk>\d+)/$', ChallengeUpdate.as_view(), name="challenge_update"),
    url(r'^league/(?P<pk>\d+)/$', LeagueUpdate.as_view(), name="league_update"),
    url(r'^challenge_entry/(?P<pk>\d+)/$', ChallengeEntryUpdate.as_view(), name="challenge_entry_update"),
    url(r'^valid_entry/(?P<pk>\d+)/$', ValidEntryUpdate.as_view(), name="valid_entry_update"),
    
    #...Update Success URLs
    url(r'^challenge/update_success/$', direct_to_template, {
        "template":"message.html","extra_context":{
            "message":"Challenge Successfully Updated."
        }
    }),
    url(r'^league/update_success/$', direct_to_template, {
        "template":"message.html","extra_context":{
            "message":"League Successfully Updated."
        }
    }),
    url(r'^challenge_entry/update_success/$', direct_to_template, {
        "template":"message.html","extra_context":{
            "message":"Challenge Entry Successfully Updated."
        }
    }),
    url(r'^valid_entry/update_success/$', direct_to_template, {
        "template":"message.html","extra_context":{
            "message":"Valid Entry Successfully Updated."
        }
    }),
    
    #Delete URLs
    url(r'^challenge/(?P<pk>\d+)/delete/$', ChallengeDelete.as_view(), name="challenge_delete"),
    url(r'^league/(?P<pk>\d+)/delete/$', LeagueDelete.as_view(), name="league_delete"),
    url(r'^challenge_entry/(?P<pk>\d+)/delete/$', ChallengeEntryDelete.as_view(), name="challenge_entry_delete"),
    url(r'^valid_entry/(?P<pk>\d+)/delete/$', ValidEntryDelete.as_view(), name="valid_entry_delete"),
    
    #Delete Success URLs
    url(r'^challenge/delete_success/$', direct_to_template, {
        "template":"message.html","extra_context":{
            "message":"Challenge Successfully Removed."
        }
    }),
    url(r'^league/delete_success/$', direct_to_template, {
        "template":"message.html","extra_context":{
            "message":"League Successfully Removed."
        }
    }),
    url(r'^challenge_entry/delete_success/$', direct_to_template, {
        "template":"message.html","extra_context":{
            "message":"Challenge Entry Successfully Removed."
        }
    }),
    url(r'^valid_entry/delete_success/$', direct_to_template, {
        "template":"message.html","extra_context":{
            "message":"Valid Entry Successfully Removed."
        }
    }),
    
    #Custom Auth
    (r'^register/$', user.register),
    url(r'^register_thanks/$', direct_to_template, {
        "template":"message.html","extra_context":{
            "message":"Thanks for registering!"
        }
    }),    
    
    # Uncomment the admin/doc line below to enable admin documentation:
    url(r'^admin/doc/', include('django.contrib.admindocs.urls')),

    # Uncomment the next line to enable the admin:
    (r'^admin/', include(admin.site.urls)),
)
#Generic Auth
urlpatterns += patterns('django.contrib.auth.views',
    (r'^login/$', login, {"template_name":"auth/login.html"}),
    (r'^logout/$', logout, {
        "template_name":"message.html", "extra_context":{
            "message":"You have been successfully logged out."
            }
        }
    ),
)
