import os
import sys

sys.path.append('/home/sites/public_html/db.frsilent.com/public')
sys.path.append('/home/sites/public_html/db.frsilent.com/public/challenge_site')

os.environ['DJANGO_SETTINGS_MODULE'] = 'settings'
import django.core.handlers.wsgi
application = django.core.handlers.wsgi.WSGIHandler()