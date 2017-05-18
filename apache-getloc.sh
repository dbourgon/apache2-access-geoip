#!/bin/bash
#
# Tool to monitor the Apache2 access.log.
# Prints unique connections and their geoip
# location.


# Delete temporary files on ctrl+c
cleanup() {
        rm /tmp/loc.tmp
        rm /tmp/loc.1.tmp
        exit
}

trap cleanup SIGINT SIGTERM

# Create temporary file to store
# list of IP addresses
echo '' > /tmp/loc.tmp

# Main loop
while true;
do
        sleep 2
        # Create an array with IP addressed from access.log
        IFS=' \n' read -r -a array <<< `sudo tail /var/log/apache2/access.log | egrep -o "[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}"`
        echo '' > /tmp/loc.1.tmp

        # Look at each element in the array
        for x in "${array[@]}"
        do
                # If neither files contain the IP in x
                # then it is new, query geoip database
                if grep -Fxq "$x" /tmp/loc.tmp || grep -Fxq "$x" /tmp/loc.1.tmp
                then
                        printf ''
                else
                        time=`date '+%X'`
                        echo -e "\033[32m ---------$time----------- \033[0m"
                        geoiplookup $x
                        echo -e "\033[32m -------[$x]-------- \033[0m\n"
                fi

                echo "$x" >> /tmp/loc.1.tmp

        done

        mv -f /tmp/loc.1.tmp /tmp/loc.tmp

done
