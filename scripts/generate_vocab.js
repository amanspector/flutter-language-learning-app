const fs = require('fs');
const path = require('path');
const https = require('https');

// API Config
let currentModel = "gemini-3.1-flash-lite";
const BACKUP_MODELS = [
    "gemini-2.5-flash",
    "gemini-3.5-flash",
    "gemini-flash-latest",
    "gemini-2.0-flash-lite",
    "gemini-2.0-flash-lite-001",
    "gemini-2.5-flash-lite",
    "gemini-flash-lite-latest",
    "gemini-3.1-flash-lite-preview",
    "gemini-3-flash-preview",
    "gemini-3-pro-preview",
    "gemini-2.5-pro",
    "gemini-pro-latest",
    "gemini-3.1-pro-preview",
    "gemini-3.1-pro-preview-customtools",
    "gemini-2.0-flash-001",
    "gemini-2.0-flash"
];

function callGeminiApi(apiKey, prompt) {
    return new Promise((resolve, reject) => {
        const url = `https://generativelanguage.googleapis.com/v1beta/models/${currentModel}:generateContent?key=${apiKey}`;
        const payload = JSON.stringify({
            contents: [
                {
                    parts: [
                        { text: prompt }
                    ]
                }
            ],
            generationConfig: {
                responseMimeType: "application/json"
            }
        });

        const options = {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Content-Length': Buffer.byteLength(payload)
            }
        };

        const req = https.request(url, options, (res) => {
            let data = '';
            res.on('data', (chunk) => { data += chunk; });
            res.on('end', () => {
                if (res.statusCode >= 400) {
                    reject(new Error(`HTTP Error ${res.statusCode}: ${data}`));
                    return;
                }
                try {
                    const resData = JSON.parse(data);
                    let textResponse = resData.candidates[0].content.parts[0].text.trim();

                    // Extract JSON substring to avoid parsing errors from LLM text noise
                    const firstBrace = textResponse.indexOf('{');
                    const lastBrace = textResponse.lastIndexOf('}');
                    if (firstBrace !== -1 && lastBrace !== -1) {
                        textResponse = textResponse.substring(firstBrace, lastBrace + 1);
                    }

                    resolve(JSON.parse(textResponse));
                } catch (e) {
                    reject(new Error(`Failed to parse response: ${e.message}. Raw response: ${data}`));
                }
            });
        });

        req.on('error', (e) => reject(e));
        req.write(payload);
        req.end();
    });
}

async function generateVocab(apiKey, nativeLang, learningLang, level, category, outputPath) {
    console.log(`🚀 Starting Node.js generation for ${learningLang} (${level} - ${category})...`);

    const uniqueWords = [];
    const seenWords = new Set();
    const targetCount = 100;
    const batchSize = 25;

    while (uniqueWords.length < targetCount) {
        const remaining = targetCount - uniqueWords.length;
        const currentBatchSize = Math.min(batchSize, remaining);

        console.log(`⏳ Generating batch of ${currentBatchSize} words (Progress: ${uniqueWords.length}/${targetCount})...`);

        const existingList = Array.from(seenWords).join(', ');
        const prompt = `
        Generate a list of exactly ${currentBatchSize} unique vocabulary words in the learning language: '${learningLang}' for a native '${nativeLang}' speaker.
        The target experience level is '${level}' and the category is '${category}'.

        Strict Requirements:
        1. All words must be highly accurate and relevant to the category '${category}' and level '${level}'.
        2. Do NOT generate any of the following already existing words: [${existingList}].
        3. Make sure all 'options' lists contain exactly 4 options: the word itself (which must match 'correct_answer' exactly) and 3 other realistic distractors in '${learningLang}'.
        4. For 'examples', provide exactly 3 example sentences of increasing difficulty (easy, medium, and hard) using the word. Each sentence must be natural and split into its individual words in the 'sentence_parts' list.

        Output must match this JSON schema exactly:
        {
            "words": [
                {
                    "word": "word in \${learningLang}",
                    "translation_english": "English translation of target word",
                    "translation_native": "native language translation of target word",
                    "pronunciation": "phonetic pronunciation / transliteration",
                    "examples": [
                        {
                            "sentence": "simple A1/A2 sentence using the word",
                            "translation_english": "English translation of easy sentence",
                            "translation_native": "native language translation of easy sentence",
                            "sentence_parts": ["word1", "word2", "word3"],
                            "level": "easy"
                        },
                        {
                            "sentence": "medium B1/B2 sentence using the word",
                            "translation_english": "English translation of medium sentence",
                            "translation_native": "native language translation of medium sentence",
                            "sentence_parts": ["word1", "word2", "word3"],
                            "level": "medium"
                        },
                        {
                            "sentence": "hard C1/C2 sentence using the word",
                            "translation_english": "English translation of hard sentence",
                            "translation_native": "native language translation of hard sentence",
                            "sentence_parts": ["word1", "word2", "word3"],
                            "level": "hard"
                        }
                    ],
                    "options": ["word in \${learningLang}", "distractor1", "distractor2", "distractor3"],
                    "correct_answer": "word in \${learningLang}"
                }
            ]
        }
        `;

        try {
            const batchData = await callGeminiApi(apiKey, prompt);
            if (!batchData || !Array.isArray(batchData.words)) {
                console.log("⚠️ Invalid response format from API, retrying...");
                continue;
            }

            let addedInBatch = 0;
            for (const item of batchData.words) {
                const word = (item.word || '').trim();
                if (!word) continue;

                if (!seenWords.has(word.toLowerCase())) {
                    seenWords.add(word.toLowerCase());
                    uniqueWords.push(item);
                    addedInBatch++;
                }
            }

            console.log(`✅ Added ${addedInBatch} new unique words in this batch.`);
            if (addedInBatch === 0) {
                console.log("⚠️ Model did not produce any new unique words in this loop. Retrying...");
            } else {
                // Sleep 5 seconds to remain safe under standard API RPM limits
                console.log("⏳ Sleeping 5 seconds before next batch query to stay under rate limits...");
                await new Promise(resolve => setTimeout(resolve, 5000));
            }
        } catch (err) {
            const errStr = err.message.toLowerCase();
            if (errStr.includes("resource_exhausted") || errStr.includes("429") || errStr.includes("quota") || errStr.includes("503") || errStr.includes("unavailable")) {
                const nextModel = BACKUP_MODELS.shift();
                if (nextModel) {
                    console.log(`\n⚠️ Model '${currentModel}' encountered an error (${err.message})! Switching to fallback model '${nextModel}'...`);
                    currentModel = nextModel;
                    // Wait 5 seconds to let network settle, then retry
                    await new Promise(resolve => setTimeout(resolve, 5000));
                    continue;
                }
            }
            console.log(`❌ Error in generation loop: ${err.message}.\n⏳ Waiting 15 seconds before retrying...`);
            await new Promise(resolve => setTimeout(resolve, 15000));
        }
    }

    // Trim to exactly targetCount
    const finalWords = uniqueWords.slice(0, targetCount);

    const finalOutput = {
        metadata: {
            language: learningLang,
            native_language: nativeLang,
            level: level,
            category: category,
            total_words: finalWords.length
        },
        words: finalWords
    };

    const dir = path.dirname(outputPath);
    if (!fs.existsSync(dir)) {
        fs.mkdirSync(dir, { recursive: true });
    }

    fs.writeFileSync(outputPath, JSON.stringify(finalOutput, null, 4), 'utf8');
    console.log(`\n🎉 Successfully wrote ${finalWords.length} words to: ${outputPath}`);
}

async function main() {
    const args = process.argv.slice(2);
    if (args.length < 6) {
        console.log("\n❌ Missing arguments!");
        console.log("Usage: node generate_vocab.js <API_KEY> <NATIVE_LANG> <LEARNING_LANG> <LEVEL> <CATEGORY> <OUTPUT_PATH>");
        console.log("\nSupported Parameters:");
        console.log("  - <NATIVE_LANG>:    e.g., English, Hindi, Arabic");
        console.log("  - <LEARNING_LANG>:  e.g., Spanish, Arabic");
        console.log("  - <LEVEL>:          beginner | intermediate | advanced  (maps 'advance' to 'advanced')");
        console.log("  - <CATEGORY>:       career | school | travel");
        console.log("\nExample:");
        console.log("  node scripts/generate_vocab.js AIzaSy... English Spanish intermediate career ./assets/data/es_intermediate_career.json\n");
        process.exit(1);
    }

    let [apiKey, nativeLang, learningLang, level, category, outputPath] = args;

    // Normalize level
    const lvlLower = level.toLowerCase();
    if (lvlLower === 'advance' || lvlLower === 'advanced') {
        level = 'advanced';
    } else {
        level = lvlLower;
    }

    await generateVocab(apiKey, nativeLang, learningLang, level, category, outputPath);
}

main().catch(err => {
    console.error("Fatal Error:", err);
    process.exit(1);
});
