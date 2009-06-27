--- etc/init.d/rc.net.orig	2009-03-22 01:11:05.000000000 +0100
+++ etc/init.d/rc.net	2009-03-22 01:11:06.000000000 +0100
@@ -57,9 +57,25 @@
    WLAN_TEST=0
 fi
 
+# Do we have a UPnP server (igdd) or was ist stripped from the firmware?
+_igdd=$(basename $(which igdd) 2> /dev/null)
+# Does a multid option to start without UPnP device (-u) exist?
+_multid_upnp=$(/sbin/multid -? 2>&1 | grep upnp)
+# Does a dsld option to start without igd (-g) exist?
+_dsld_upnp=$(/sbin/dsld -? 2>&1 | grep igd)
+# Set multid "no UPnP" option, if
+#   a) it has the parameter at all AND
+#   b) igdd binary does *not* exist
+[ "$_multid_upnp" ] && [ ! "$_igdd" ] && MULTIDPARAM="$MULTIDPARAM -u"
+# Set dsld "no igd" option, if
+#   a) it has the parameter at all AND
+#   b) igdd binary does *not* exist
+[ "$_dsld_upnp" ] && [ ! "$_igdd" ] && DSLDDPARAM="-g"
+
 
 igddstart()
 {
+	 [ "$_igdd" ] || return;
    if [ "`pidof igdd`" = "" ] ; then
       igdd $VERBOSEPARAM
       sleep 1
@@ -285,9 +301,9 @@
    if [ "$CONFIG_DSL" ] ; then
      if [ "`pidof dsld`" = "" ] ; then
        if [ "$CONFIG_RAMSIZE" = 8 ] ; then
-         dsld -i -n $NICEPARAM -r 600 $VERBOSEPARAM
+         dsld -i -n $NICEPARAM -r 600 $VERBOSEPARAM $DSLDDPARAM
        else
-         dsld -i -n $NICEPARAM $VERBOSEPARAM
+         dsld -i -n $NICEPARAM $VERBOSEPARAM $DSLDDPARAM
        fi
      fi
    fi
