const admin = require("firebase-admin");
const fs = require("fs");

const serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

const rawData = fs.readFileSync("assets/json/hindi_beginner.json");
const data = JSON.parse(rawData);

async function upload() {
  for (const lang in data) {
    for (const level in data[lang]) {
      for (const category in data[lang][level]) {
        const words = data[lang][level][category];

        for (const wordObj of words) {
          await db
            .collection("languages")
            .doc(lang)
            .collection("levels")
            .doc(level)
            .collection("categories")
            .doc(category)
            .collection("words")
            .add(wordObj);
        }
      }
    }
  }

  console.log("Upload complete");
}

upload();