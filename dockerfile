# Stage 1: Node.js Scraper
FROM node:18-slim AS scraper

RUN apt-get update && apt-get install -y \
    chromium \
    fonts-liberation \
    --no-install-recommends && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PATH="/usr/bin:${PATH}"

COPY package.json package-lock.json ./
RUN npm ci

COPY scrape.js ./

# Stage 2: Python + Node runtime (final app)
FROM python:3.10-slim

# Install Node.js manually in final stage
RUN apt-get update && apt-get install -y \
    nodejs \
    npm \
    chromium \
    fonts-liberation \
    --no-install-recommends && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY --from=scraper /app ./

COPY server.py ./

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PATH="/usr/bin:${PATH}"

EXPOSE 5000

CMD node scrape.js && python server.py
