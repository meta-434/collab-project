#Goes to /var/www/tinymb/tinymb.wsgi
activate_this = '/var/www/tinymb/venv/bin/activate_this.py'
execfile(activate_this, dict(__file__=activate_this))

import sys
sys.path.insert(0, "/var/www/tinymb")

#from tinymb.app import app
from app import app
application = app
