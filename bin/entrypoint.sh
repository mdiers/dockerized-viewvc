#!/bin/sh
/opt/viewvc/bin/make-database --hostname db --port 3306 --username root --password admin --dbname ViewVC
cat <<EOF | mysql --protocol=TCP --host=db --port=3306 --user=root --password=admin
CREATE USER 'viewvc' IDENTIFIED BY 'viewvc';
GRANT ALL ON ViewVC.* TO 'viewvc';
EOF
case ${VIEWVC_MODE} in
    standalone)
        exec python3 -u /opt/viewvc/bin/standalone.py --host 0.0.0.0 --port 80 --config-file /opt/viewvc/viewvc.conf 2>&1
        ;;
    wsgi)
        rm -rf /run/httpd/* /tmp/httpd*
        exec /usr/sbin/httpd -DFOREGROUND
        ;;
    *)
        echo "ERROR: Unsupported value for VIEWVC_MODE environment variable." 2>&1
        ;;
esac
