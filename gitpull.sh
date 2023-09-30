#!/bin/bash

#git pull
cp /var/lib/tomcat9/homern/hrn.jar /var/lib/tomcat9/lib/
sudo systemctl restart tomcat9
