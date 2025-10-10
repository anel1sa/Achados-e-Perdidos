# syntax=docker/dockerfile:1
FROM maven:3.9.8-eclipse-temurin-25 AS build
WORKDIR /workspace

# Cache dependencies first
COPY pom.xml .
RUN mvn -B -q -DskipTests dependency:go-offline

# Build application
COPY src ./src
RUN mvn -B -DskipTests package

FROM eclipse-temurin:25-jre
WORKDIR /app

ENV JAVA_OPTS=""

COPY --from=build /workspace/target/API-0.0.1-SNAPSHOT.jar /app/app.jar

EXPOSE 8080

ENTRYPOINT ["sh","-c","java $JAVA_OPTS -jar /app/app.jar"]


