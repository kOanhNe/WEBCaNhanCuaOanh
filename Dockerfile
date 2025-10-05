FROM tomcat:9.0-jdk11
WORKDIR /usr/local/tomcat
RUN rm -rf webapps/*
COPY target/personal-web.war webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]