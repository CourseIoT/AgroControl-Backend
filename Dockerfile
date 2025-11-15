# Etapa de build: Maven + JDK 21
FROM maven:3.9.9-eclipse-temurin-21 AS build
WORKDIR /app

# Copiar pom y bajar dependencias
COPY pom.xml .
RUN mvn -q -DskipTests dependency:go-offline

# Copiar el código fuente
COPY src ./src

# Compilar el jar
RUN mvn -DskipTests clean package

# Etapa de runtime: solo JRE para producir una imagen más liviana
FROM eclipse-temurin:21-jre
WORKDIR /app

# Copiar el jar generado
COPY --from=build /app/target/backend-0.0.1-SNAPSHOT.jar app.jar

# Render pasa PORT, Spring lo lee con server.port=${PORT:8080}
ENV PORT=8080
EXPOSE 8080

ENV JAVA_OPTS=""

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]

