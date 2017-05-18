# apache2-access-geoip
Small bash script to monitor the Apache2 access.log. Prints unique connections and the GeoIP location information for the IP.

I use this on a personal web server that does not receive a lot of traffic. I was curious about where connections were coming from and got tired of manually entering the IP addresses into geoiplookup. 

Requires the following packages (apt):
geoip-bin
geoip-database-contrib
