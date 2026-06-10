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
    final wordCount = _calculateWordCount(dailyGoalMinutes, experienceLevel);
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

INVALID SENTENCE PATTERNS (never use these structures):
❌ "यह मेरा ___ है" / "આ મારો ___ છે"  → any object fits
❌ "હું ___ માં બેઠો છું" → any vehicle fits  
❌ "मुझे ___ के पास जाना है"  → any profession fits
❌ "હું દરરોજ ___ જાઉં છું"  → any place fits
❌ "मुझे ___ पसंद है" / "मुझे ___ चाहिए" → any object fits
❌ "मैं ___ हूं" / "હું ___ છું"  → any emotion/adjective fits
❌ "वह एक ___ है" / "તે એક ___ છે"  → any noun fits
❌ "मैंने ___ खाया" / "મેં ___ ખાધું"  → any food fits
❌ "मैं ___ पहनता हूं" / "હું ___ પહેરું છું" → any clothing fits
❌ "मैं ___ देख रहा हूं"  → any object/animal fits
❌ ANY sentence where blank is the only noun
❌ ANY sentence under 4 words total
❌ question and correct_answer must not be identical
❌ correct_answer must exactly match word field including diacritics/mātrās

OPTIONS RULES:
❌ options must not contain synonyms of correct_answer
❌ all 4 options must be same part of speech
❌ no option should be a substring of another option
❌ options must not repeat

VALID ANCHOR PATTERNS (use one of these):
✅ Reason/purpose:  "कंप्यूटर पर रिपोर्ट टाइप करने के लिए ___" (purpose locks answer)
✅ Location noun:   "बस स्टैंड पर ___ का इंतजार" (location locks answer)
✅ Unique action:   "बीमार होने पर ___ के पास गया" (action locks answer)
✅ Specific task:   "शाकभाजी खरीदने ___ गया"  (task locks answer)
✅ Who/what combo:  "बॉस ने मुझे ___ में बुलाया" (who+where locks answer)

ANCHOR TEST: remove target word → insert each wrong option → if any fits naturally → REWRITE
BEGINNER (4-5 words): anchor must be a specific location noun or unique action verb
INTERMEDIATE (8-9 words): anchor via purpose clause or specific context  
ADVANCED (14-16 words): multiple context details that together eliminate all siblings

=== FIELD RULES ===
- All "sentence" fields: MUST be in $language script only
- "sentence_parts": sentence split by spaces
- "question": examples[0].sentence with target word → ___
- "options": [correct_answer, wrong1, wrong2, wrong3] (same part of speech)
- Top-level "sentence_parts" = examples[0].sentence_parts

${learnedWords.isNotEmpty ? "EXCLUDE: ${learnedWords.join(', ')}\n" : ""}
OUTPUT: Valid JSON only. No markdown.

{
  "metadata": {"language":"$language","native_language":"$nativeLang","level":"$experienceLevel","category":"$learningGoal","total_words":$wordCount},
  "words": [{
    "word": "target word in $language",
    "translation_english": "...",
    "translation_native": "...",
    "part_of_speech": "noun|verb|adjective|adverb|phrase",
    "pronunciation": "phonetic guide",
    "theme": "semantic category",
    "examples": [
      {"sentence":"$language only (A1/A2)","translation_english":"...","translation_native":"...","sentence_parts":["..."],"level":"easy"},
      {"sentence":"$language only (B1/B2)","translation_english":"...","translation_native":"...","sentence_parts":["..."],"level":"medium"},
      {"sentence":"$language only (C1/C2)","translation_english":"...","translation_native":"...","sentence_parts":["..."],"level":"hard"}
    ],
    "question": "examples[0].sentence with target word → ___",
    "options": ["correct_answer","wrong1","wrong2","wrong3"],
    "correct_answer": "identical to word field",
    "sentence_parts": ["copy of examples[0].sentence_parts"]
  }]
}
Generate exactly $wordCount words now.
""";
  }

  static int _calculateWordCount(int minutes, String level) {
    final baseCount = {5: 30, 10: 40, 15: 50, 20: 60};
    return baseCount[minutes] ?? 40;
  }

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
}
