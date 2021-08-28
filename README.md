# pins
raspberry pi network sensor - uses suricata, evebox, and nodered

I initially compiled suricata and made my own container but then I ended up just using containers (suricata & evebox) by jasonish (https://github.com/jasonish). jasonish's containers were more lightweight and already had some of configuration (logroate, rule management, etc...) that I didn't wanna rework.

Since I'm not shipping the log data to a log management system/SIEM, I decided to add nodered and let it process eve.json file. You can setup whatever workflow you want inside nodered. I recommend trying Greynoise Community API https://twitter.com/andrew___morris/status/1375516879351992320 https://docs.greynoise.io/reference/get_v3-community-ip or abuseipdb https://www.abuseipdb.com/

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

## requirements
- docker / docker-compose (https://dev.to/elalemanyo/how-to-install-docker-and-docker-compose-on-raspberry-pi-1mo)
- try installing libseccomp 2.5.1-1, if you're running into permission issues for whatever reason (https://stackoverflow.com/a/67085069 wget way works fine)
- git

## setup
- make sure you setup port mirroring on your switch and connect the mirrored port to the pi (see diagram under "Network - Network Monitoring" section here: https://boredhackerblog.github.io/homelabsecuritymonitoring/
- connect to the pi via wifi or another port
- setup eth0 to sniff, see slides 15 to 18 (just do ethtool on slide 18) here https://www.activecountermeasures.com/raspberry_pi_sensor/How%20to%20use%20a%20Raspberry%20Pi%20as%20a%20network%20sensor.pdf -- essentialy, you wanna make sure eth0 is on promiscuous mode and is not getting an IP. you may have to do some research if the slides didn't help
- git clone this repo
- cd into pins directory, chmod +x setup.sh
- run ./setup.sh, you only need to do this once

setup.sh sets up nodered node-red-node-tail module so you can tail eve.json file. it also sets up rules for suricata.

# Usage
- general docker-compose commands apply here. run `docker-compose up -d` to run containers and `docker-compose stop` to stop the containers
- to access evebox go to http://PI_IP:5636 and to access nodered go to http://PI_IP:1880
- to manage suricata rules, you can use the docker exec command like shown here: https://github.com/jasonish/docker-suricata#suricata-update
- suricata-update documentation https://suricata-update.readthedocs.io/en/latest/quickstart.html
- if you do decide to write custom rules to store files, you can use suricatactl to clean things up from time to time https://suricata.readthedocs.io/en/suricata-6.0.1/manpages/suricatactl-filestore.html
- custom rules can be added to custom.rules file. Re rule SIDs: https://doc.emergingthreats.net/bin/view/Main/SidAllocation
- file extraction documentation and examples: https://suricata.readthedocs.io/en/suricata-6.0.0/file-extraction/file-extraction.html https://fossies.org/linux/suricata/rules/files.rules 
- cron jobs and scheduled tasks you may wanna add: you may want to add cron task that runs docker exec then uses suricatactl to prune files, you'll also want to do the same for rule updates, docker exec documentation: https://docs.docker.com/engine/reference/commandline/exec/

# Warning
You will have to make some changes yourself for this project to be useful

Evebox and nodered do not have auth enabled. you can configure that yourself by looking at the documentation and/or use a reverse proxy with auth

You'll probably want to run this on raspberry pi 4 or any of the newer pi's. This should run fine on pi 3 though. I also recommend running pi from a hard drive or an ssd, or at least try to store the logs not on an sd card.
