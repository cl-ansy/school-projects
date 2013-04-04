from django.views.generic.edit import CreateView, UpdateView, DeleteView
from challenge_site.models import League
from challenge_site.forms import LeagueForm
from challenge_site.util import CheckOwnerMixin 

class LeagueCreate(CreateView):
    model=League
    form_class=LeagueForm
    success_url="league/add_success/"
    
    def form_valid(self, form):
        form.instance.created_by = self.request.user
        return super(LeagueCreate, self).form_valid(form)
    
class LeagueUpdate(UpdateView, CheckOwnerMixin):
    model=League
    form_class=LeagueForm
    success_url="league/update_success/"

class LeagueDelete(DeleteView, CheckOwnerMixin):
    model=League
    success_url="league/delete_success/"
