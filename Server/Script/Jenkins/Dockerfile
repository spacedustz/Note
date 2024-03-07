FROM openjdk:11
RUN mkdir -p /app
WORKDIR /app
VOLUME /app
EXPOSE 8080
ARG JAR=space-1.5.4.jar
COPY ../../build/libs/${JAR} /koboot.jar
RUN chmod +x /koboot.jar
ENTRYPOINT ["java","-jar","-Dspring.profiles.active=test","-Xmx6144M","/koboot.jar"]