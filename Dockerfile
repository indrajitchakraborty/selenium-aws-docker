FROM maven:3.9.6-eclipse-temurin-17

# Install system dependencies
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    gnupg \
    ca-certificates \
    unzip \
    --no-install-recommends

# Add Google Chrome repository (modern way)
RUN mkdir -p /etc/apt/keyrings \
    && wget -q https://dl.google.com/linux/linux_signing_key.pub \
       -O /etc/apt/keyrings/google-linux-signing-keyring.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/google-linux-signing-keyring.gpg] \
       http://dl.google.com/linux/chrome/deb/ stable main" \
       > /etc/apt/sources.list.d/google.list

# Install Chrome
RUN apt-get update && apt-get install -y \
    google-chrome-stable \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy pom.xml first (Docker layer caching)
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy project files
COPY . .

# Run tests
CMD ["mvn", "test"]
