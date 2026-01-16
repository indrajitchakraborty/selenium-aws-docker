FROM public.ecr.aws/docker/library/maven:3.9.6-eclipse-temurin-17

# Install required tools
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    gnupg \
    ca-certificates \
    unzip \
    --no-install-recommends

# Add Google Chrome signing key (PROPER way)
RUN mkdir -p /etc/apt/keyrings && \
    wget -qO- https://dl.google.com/linux/linux_signing_key.pub | \
    gpg --dearmor -o /etc/apt/keyrings/google-chrome.gpg

# Add Google Chrome repository
RUN echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome.gpg] \
    http://dl.google.com/linux/chrome/deb/ stable main" \
    > /etc/apt/sources.list.d/google-chrome.list

# Install Google Chrome
RUN apt-get update && apt-get install -y \
    google-chrome-stable \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy pom.xml first (cache dependencies)
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy project
COPY . .

# Run tests
CMD ["mvn", "test"]