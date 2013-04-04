from challenge_site.models import *
from django.forms import ModelForm

class ChallengeForm(ModelForm):
    class Meta:
        model = Challenge
        exclude = ('creator',)
    
class LeagueForm(ModelForm):
    class Meta:
        model = League
        exclude = ('creator',)
    
class ChallengeEntryForm(ModelForm):
    class Meta:
        model = ChallengeEntry
        exclude = ('creator',)

class ValidEntryForm(ModelForm):
    class Meta:
        model = ValidEntry
        exclude = ('creator',)
