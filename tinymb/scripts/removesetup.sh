#Run with root priviledges!
if [ "$(whoami)" != "root" ]; then
    echo "removesetup>> you need root priviledges!"
    echo "removesetup>> Exiting removestup script."
    exit 1
fi

rm -rf /var/www/tinymb
rm -f /etc/httpd/conf.d/tinymb.conf

#Edit file /etc/httpd/conf/httpd.conf "Include conf.d/tinymb.conf"
echo "removesetup>> I am lazy."
echo "removesetup>> PLEASE Edit file /etc/httpd/conf/httpd.conf"


apachectl stop
echo "----------------------------" >> /etc/httpd/logs/error_log
#apachectl start
echo "removesetup>> WARNING httpd.service stopped but NOT restarted."
echo "removesetup>> Edit /etc/httpd/conf/httpd.conf ..."
echo "removesetup>> remove or comment Include conf.d/tinymb.conf before restarting"
