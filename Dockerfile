FROM openjdk:8-jdk-alpine
ARG JAR_FILE=target/*.jar 
WORKDIR /app
COPY . /app
ENTRYPOINT ["java","-jar","/app"]
