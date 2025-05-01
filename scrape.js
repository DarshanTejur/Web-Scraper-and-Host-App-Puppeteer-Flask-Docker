const fs = require('fs');
const puppeteer = require('puppeteer');

const url = process.env.SCRAPE_URL;

if (!url) {
    console.error('Please provide a SCRAPE_URL environment variable');
    process.exit(1);
}

(async () => {
    try {
        const browser = await puppeteer.launch({
            headless: true,
            args: ['--no-sandbox', '--disable-setuid-sandbox'],
            executablePath: '/usr/bin/chromium' // may vary; adjust if needed
        });

        const page = await browser.newPage();
        await page.goto(url, { waitUntil: 'domcontentloaded' });

        const data = await page.evaluate(() => {
            return {
                title: document.title || 'No Title Found',
                heading: document.querySelector('h1')?.innerText || 'No H1 Heading Found'
            };
        });

        fs.writeFileSync('scraped_data.json', JSON.stringify(data, null, 2));
        console.log('Data scraped and saved to scraped_data.json');

        await browser.close();
    } catch (err) {
        console.error('Error during scraping:', err.message);
        process.exit(1);
    }
})();
