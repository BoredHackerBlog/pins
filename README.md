# pins
raspberry pi network sensor - uses suricata, evebox, and nodered

I initially compiled suricata and made my own container but then I ended up just using containers (suricata & evebox) by jasonish (https://github.com/jasonish). jasonish's containers were more lightweight and already had some of configuration (logroate, rule management, etc...) that I didn't wanna rework.

Since I'm not shipping the log data to a log management system/SIEM, I decided to add nodered and let it process eve.json file. You can setup whatever workflow you want inside nodered. I recommend trying Greynoise Community API https://twitter.com/andrew___morris/status/1375516879351992320 https://docs.greynoise.io/reference/get_v3-community-ip or abuseipdb https://www.abuseipdb.com/pricing

# Use Case
This repo should be good enough for learning suricata, writing alerts, testing alerts, and monitoring home traffic

# Technologies
- docker/docker-compose
- suricata
- evebox
- nodered

# Modifications
I modified the suricata config file
- stats interval is 60 seconds
- fast log is disabled
- alert payload extraction is enabled
- anomaly is disabled
- file force-magic is enabled
- smtp extended is enabled
- flow logging is disabled, it wouldn't be a bad idea to enable this, depending on how much traffic you're monitoring
- file-store is enabled, however, you'll need to add rules to extract files. the files should get extracted in default logs directory
- i added custom.rules under rule-files, this is related to custom.rules file included in this repo.

# Design
- review the docker-compose file and setup.sh file
- suricata by default monitors eth0
- suricata config is stored in ./suricata/etc/suricata and that's mounted into the container
- logs are in ./suricata/var/log/suricata and rules are in ./suricata/var/lib/suricata
- evebox mounts the suricata log directory in read-only mode and it also mounts ./evebox which stores evebox data
- nodered mounts ./nodered, which comes with one premade workflow for processing eve.json alert events
- nodered mounts suricata log directory in read-only mode as well

# Running the project
- 

# Usage
- 

# Warning
You will have to make some changes yourself for this project to be useful

Evebox and nodered do not have auth enabled. you can configure that yourself by looking at the documentation and/or use a reverse proxy with auth

You'll probably want to run this on raspberry pi 4 or any of the newer pi's. This should run fine on pi 3 though. I also recommend running pi from a hard drive or an ssd, or at least try to store the logs not on an sd card.
