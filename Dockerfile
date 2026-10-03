# Stage 1: Build ứng dụng (Sử dụng Maven với JDK 21)
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
# Build file JAR và bỏ qua quá trình chạy test
RUN mvn clean package -DskipTests

# Stage 2: Chạy ứng dụng (Sử dụng JRE 21 bản Alpine cực nhẹ)
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
# Copy file JAR đã được build từ Stage 1 sang Stage 2
COPY --from=build /app/target/*.jar app.jar
# Mở port mặc định của Spring Boot
EXPOSE 8080
# Lệnh khởi chạy ứng dụng
ENTRYPOINT ["java", "-jar", "app.jar"]