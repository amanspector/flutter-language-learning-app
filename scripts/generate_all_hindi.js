const { execSync } = require('child_process');
const path = require('path');
const fs = require('fs');

const apiKey = "AIzaSyBuB7BiIF8SEZTynb-tV9LsuH2Ti98_dVk";

const levels = ['beginner', 'intermediate', 'advanced'];
const categories = ['career', 'school', 'travel'];

async function run() {
    console.log("🚀 Starting sequential Hindi vocabulary generation...");
    for (const level of levels) {
        for (const category of categories) {
            const fileName = `hi_${level}_${category}.json`;
            const outputPath = `./assets/data/${fileName}`;

            // Skip already generated files dynamically
            if (fs.existsSync(outputPath)) {
                console.log(`⏩ Skipping already generated file: ${fileName}`);
                continue;
            }

            console.log(`\n----------------------------------------`);
            console.log(`Generating: ${fileName}`);

            try {
                // Execute generate_vocab.js sequentially using standard node
                const scriptPath = path.join(__dirname, 'generate_vocab.js');
                const command = `node "${scriptPath}" ${apiKey} English Hindi ${level} ${category} "${outputPath}"`;

                execSync(command, { stdio: 'inherit' });
            } catch (e) {
                console.error(`❌ Failed to generate ${fileName}:`, e.message);
            }

            // Sleep 5 seconds between runs to stay safe under rate limits
            console.log("⏳ Sleeping 5 seconds to avoid API rate limit spikes...");
            await new Promise(resolve => setTimeout(resolve, 5000));
        }
    }
    console.log("\n🎉 Hindi vocabulary generation completed successfully!");
}

run().catch(err => {
    console.error("Fatal run error:", err);
});
