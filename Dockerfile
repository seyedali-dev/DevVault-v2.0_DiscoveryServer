FROM eclipse-temurin:22_36-jre as builder
LABEL authors="Seyed-Ali"
WORKDIR application
ARG JAR_FILE=target/discovery-server.jar
COPY ${JAR_FILE} application.jar
RUN java -Djarmode=layertools -jar application.jar extract

FROM eclipse-temurin:22_36-jre

# Install curl
RUN apt-get update && apt-get install -y curl

WORKDIR application
COPY --from=builder application/dependencies ./
COPY --from=builder application/spring-boot-loader ./
COPY --from=builder application/snapshot-dependencies ./
COPY --from=builder application/application ./
ENTRYPOINT ["java", "org.springframework.boot.loader.launch.JarLauncher"]

EXPOSE 8761