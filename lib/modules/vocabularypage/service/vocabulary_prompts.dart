import 'package:chatbot_app/core/appconstants/text_constant.dart';

class VocabularyPrompts {
  static String buildVocabularyPrompt({
    required String language,
    required String nativeLanguage,
    required String experienceLevel,
    required String learningGoal,
    required int dailyGoalMinutes,
    required List<String> learnedWords,
  }) {
    // final wordCount = _calculateWordCount(dailyGoalMinutes, experienceLevel);
    final wordCount = dailyGoalMinutes;

    final nativeLang = Textconstant.languageNames[nativeLanguage];

    return """
You are a language curriculum expert. Generate exactly $wordCount vocabulary words.

TARGET LANGUAGE: $language
NATIVE LANGUAGE: $nativeLang
LEVEL: $experienceLevel
GOAL: $learningGoal

${_getLevelInstructions(experienceLevel)}
${_getGoalInstructions(learningGoal)}
${_getLanguageSpecificInstructions(language)}

=== MCQ RULES (apply to EVERY word) ===

SIBLING SETS: vehicles/colors/animals/fruits/clothes/furniture/emotions/family/food/body parts/professions/places/appliances/sports/office items

INVALID PATTERNS (never use):
- Generic: "यह मेरा ___ है" / "આ મારો ___ છે" / "वह एक ___ है" / "મેં ___ ખાધું"
- Any sentence where ANY sibling word fits the blank naturally
- Any sentence under 5 words total
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

BEGINNER (4-5 words): anchor must be a specific location noun or unique action verb
INTERMEDIATE (6-8 words): anchor via purpose clause or specific context  
ADVANCED (9-12 words): multiple context details that together eliminate all siblings

=== FIELD RULES ===
- All "sentence" fields: MUST be in $language script only
- "sentence_parts": sentence split by spaces
- "question": examples[0].sentence with target word → ___
- "options": [correct_answer, wrong1, wrong2, wrong3] (same part of speech)
- Top-level "sentence_parts" = examples[0].sentence_parts

OUTPUT:
${learnedWords.isNotEmpty ? "EXCLUDE these already learned words: ${learnedWords.join(', ')}\n" : ""}
Valid JSON only. No markdown.
{
  "metadata": {"language":"$language","native_language":"$nativeLang","level":"$experienceLevel","category":"$learningGoal","total_words":$wordCount},
  "words": [{
    "word": "target word in $language",
    "translation_english": "...",
    "translation_native": "...",
    "pronunciation": "phonetic guide",
    ${_outputJsonExamplePart(language)},
    "options": ["correct_answer","wrong1","wrong2","wrong3"],
    "correct_answer": "identical to word field"
  }]
}
Generate exactly $wordCount words now.
""";
  }

  // static int _calculateWordCount(int minutes, String level) {
  //   final baseCount = {5: 20, 10: 30, 15: 40, 20: 50};
  //   return baseCount[minutes] ?? 40;
  // }

  static String _getLevelInstructions(String level) {
    switch (level.toLowerCase()) {
      case 'beginner':
        return """LEVEL (A1-A2): Simple daily words, short sentences (3-7 words), no idioms, focus on nouns/verbs/adjectives.""";
      case 'intermediate':
        return """LEVEL (B1-B2): Conversational vocabulary, idioms allowed, longer sentences (6-12 words), mixed tenses.""";
      case 'advanced':
        return """LEVEL (C1-C2): Sophisticated vocabulary, idioms, cultural references, complex sentences, academic/professional terms.""";
      default:
        return _getLevelInstructions('beginner');
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

  static String _outputJsonExamplePart(String language) {
    return language.toLowerCase() == "english"
        ? """
    "examples": [
      {"sentence":"English sentence (A1/A2)","translation_native":"...","sentence_parts":["..."],"level":"easy"},
      {"sentence":"English sentence (B1/B2)","translation_native":"...","sentence_parts":["..."],"level":"medium"},
      {"sentence":"English sentence (C1/C2)","translation_native":"...","sentence_parts":["..."],"level":"hard"}
    ]"""
        : """
    "examples": [
      {"sentence":"$language sentence (A1/A2)","translation_english":"...","translation_native":"...","sentence_parts":["..."],"level":"easy"},
      {"sentence":"$language sentence (B1/B2)","translation_english":"...","translation_native":"...","sentence_parts":["..."],"level":"medium"},
      {"sentence":"$language sentence (C1/C2)","translation_english":"...","translation_native":"...","sentence_parts":["..."],"level":"hard"}
    ]""";
  }
}
