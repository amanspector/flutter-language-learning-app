import 'package:chatbot_app/core/appconstants/text_constant.dart';

class VocabularyPrompts {
  static String buildVocabularyPrompt({
    required String language,
    required String nativeLanguage,
    required String experienceLevel,
    required String learningGoal,
    required int wordCount,
    required List<String> learnedWords,
    int? age,
  }) {
    final nativeLang = Textconstant.languageNames[nativeLanguage] ?? 'English';
    final isNativeEnglish =
        nativeLanguage.toLowerCase() == "en" ||
        nativeLanguage.toLowerCase() == "english" ||
        nativeLang.toLowerCase() == "english";
    final translationNativePlaceholder = isNativeEnglish
        ? "English translation"
        : "translation in $nativeLang";
    final translationEnglishPlaceholder = "English translation";

    final ageInstructions = _getAgeInstructions(age, learningGoal);
    final levelGuidelines = _getLevelGuidelines(experienceLevel);

    return """
You are a language curriculum expert. Generate exactly 100 vocabulary words.

TARGET LANGUAGE: $language
NATIVE LANGUAGE: $nativeLang
LEVEL: $experienceLevel
GOAL: $learningGoal
${age != null ? "USER AGE: $age\n" : ""}
$levelGuidelines
${_getGoalInstructions(learningGoal)}
${_getLanguageSpecificInstructions(language)}
$ageInstructions

=== MCQ RULES (apply to EVERY word) ===

SIBLING SETS: vehicles/colors/animals/fruits/clothes/furniture/emotions/family/food/body parts/professions/places/appliances/sports/office items

INVALID PATTERNS (never use):
- Generic: "यह मेरा ___ है" / "આ મારો ___ છે" / "वह एक ___ है" / "મેં ___ ખાધું"
- Any sentence where ANY sibling word fits the blank naturally
- Any sentence that violates the sentence length constraints for the user's level.
- Any sentence using only generic adjectives before blank: "good/local/nearby/big/nice + ___"
- Any sentence where the verb is generic: "went to/visited/saw/found + ___"

OPTIONS RULES:
- 4 options, same part of speech, no synonyms, no repeats
- correct_answer must exactly match word field including all diacritics/mātrās

ANCHOR TEST (mandatory for every word, every language):
After writing the sentence, mentally replace the blank with each wrong option.
If even ONE wrong option fits naturally → rewrite the sentence.

WEAK ANCHORS (never use in any language):
- "good/local/nearby + [blank]" → siblings fit
- "I went to the ___" → anything fits
- "The ___ was crowded/big/nice" → anything fits
- Any sentence where the blank is only modified by a generic adjective

STRONG ANCHORS (required patterns):
- Unique action only that word performs: "The surgeon operated in the ___"
- Specific purpose tied to word: "Bought fresh bread from the ___"
- Outcome tied to word: "Got stitches at the ___ after cutting my hand"
- Multiple context details: "Checked in at the ___ after the flight and dropped luggage"

=== FIELD RULES ===
- All "sentence" fields: MUST be in $language script only
- "sentence_parts": sentence split by spaces
- "question": examples[0].sentence with target word → ___
- "options": [correct_answer, wrong1, wrong2, wrong3] (same part of speech)
- Top-level "sentence_parts" = examples[0].sentence_parts
- "translation_english": English translation of the target word/sentence. If the target language is English, this should be the English word/sentence itself.
- "translation_native": Translation of the target word/sentence in the NATIVE LANGUAGE ($nativeLang).
- CRITICAL: Under no circumstances should "translation_english" or "translation_native" contain the target language ($language) unless that field is explicitly requested to be in that language.
${isNativeEnglish ? "- CRITICAL: Since the native language is English, BOTH translation_english and translation_native MUST be in English. Do NOT put the target language ($language) in any translation fields." : ""}

OUTPUT:
Valid JSON only. No markdown.
{
  "metadata": {"language":"$language","native_language":"$nativeLang","level":"$experienceLevel","category":"$learningGoal","total_words":$wordCount},
  "words": [{
    "word": "target word in $language",
    "translation_english": "$translationEnglishPlaceholder",
    "translation_native": "$translationNativePlaceholder",
    "pronunciation": "phonetic guide (how to pronounce the target word)",
    ${_outputJsonExamplePart(language, nativeLanguage)},
    "options": ["correct_answer","wrong1","wrong2","wrong3"],
    "correct_answer": "identical to word field"
  }]
}
Generate exactly 100 words now.
""";
  }
  // ${learnedWords.isNotEmpty ? "EXCLUDE these already learned words: ${learnedWords.join(', ')}\n" : ""}

  static String _getLevelGuidelines(String level) {
    switch (level.toLowerCase()) {
      case 'beginner':
        return """
=== LEVEL DESIGN: BEGINNER (A1-A2) ===
- Sentence Length: The A1/A2 example sentence and the MCQ "question" MUST be simple and very short: strictly 4 to 6 words total.
- Anchor Rule: The blank anchor must be a specific location noun or unique action verb.
- Language style: Simple daily words, no idioms, focus on nouns, basic verbs, and simple adjectives.
- Complexity: Do NOT generate long, complex, or multi-clause sentences. This is an absolute requirement.""";
      case 'intermediate':
        return """
=== LEVEL DESIGN: INTERMEDIATE (B1-B2) ===
- Sentence Length: The A1/A2 and B1/B2 example sentences and the MCQ "question" MUST be strictly 6 to 9 words total.
- Anchor Rule: Anchor the blank via a purpose clause or specific context.
- Language style: Conversational vocabulary, simple idioms allowed, mixed tenses.
- Complexity: Avoid making sentences overly complex or too long.""";
      case 'advanced':
        return """
=== LEVEL DESIGN: ADVANCED (C1-C2) ===
- Sentence Length: Example sentences and MCQ questions can be 9 to 14 words total.
- Anchor Rule: Use multiple context details that together eliminate all sibling options.
- Language style: Sophisticated vocabulary, idioms, cultural references, and complex academic/professional terms.""";
      default:
        return _getLevelGuidelines('beginner');
    }
  }

  static String _getGoalInstructions(String goal) {
    switch (goal.toLowerCase()) {
      case 'travel':
        return """GOAL (Travel): transportation, accommodation, dining, directions, shopping, emergencies, sightseeing.""";
      case 'career':
      case 'business':
        return """GOAL (Business): office, communication, work tasks, professional interactions, business concepts, workplace culture.""";
      case 'family':
      case 'personal':
        return """GOAL (Personal): family members, home life, daily routines, emotions, social activities, hobbies.""";
      case 'school':
      case 'academic':
        return """GOAL (Academic): classroom, subjects, study activities, school life, learning materials, academic concepts.""";
      case 'hobby':
      case 'culture':
        return """GOAL (Hobby/Culture): arts, entertainment, sports, leisure, cultural experiences, hobbies.""";
      default:
        return _getGoalInstructions('travel');
    }
  }

  static String _getLanguageSpecificInstructions(String language) {
    switch (language.toLowerCase()) {
      case 'hindi':
        return """HINDI: Devanagari script, simple phonetic pronunciation, natural spoken Hindi. Preserve ALL mātrās exactly — क ≠ का. word/correct_answer/option must be identical including diacritics.""";
      case 'spanish':
        return """SPANISH: Include el/la gender markers, Latin American Spanish. Preserve accents: á≠a é≠e í≠i ó≠o ú≠u ñ≠n. word/correct_answer/option must match exactly.""";
      case 'french':
        return """FRENCH: Include le/la/l' markers, standard France French. Preserve: é≠e è≠e ê≠e à≠a ù≠u ç≠c. word/correct_answer/option must match exactly.""";
      case 'gujarati':
        return """GUJARATI: Gujarati script, simple phonetic guide. Preserve ALL mātrās: ક≠કા. word/correct_answer/option must match exactly.""";
      case 'german':
        return """GERMAN: Include der/die/das articles. Preserve umlauts: ä≠a ö≠o ü≠u ß. word/correct_answer/option must match exactly.""";
      case 'arabic':
        return """ARABIC: Arabic script, Modern Standard Arabic, RTL text. Preserve diacritics if used. word/correct_answer/option must match exactly.""";
      case 'japanese':
        return """JAPANESE: Mix of Hiragana/Katakana/Kanji. word=dictionary form, correct_answer=form used in sentence. Preserve all scripts exactly.""";
      case 'chinese':
        return """CHINESE: Simplified characters, Pinyin with tone marks. Preserve tone marks: ā á ǎ à. word/correct_answer/option must match exactly.""";
      case 'korean':
        return """KOREAN: Hangul script. Preserve syllable blocks: 한≠하. correct_answer matches form in sentence including 받침.""";
      case 'portuguese':
        return """PORTUGUESE: Brazilian standard, include gender markers. Preserve: ã≠a õ≠o á é í ó ú â ê ô ç. word/correct_answer/option must match exactly.""";
      case 'italian':
        return """ITALIAN: Include gender markers, standard Italian. Preserve: à è é ì ò ù. word/correct_answer/option must match exactly.""";
      case 'english':
        return """ENGLISH: American spelling, match capitalization exactly as used in sentence. word/correct_answer/option must match exactly.""";
      default:
        return """LANGUAGE: Standard form, phonetic pronunciation, preserve ALL special characters/accents exactly. word/correct_answer/option must be identical.""";
    }
  }

  static String _outputJsonExamplePart(String language, String nativeLanguage) {
    final isTargetEnglish = language.toLowerCase() == "english";
    final isNativeEnglish =
        nativeLanguage.toLowerCase() == "en" ||
        nativeLanguage.toLowerCase() == "english";
    final nativeLangName =
        Textconstant.languageNames[nativeLanguage] ?? 'English';

    if (isTargetEnglish) {
      return """
    "examples": [
      {"sentence":"English sentence (A1/A2)","translation_native":"translation in $nativeLangName","sentence_parts":["..."],"level":"easy"},
      {"sentence":"English sentence (B1/B2)","translation_native":"translation in $nativeLangName","sentence_parts":["..."],"level":"medium"},
      {"sentence":"English sentence (C1/C2)","translation_native":"translation in $nativeLangName","sentence_parts":["..."],"level":"hard"}
    ]""";
    } else if (isNativeEnglish) {
      return """
    "examples": [
      {"sentence":"$language sentence (A1/A2)","translation_english":"English translation","translation_native":"English translation","sentence_parts":["..."],"level":"easy"},
      {"sentence":"$language sentence (B1/B2)","translation_english":"English translation","translation_native":"English translation","sentence_parts":["..."],"level":"medium"},
      {"sentence":"$language sentence (C1/C2)","translation_english":"English translation","translation_native":"English translation","sentence_parts":["..."],"level":"hard"}
    ]""";
    } else {
      return """
    "examples": [
      {"sentence":"$language sentence (A1/A2)","translation_english":"English translation","translation_native":"translation in $nativeLangName","sentence_parts":["..."],"level":"easy"},
      {"sentence":"$language sentence (B1/B2)","translation_english":"English translation","translation_native":"translation in $nativeLangName","sentence_parts":["..."],"level":"medium"},
      {"sentence":"$language sentence (C1/C2)","translation_english":"English translation","translation_native":"translation in $nativeLangName","sentence_parts":["..."],"level":"hard"}
    ]""";
    }
  }

  static String _getAgeInstructions(int? age, String learningGoal) {
    if (age == null) return "";
    if (age < 13) {
      return """
=== AGE-SPECIFIC INSTRUCTIONS ===
- TARGET USER IS A CHILD (under 13 years old).
- Vocabulary words, options, and example sentences MUST be simple, child-friendly, playful, and easy to read.
- Contexts MUST relate to things children enjoy/are familiar with (e.g. school, pets, toys, cartoon/animation, family, playground, simple games/hobbies) *within* the selected learning goal ($learningGoal).
- Do NOT generate abstract, complex, professional/business, financial, or sensitive themes.""";
    } else if (age < 20) {
      return """
=== AGE-SPECIFIC INSTRUCTIONS ===
- TARGET USER IS A TEENAGER (13-19 years old).
- Vocabulary, MCQ options, and example sentences MUST relate to teenage life and interests (e.g. school/high school life, peer relationships, technology, social media, sports, hobbies, gaming, music/pop culture) *within* the selected learning goal ($learningGoal).
- Tone should be relatable and engaging, not overly childish but avoiding formal/professional business jargon.""";
    } else {
      return """
=== AGE-SPECIFIC INSTRUCTIONS ===
- TARGET USER IS AN ADULT (20+ years old).
- Vocabulary and example sentences should relate to adult contexts (e.g. daily adult routines, career/workplace, news, travel, household management, social/professional events, and light financial topics) *within* the selected learning goal ($learningGoal).""";
    }
  }
}
