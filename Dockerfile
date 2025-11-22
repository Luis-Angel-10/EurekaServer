# Etapa 1: Build
FROM eclipse-temurin:17-jdk AS build

WORKDIR /app

# Copiar archivos necesarios para Maven Wrapper
COPY pom.xml .
COPY mvnw .
COPY .mvn .mvn

# Hacer ejecutable el wrapper
RUN chmod +x mvnw

# Descargar dependencias
RUN ./mvnw dependency:go-offline

# Copiar código fuente
COPY src src

# Compilar con Maven Wrapper
RUN ./mvnw clean package -DskipTests

# Etapa 2: Runtime
FROM eclipse-temurin:17-jre

WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

EXPOSE 8761

ENTRYPOINT ["java", "-jar", "/app/app.jar"]
