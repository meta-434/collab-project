#Script must be run with root priviledges!
if [ "$(whoami)" != "root" ]; then
    echo "gotinymb>> Error: script must be run as root! Exiting script."
    exit 1
fi

#Run from the proper directory
#/home/someone/collab-project/tinymb
#or
#/usr/lib/python2.7/site-packages/tinymb
#So make sure we're at the right location
if ! [ -a `pwd | grep "/tinymb"` ]; then
    echo "gotinymb>> Wrong directory! You need to be at /tinymb"
    echo "gotinymb>> Exiting tinymb script."
    exit 1
fi
if ! [ -f app.py ]; then
    echo "gotinymb>> Error: Cannot find app.py"
    echo "gotinymb>> cd into the directory with app.py"
    echo "gotinymb>> It is probably in /home/someone/collab-project/tinymb/"
    
    echo "gotinymb>> Exiting tinymb script."
    exit 1
fi


#if /var/www/tinymb doesn't exist, create it
if [ ! -d "/var/www/tinymb" ];then
    echo "gotinymb>> Creating folder /var/www/tinymb"
    mkdir /var/www/tinymb
fi

#Put local files to appropriate places
echo "gotinymb>> Copying tinymb.conf to /etc/httpd/conf.d"
cp -f conf/tinymb.conf /etc/httpd/conf.d/
echo "gotinymb>> Copying web-app to /var/www/tinymb"
cp -rf ./* /var/www/tinymb

#Make sure pip is instsalled.
if [ ! -f /usr/bin/pip ]; then
    echo "gotinymb>> You need to install pip."
    echo "gotinymb>> Download python's getpip.py or whatever it is."
    echo "gotinymb>> Exiting gotinymb script"
    exit 1
fi

echo "gotinymb>> assuming apache, i.e. httpd, is installed."
#Make sure apache is set up correctly.
#check for mod_wsgi.x86_64
if rpm -q mod_wsgi.x86_64 | grep "not installed" 1> /dev/null; then
    echo "gotinymb>> You need mod_wsgi.x86_64"
    echo "gotinymb>> Use yum install -y mod_wsgi.x64_64"
    echo "gotinymb>> Exiting gotinymb script"
    exit 1
fi
#make sure /etc/httpd/conf/httpd.conf has "Include conf.d/tinymb.conf"
if ! grep -q "Include conf.d/tinymb.conf" /etc/httpd/conf/httpd.conf;
then echo "Include conf.d/tinymb.conf" >> /etc/httpd/conf/httpd.conf
fi

#Set up virtual environment.
echo "gotinymb>> Setting up virtual environment"
cd /var/www/tinymb
pip install virtualenv
virtualenv venv
source venv/bin/activate
pip install flask
echo "gotinymb>> eventually install flask-mysql too"


# I was getting "AH00128: File does not exist: /var/www/html/tinymb"
# The fix was to make sure that the Include for tinymb
# diretive in conf/httpd.conf came before the Include for canary.
# and once I switched them, localhost/canary was returning 404
# and error_log said "File does not exist: /var/www/html/canary".
# Now wsgi is supposed to be able to allow multiple websites on the
# same server, so why does the first website boot off the second?
# For one thing, they are using the same DNS (i.e. localhost) and
# the tutorials were telling me that wsgi has different websites
# when the ServerName-s are different.
# Nonetheless, when I search for canary or tinymb, I'm looking for a
# different url directory, so I would expect them not to exclude each 
# other.....

echo "gotinymb>> WARNING: assuming there are no conflicting conf files."

#Restart apache.
echo "gotinymb>> Restarting apache"
apachectl stop
echo "----------------------------------" >> /etc/httpd/logs/error_log
apachectl start
