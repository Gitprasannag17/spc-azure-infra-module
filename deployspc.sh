#!/bin/bash
sudo apt update
sudo apt install openjdk-17-jdk -y
mkdir ~/apps 
git clone https://github.com/Gitprasannag17/spring-pet-clinic-jar.git
pkill -f tmux
tmux new-session -d -s myapp 'java -jar ~/apps/spring-pet-clinic-jar/spring-petclinic-3.3.0-SNAPSHOT.jar'