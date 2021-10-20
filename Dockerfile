FROM openjdk:8-jdk-alpine as build
LABEL maintainer="nappemy"
WORKDIR /workspace/app
COPY src src
COPY pom.xml .
RUN mkdir dependency && cd dependency

FROM openjdk:8-jdk-alpine
RUN addgroup -S nappemy && adduser -S nappemy -G nappemy
USER nappemy
VOLUME [ "/tmp" ]
ENTRYPOINT [ "java","-cp","app:app/lib/*" ]