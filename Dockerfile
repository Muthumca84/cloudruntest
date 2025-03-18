# 🌟 Stage 1: Build the application using Gradle
FROM eclipse-temurin:17-jdk-jammy AS builder
WORKDIR /opt/app

# Copy Gradle Wrapper and build files
COPY gradlew build.gradle settings.gradle ./
COPY gradle/ gradle/

# Fix permission issue for Gradle Wrapper
RUN chmod +x gradlew

# Copy the application source code
COPY src/ src/

# Build the application
RUN ./gradlew clean build --no-daemon --stacktrace

# 🌟 Stage 2: Create the runtime image
FROM eclipse-temurin:17-jre-jammy
WORKDIR /opt/app

# Expose the application port
ENV PORT 8080
EXPOSE 8080

# Copy built JAR files
COPY --from=builder /opt/app/build/libs/*.jar /opt/app/app.jar

# Ensure JAR has execution permissions
RUN chmod +x /opt/app/app.jar

# Run the application
CMD ["java", "-jar", "/opt/app/app.jar"]
