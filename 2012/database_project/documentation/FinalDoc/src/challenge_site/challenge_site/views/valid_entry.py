from django.shortcuts import render_to_response
from django.template import RequestContext
from django.shortcuts import get_object_or_404
from django.views.generic.edit import CreateView, UpdateView, DeleteView
from challenge_site.models import ValidEntry
from challenge_site.forms import ValidEntryForm
from challenge_site.util import CheckOwnerMixin 

class ValidEntryCreate(CreateView):
    model=ValidEntry
    form_class=ValidEntryForm
    success_url="valid_entry/add_success/"
    
    def form_valid(self, form):
        form.instance.created_by = self.request.user
        return super(ValidEntryCreate, self).form_valid(form)
    
class ValidEntryUpdate(UpdateView, CheckOwnerMixin):
    model=ValidEntry
    form_class=ValidEntryForm
    success_url="valid_entry/update_success/"

class ValidEntryDelete(DeleteView, CheckOwnerMixin):
    model=ValidEntry
    success_url="valid_entry/delete_success/"