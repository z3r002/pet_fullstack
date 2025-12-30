# Use the official Dart image
FROM dart:stable

# Set working directory
WORKDIR /app

# Copy pubspec files first for better layer caching
COPY pubspec.* ./

# Install dependencies
RUN dart pub get

# Copy the rest of the application
COPY . .

# Expose the port the app runs on
EXPOSE 8080

# Start the server in development mode
CMD ["dart", "run", "bin/server.dart"]