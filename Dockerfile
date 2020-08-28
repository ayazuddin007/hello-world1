# Pull base image 
From tomcat:8

# Maintainer 
MAINTAINER "ayaz@gmail.com" 

# Copy war file
COPY ./webapp.war /usr/local/tomcat/webapps

