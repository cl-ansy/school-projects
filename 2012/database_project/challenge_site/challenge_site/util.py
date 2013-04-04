#A mixin that checks the 'owner' attrbute of the object in class-based views.
#This is a security check to keep users from deleting each other's stuff
class CheckOwnerMixin(object):
    def dispatch(self, request, *args, **kwargs):
        if (request.user.is_authenticated and (get_object().creator==request.user.get_profile or request.user.is_superuser)):
            return super(CheckOwnerMixin, self).dispatch(self, request, *args, **kwargs)
        else:
            return HttpResponseForbidden(request)