# Internet blocker
This is set of simple scripts that disable Internet on your Wi-Fi router at night to allow you sleep instead of browsing.

Idea is to stop Internet routing and send all your requests to the local http server at specific time of a day (2 AM
 for default). In the morning (8 AM) everything will be restored. 

To help user to understand what is going on, all the HTTP requests will be responded with simple page with information about block. 
Blocking and routing are performed using iptables and DNAT.

## Files
index.html - page, where user will be redirected at night
inet.sh - enables/disables internet
prepare.sh - downloads media files, which are needed by for index.html (GIF animation of sheep jumping over fence. 
It is non-free so I doubt that I can include it here directly.)

## Setup
This is example of configuration. It was performed on RT-14NU router with Padavan firmware. Steps for OpenWrt should be very similar.
Needed software: cron, lighttpd.

Add following lines to your crontab.conf. In this case internet will be disabled at 2AM and enabled back at 8AM.
In my case cron configuration was performed using web interface, but usually it is located in /etc/crontab.conf file.

```
0 2 * * * /opt/wwwerror/inet.sh disable
0 8 * * * /opt/wwwerror/inet.sh enable
```

Put this lighttpd configuration into /etc/lighttpd/lighttpd.conf

```
server.document-root = "/opt/wwwerror/"

server.port = 8088
server.bind = "192.168.1.1"

index-file.names = ( "index.html" )
mimetype.assign = (
  ".html" => "text/html",
  ".gif" => "image/gif",
)
```

document-root is where index.html is located. Server bind address is LAN address of router. Port can be changed, but inet.sh
should then be changed as well.

At last, make your cron and lighttpd start at system startup. This step varies for different distros. 
In my case cron was already automatically started. And for lighttpd the easiest way was to append lines 
to "Run After Router Started:" script using web-interface

```
lighttpd -f /opt/etc/lighttpd/lighttpd.conf
```

Now reboot your router and everything should work.
