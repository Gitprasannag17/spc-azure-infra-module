#!/bin/bash
sudo apt update
sudo apt install openjdk-17-jdk -y
mkdir ~/apps 
sudo cp -r /tmp/spc.jar/ ~/apps
cd ~/apps
#git clone https://github.com/Gitprasannag17/spring-pet-clinic-jar.git
pkill -f tmux
tmux new-session -d -s myapp 'java -jar spc.jar'
#java -jar spring-pet-clinic-jar/spring-petclinic-3.3.0-SNAPSHOT.jar & sleep 60s