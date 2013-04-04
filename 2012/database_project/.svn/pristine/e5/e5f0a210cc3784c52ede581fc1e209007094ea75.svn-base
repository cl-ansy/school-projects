from django.contrib.auth.models import User, Permission
from django.core.urlresolvers import reverse
from django.db import models
from django.db.models.signals import post_save
    
class UserProfile(models.Model):
    #Primitive Fields
    dob = models.DateField(null=True)
    #Relational Fields
    #This field is required
    user = models.OneToOneField(User)
    friends = models.ManyToManyField("self")
    
    def create_user_profile(sender, instance, created, **kwargs):
        if created:
            UserProfile.objects.create(user=instance)
    post_save.connect(create_user_profile, sender=User)
    
    def __unicode__(self):
        return self.user.username
    
    def getScoreByLeague(self, league):
        score=0
        for challenge in league.challenge_set.all():
            for entry in challenge.challengeentry_set.filter(owner=self):
                if entry.correct:
                    score+=entry.get_score()
        return score
    
    def get_absolute_url(self):
        return reverse('user_profile_detail', args=[str(self.id)])
    
    
class League(models.Model):
    #Primitive Fields
    name = models.CharField(max_length=200)
    description = models.CharField(max_length=200)
    #CheckOwnerMixin is dependent upon this field
    owner = models.ForeignKey(UserProfile, related_name="leagues_created")
    members = models.ManyToManyField(UserProfile, related_name="leagues_enrolled")
    #Relational Fields
    
    def __unicode__(self):
        return self.name
    
    
    def get_absolute_url(self):
        return reverse('league_detail', args=[str(self.id)])


class Challenge(models.Model):
    #Primitive Fields
    name = models.CharField(max_length=200)
    description = models.CharField(max_length=200)
    score = models.IntegerField(default=0)
    starting_time = models.DateTimeField(auto_now_add=True)
    ending_time = models.DateTimeField()
    #Relational Fields
    league = models.ForeignKey(League)
    #CheckOwnerMixin is dependent upon this field
    owner = models.ForeignKey(UserProfile, related_name="challenges_created")
    
    def __unicode__(self):
        return self.name
    
    def get_absolute_url(self):
        return reverse('challenge_detail', args=[str(self.id)])
    
    
class ChallengeEntry(models.Model):
    #Primitive Fields
    name = models.CharField(max_length=200)
    response = models.CharField(max_length=2000)
    time_started = models.DateTimeField(auto_now_add=True)
    time_completed = models.DateTimeField()
    correct = models.BooleanField(default=False)
    #Relational Fields
    challenge = models.ForeignKey(Challenge, related_name='entries')
    #CheckOwnerMixin is dependent upon this field
    owner = models.ForeignKey(UserProfile)
    
    def __unicode__(self):
        return self.name
    
    def validate_entry(self):
        for entry in self.challenge.validentry_set.all():
            if self.response == entry.response:
                return True
        return False
    
    def get_score(self):
        if self.correct:
            return challenge.score
        else:
            return 0
    
    def get_absolute_url(self):
        return reverse('challenge_entry_detail', args=[str(self.id)])


class ValidEntry(models.Model):
    #Primitive Fields
    name = models.CharField(max_length=200)
    description = models.CharField(max_length=200)
    response = models.CharField(max_length=2000)
    #Relational Fields
    challenge = models.ForeignKey(Challenge)
    #CheckOwnerMixin is dependent upon this field
    owner = models.ForeignKey(UserProfile)
    
    def __unicode__(self):
        return self.name
    
    def get_absolute_url(self):
        return reverse('valid_entry_detail', args=[str(self.id)])
    
