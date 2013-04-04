from django.views.generic.edit import CreateView, UpdateView, DeleteView
from challenge_site.models import ChallengeEntry
from challenge_site.forms import ChallengeEntryForm
from challenge_site.util import CheckOwnerMixin 

class ChallengeEntryCreate(CreateView):
    model=ChallengeEntry
    form_class=ChallengeEntryForm
    success_url="challenge_entry/add_success/"
    
    def form_valid(self, form):
        form.instance.created_by = self.request.user
        return super(ChallengeEntryCreate, self).form_valid(form)
    
    
class ChallengeEntryUpdate(UpdateView, CheckOwnerMixin):
    model=ChallengeEntry
    form_class=ChallengeEntryForm
    success_url="challenge_entry/update_success/"


class ChallengeEntryDelete(DeleteView, CheckOwnerMixin):
    model=ChallengeEntry
    success_url="challenge_entry/delete_success/"
