from django.views.generic.edit import CreateView, UpdateView, DeleteView
from challenge_site.models import Challenge
from challenge_site.forms import ChallengeForm
from challenge_site.util import CheckOwnerMixin

class ChallengeCreate(CreateView):
    model=Challenge
    form_class=ChallengeForm
    success_url="challenge/add_success/"
    
    def form_valid(self, form):
        form.instance.created_by = self.request.user
        return super(ChallengeCreate, self).form_valid(form)
    
class ChallengeUpdate(UpdateView, CheckOwnerMixin):
    model=Challenge
    form_class=ChallengeForm
    success_url="challenge/update_success/"

class ChallengeDelete(DeleteView, CheckOwnerMixin):
    model=Challenge
    success_url="challenge/delete_success/"
