import os
import json
import sys
import urllib.request
import urllib.error

# API Config
API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent"

def call_gemini_api(api_key, prompt):
    """Calls the Gemini API using python's built-in urllib to avoid external dependencies."""
    url = f"{API_URL}?key={api_key}"
    headers = {"Content-Type": "application/json"}
    
    payload = {
        "contents": [
            {
                "parts": [
                    {"text": prompt}
                ]
            }
        ],
        "generationConfig": {
            "responseMimeType": "application/json"
        }
    }
    
    req = urllib.request.Request(url, data=json.dumps(payload).encode("utf-8"), headers=headers)
    try:
        with urllib.request.urlopen(req) as response:
            res_data = json.loads(response.read().decode("utf-8"))
            text_response = res_data["candidates"][0]["content"]["parts"][0]["text"]
            return json.loads(text_response)
    except urllib.error.HTTPError as e:
        print(f"HTTP Error: {e.code} - {e.read().decode('utf-8')}")
        sys.exit(1)
    except Exception as e:
        print(f"Error calling Gemini: {e}")
        sys.exit(1)

def generate_vocab(api_key, native_lang, learning_lang, level, category, output_path):
    print(f"🚀 Starting generation for {learning_lang} ({level} - {category})...")
    
    unique_words = []
    seen_words = set()
    target_count = 100
    batch_size = 25
    
    while len(unique_words) < target_count:
        remaining = target_count - len(unique_words)
        current_batch_size = min(batch_size, remaining)
        
        print(f"⏳ Generating batch of {current_batch_size} words (Progress: {len(unique_words)}/{target_count})...")
        
        existing_list = ", ".join(list(seen_words))
        prompt = f"""
        Generate a list of exactly {current_batch_size} unique vocabulary words in the learning language: '{learning_lang}' for a native '{native_lang}' speaker.
        The target experience level is '{level}' and the category is '{category}'.

        Strict Requirements:
        1. All words must be highly accurate and relevant to the category '{category}' and level '{level}'.
        2. Do NOT generate any of the following already existing words: [{existing_list}].
        3. Make sure all 'options' lists contain exactly 4 options: the word itself (which must match 'correct_answer' exactly) and 3 other realistic distractors in '{learning_lang}'.
        4. For 'examples', provide exactly 1 example sentence using the word. The sentence must be simple, natural, and split into its words in the 'sentence_parts' list.

        Output must match this JSON schema exactly:
        {{
            "words": [
                {{
                    "word": "word in {learning_lang}",
                    "translation_english": "English translation",
                    "translation_native": "native language translation",
                    "pronunciation": "phonetic pronunciation / transliteration",
                    "examples": [
                        {{
                            "sentence": "example sentence using the word",
                            "translation_english": "English translation of sentence",
                            "translation_native": "native language translation of sentence",
                            "sentence_parts": ["word1", "word2", "word3"],
                            "level": "easy"
                        }}
                    ],
                    "options": ["word in {learning_lang}", "distractor1", "distractor2", "distractor3"],
                    "correct_answer": "word in {learning_lang}"
                }}
            ]
        }}
        """
        
        batch_data = call_gemini_api(api_key, prompt)
        
        if not batch_data or "words" not in batch_data:
            print("⚠️ Invalid response from API, retrying...")
            continue
            
        added_in_batch = 0
        for item in batch_data["words"]:
            word = item.get("word", "").strip()
            if not word:
                continue
            
            # Avoid duplicate words
            if word.lower() not in seen_words:
                seen_words.add(word.lower())
                unique_words.append(item)
                added_in_batch += 1
                
        print(f"✅ Added {added_in_batch} new unique words in this batch.")
        
        if added_in_batch == 0:
            print("⚠️ Model did not produce any new unique words in this loop. Retrying...")

    # Trim to exactly target_count just in case
    unique_words = unique_words[:target_count]

    # Create final JSON file
    final_output = {
        "metadata": {
            "language": learning_lang,
            "native_language": native_lang,
            "level": level,
            "category": category,
            "total_words": len(unique_words)
        },
        "words": unique_words
    }

    # Ensure output directory exists
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    
    with open(output_path, "w", encoding="utf-8") as f:
        json.dump(final_output, f, ensure_ascii=False, indent=4)
        
    print(f"\n🎉 Successfully wrote {len(unique_words)} words to: {output_path}")

if __name__ == "__main__":
    if len(sys.argv) < 7:
        print("Usage: python generate_vocab.py <API_KEY> <NATIVE_LANG> <LEARNING_LANG> <LEVEL> <CATEGORY> <OUTPUT_PATH>")
        print("Example: python generate_vocab.py AIzaSy... English Spanish Intermediate career ./assets/data/en/es/intermediate_career.json")
        sys.exit(1)
        
    api_key = sys.argv[1]
    native_lang = sys.argv[2]
    learning_lang = sys.argv[3]
    level = sys.argv[4]
    category = sys.argv[5]
    output_path = sys.argv[6]
    
    generate_vocab(api_key, native_lang, learning_lang, level, category, output_path)
