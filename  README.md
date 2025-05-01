# Web Scraper and Host App – Puppeteer + Flask + Docker

# Overview

This project showcases a DevOps-enhanced architecture that combines Node.js (Puppeteer) for dynamic web scraping and Python (Flask) for serving that data. The entire setup is wrapped inside a multi-stage Docker container to ensure clean builds and portability.

# Features

Dynamic Scraper (Node.js + Puppeteer): Scrapes the title and first <h1> tag from any user-supplied URL.

Python Flask Server: Hosts the scraped data via REST API (/ endpoint).

Multi-stage Docker Build: Single Docker image running both scrapers and server.

Environment Variable Input: User supplies the target URL dynamically using SCRAPE_URL.

# Technologies Used

    * Backend

    * Node.js + Puppeteer (Web scraping)

    * Python Flask (REST API)

    * DevOps

    * Docker (Multi-stage image)

    * Chromium (Headless browser inside container)

# Folder Structure

web-scraper-app/
│
├── scrape.js            # Puppeteer script to scrape webpage
├── server.py            # Flask server to serve scraped data
├── Dockerfile           # Multi-stage Docker build file
├── package.json         # Node dependencies
├── requirements.txt     # Python dependencies
└── README.md            # Project documentation

# Step-by-Step Setup Instructions

You don’t need to modify any files manually. Follow these steps to build and run the project locally:

    1. Extract the Project Folder
        After downloading or receiving the ZIP file:
            
            unzip web-scraper-app.zip
            cd web-scraper-app

    2. Install Requirements
        Ensure the following tools are installed on your machine:

            Docker --------------------- Install Docker
            Node.js & npm -------------- Install Node.js
            Python 3 ------------------- Install Python

    3. Build the Docker Image
        Inside the web-scraper-app/ directory:

            docker build -t web-scraper-app .

    4. Run the Docker Container (with Target URL)

        docker run -e SCRAPE_URL=https://exactspace.co/ -p 5000:5000 web-scraper-app

    5. View Output
        Once the container is running, open your browser and go to:

            http://localhost:5000

        You’ll see JSON output like:

        {
          "title": "ExactSpace",
          "heading": "We help industries accelerate to net zero using actionable intelligence"
        }

# Access scraped_data.json Locally

Since the file is stored inside the container:

    docker ps                # Find container ID
    docker cp <container_id>:/app/scraped_data.json ./scraped_data.json
    cat scraped_data.json    # View contents

# Common Errors I Faced

    * Puppeteer Chromium Download Fails

        Cause: Slow or unstable internet during Docker image build.Fix: Ensured stable network connection during docker build.

    * EACCES Permission Errors During Container Startup

        Cause: Puppeteer needs extra permissions inside the container.Fix: Passed --no-sandbox and --disable-setuid-sandbox flags to Chromium launch.

    * json.decoder.JSONDecodeError in Flask

        Cause: Empty or invalid scraped_data.json. Fix: Added error handling in Flask to check if file exists and has valid content.

# Future Implementation Ideas

    * Add support for scraping all headings (h1 through h6) and meta tags

    * Add UI to input the URL directly via a form instead of env var

    * Automatically export to .csv or .xml formats

    * Use Docker volumes to directly save scraped_data.json on host

    * Add test coverage with CI tools like GitHub Actions
