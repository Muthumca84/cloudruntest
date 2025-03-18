# 🌟 Stage 1: Build the application using Gradle
FROM eclipse-temurin:17-jdk-jammy AS builder
WORKDIR /opt/app

# Copy Gradle Wrapper and build files
COPY gradlew build.gradle settings.gradle ./
COPY gradle/ gradle/

# Fix permission issue for Gradle Wrapper
RUN chmod +x gradlew

# Download dependencies for offline use
RUN ./gradlew dependencies --no-daemon

# Copy the application source code
COPY src/ src/

# Build the application
RUN ./gradlew clean build --no-daemon

# 🌟 Stage 2: Create the runtime image
FROM eclipse-temurin:17-jre-jammy
WORKDIR /opt/app

# Expose the application port
EXPOSE 8080

# Copy the built JAR files from the builder stage
COPY --from=builder /opt/app/build/libs/*.jar /opt/app/

# 🔹 Print the list of JAR files in /opt/app
RUN ls -lh /opt/app/

# Dynamically find and run the JAR file
CMD ["sh", "-c", "java -jar /opt/app/$(ls /opt/app | grep '.jar' | head -n 1)"]
