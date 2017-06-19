FROM frolvlad/alpine-oraclejdk8:slim
VOLUME /tmp
ADD sample-acs-k8s-1.0-SNAPSHOT.jar app.jar
RUN sh -c "touch /app.jar"
RUN sh -c "chmod 0644 /app.jar"
ENV JAVA_OPTS=""
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar /app.jar"]
