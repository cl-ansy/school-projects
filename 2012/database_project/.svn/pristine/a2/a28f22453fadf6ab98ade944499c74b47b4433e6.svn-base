from django.contrib.auth.forms import AuthenticationForm
from django.core.urlresolvers import reverse_lazy
from challenge_site.GUI_components import NavBarItem


#Context processor to fill the base.html context
def base_template_processor(request):
    navbar_items = [
        NavBarItem(display_name="Home", link="/"),
        NavBarItem(display_name="About", link="/about/"),
        NavBarItem(display_name="Challenges", link=reverse_lazy("challenge_list")),
        NavBarItem(display_name="Leagues", link=reverse_lazy("league_list")),
        NavBarItem(display_name="User Profiles", link=reverse_lazy("user_profile_list")),
        NavBarItem(display_name="Challenge Entries", link=reverse_lazy("challenge_entry_list")),
        NavBarItem(display_name="Valid Entries", link=reverse_lazy("valid_entry_list")),
    ]
    if request.user.is_authenticated():
        navbar_items.insert(2, NavBarItem(display_name="My Profile", link=reverse_lazy("my_profile")))
    login_form = AuthenticationForm(request)
    return {
        "navbar_items":navbar_items,
        "navbar_item_class":NavBarItem,
        "login_form":login_form,
    }