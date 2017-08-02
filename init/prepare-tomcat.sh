#!/bin/bash -ex

echo "Update system and install JDK"
sudo apt-get update
sudo apt-get dist-upgrade -y
sudo apt-get install -y default-jdk

echo "Create user: tomcat"
grep -q ^tomcat: /etc/group || sudo groupadd tomcat
grep -q ^tomcat: /etc/passwd || sudo useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat

echo "Prepare tomcat executables"
curl -O http://www-us.apache.org/dist/tomcat/tomcat-8/v8.5.16/bin/apache-tomcat-8.5.16.tar.gz
sudo mkdir /opt/tomcat
sudo tar xzvf apache-tomcat-8*.tar.gz -C /opt/tomcat --strip-components=1

echo "Update tomcat directory permissions"
cd /opt/tomcat
sudo chgrp -R tomcat /opt/tomcat
sudo chmod -R g+r conf
sudo chmod g+x conf
sudo chown -R tomcat webapps work temp logs

echo "Create systemd service for tomcat"
JAVA_HOME=$(sudo update-java-alternatives -l | awk '{print $3}')/jre
echo $JAVA_HOME
cat <<EOF | sudo tee /etc/systemd/system/tomcat.service
[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=forking

Environment=JAVA_HOME=$JAVA_HOME
Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
Environment=CATALINA_HOME=/opt/tomcat
Environment=CATALINA_BASE=/opt/tomcat
Environment='CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC'
Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

User=tomcat
Group=tomcat
UMask=0007
RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable tomcat

# adjust the firewall
echo "Adjust firewall settings to allow port 8080"
sudo ufw allow 8080

#
