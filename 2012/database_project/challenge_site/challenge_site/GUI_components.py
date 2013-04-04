class NavBarItem(object):
    css_class="navbar_item"
    def __init__(self, display_name=None, link=None):
        self.link=link
        self.display_name=display_name