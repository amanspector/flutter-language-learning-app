// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a hi locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'hi';

  static String m0(currentTranslation) =>
      "वाक्य बनाने के लिए शब्दों को व्यवस्थित करें: ${currentTranslation}";

  static String m1(wordCount) =>
      "आपकी दैनिक शब्दावली बदलकर प्रति सत्र ${wordCount} शब्द हो जाएगी.";

  static String m2(currentSentence) => "सही क्रम: ${currentSentence}";

  static String m3(wordTranslation) =>
      "रिक्त स्थान भरें: \'${wordTranslation}\' → _____";

  static String m4(count, language) =>
      "अपने ${language} बुनियादी कोर्स में ${count} नए वाक्यांशों में महारत हासिल करें।";

  static String m5(currentIndex, totalCount) =>
      "प्रश्न ${currentIndex} / ${totalCount}";

  static String m6(score, total) => "${score}/${total}";

  static String m7(percentage) => "${percentage}%";

  static String m8(currentIndex, totalCount) =>
      "${totalCount} में से चरण ${currentIndex}";

  static String m9(count) => "${count} दिन";

  static String m10(count) =>
      "${Intl.plural(count, one: '1 दिन पहले', other: '${count} दिन पहले')}";

  static String m11(count) =>
      "${Intl.plural(count, one: '1 शब्द', other: '${count} शब्द')}";

  static String m12(currentIndex, totalCount) =>
      "शब्द ${currentIndex} / ${totalCount}";

  static String m13(points) => "${points} XP";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "account": MessageLookupByLibrary.simpleMessage("खाता"),
    "advanced": MessageLookupByLibrary.simpleMessage("उन्नत"),
    "aestheticFocus": MessageLookupByLibrary.simpleMessage("एस्थेटिक फोकस"),
    "age": MessageLookupByLibrary.simpleMessage("उम्र"),
    "alreadyHaveAnAccount": MessageLookupByLibrary.simpleMessage(
      "क्या आपके पास पहले से एक खाता है?",
    ),
    "appLanguage": MessageLookupByLibrary.simpleMessage("ऐप की भाषा"),
    "appName": MessageLookupByLibrary.simpleMessage("Multilingo"),
    "appNameSubtitle": MessageLookupByLibrary.simpleMessage(
      "इमर्सिव लर्निंग से महारत",
    ),
    "arrangeWordsToForm": m0,
    "askAnything": MessageLookupByLibrary.simpleMessage("कुछ भी पूछें"),
    "beginner": MessageLookupByLibrary.simpleMessage("शुरुआती"),
    "boostYourResumeAndUnlockGlobalOpportunities":
        MessageLookupByLibrary.simpleMessage(
          "अपने रेज़्यूमे को बढ़ावा दें और वैश्विक अवसरों को अनलॉक करें।",
        ),
    "cancel": MessageLookupByLibrary.simpleMessage("रद्द करें"),
    "career": MessageLookupByLibrary.simpleMessage("करियर"),
    "casual": MessageLookupByLibrary.simpleMessage("कैज़ुअल"),
    "changeDailyGoalDialogMessage": m1,
    "changeDailyGoalDialogTitle": MessageLookupByLibrary.simpleMessage(
      "दैनिक लक्ष्य बदलें?",
    ),
    "changeLanguageDialogCancel": MessageLookupByLibrary.simpleMessage(
      "रद्द करें",
    ),
    "changeLanguageDialogConfirm": MessageLookupByLibrary.simpleMessage(
      "हाँ, बदलें",
    ),
    "changeLanguageDialogMessage": MessageLookupByLibrary.simpleMessage(
      "यदि आप अभी ऐप की भाषा बदलते हैं, तो शब्दावली अनुवाद केवल नए जनरेट किए गए शब्दों के लिए अपडेट होंगे। आपकी वर्तमान शब्दावली पिछली भाषा में ही रहेगी।\n\nक्या आप जारी रखना चाहते हैं?",
    ),
    "changeLanguageDialogTitle": MessageLookupByLibrary.simpleMessage(
      "भाषा बदलें?",
    ),
    "chat": MessageLookupByLibrary.simpleMessage("चैट"),
    "checkAnswer": MessageLookupByLibrary.simpleMessage("उत्तर जांचें"),
    "chooseALanguageToStartYourJourneyIntoQuietProductivityAndFocusedGrowth":
        MessageLookupByLibrary.simpleMessage(
          "शांत उत्पादकता और केंद्रित विकास की अपनी यात्रा शुरू करने के लिए एक भाषा चुनें।",
        ),
    "chooseAPaceThatFitsYourLifestyle": MessageLookupByLibrary.simpleMessage(
      "ऐसी गति चुनें जो आपकी जीवनशैली के अनुकूल हो।",
    ),
    "comfortableWithBasicsSeekingDeeperMastery":
        MessageLookupByLibrary.simpleMessage(
          "बुनियादी बातों के साथ सहज, गहरी महारत की तलाश में।",
        ),
    "completeLessonToSeeHistory": MessageLookupByLibrary.simpleMessage(
      "अपना इतिहास यहाँ देखने के लिए एक पाठ पूरा करें",
    ),
    "confirmPassword": MessageLookupByLibrary.simpleMessage(
      "पासवर्ड की पुष्टि करें",
    ),
    "confirmPasswordIsRequired": MessageLookupByLibrary.simpleMessage(
      "पासवर्ड की पुष्टि करना आवश्यक है",
    ),
    "consistencyIsKeyToMasteringNewSkills":
        MessageLookupByLibrary.simpleMessage(
          "नए कौशल सीखने के लिए निरंतरता ही कुंजी है।",
        ),
    "continueText": MessageLookupByLibrary.simpleMessage("जारी रखें"),
    "copied": MessageLookupByLibrary.simpleMessage("कॉपी किया गया"),
    "correct": MessageLookupByLibrary.simpleMessage("सही"),
    "correctAnswerText": MessageLookupByLibrary.simpleMessage("सही जवाब"),
    "correctOrder": m2,
    "curatedContent": MessageLookupByLibrary.simpleMessage("क्यूरेटेड कंटेंट"),
    "currentPoints": MessageLookupByLibrary.simpleMessage("वर्तमान अंक"),
    "currentStreak": MessageLookupByLibrary.simpleMessage("वर्तमान स्ट्रीक"),
    "dailyGoal": MessageLookupByLibrary.simpleMessage("दैनिक लक्ष्य :"),
    "deepFocus": MessageLookupByLibrary.simpleMessage("गहरा फोकस"),
    "delete": MessageLookupByLibrary.simpleMessage("हटाएं"),
    "dontHaveAnAccount": MessageLookupByLibrary.simpleMessage("खाता नहीं है?"),
    "dragTheCorrectWordToTheBlankSpace": MessageLookupByLibrary.simpleMessage(
      "सही शब्द को खाली स्थान पर खींचें:",
    ),
    "dragWordsHere": MessageLookupByLibrary.simpleMessage(
      "शब्दों को यहाँ खींचें:",
    ),
    "edit": MessageLookupByLibrary.simpleMessage("संपादित करें"),
    "email": MessageLookupByLibrary.simpleMessage("ईमेल"),
    "emailAddressAlreadyExistsTryToLogin": MessageLookupByLibrary.simpleMessage(
      "ईमेल पता पहले से मौजूद है, लॉग इन करने का प्रयास करें",
    ),
    "emailIsRequired": MessageLookupByLibrary.simpleMessage("ईमेल आवश्यक है"),
    "enterEmail": MessageLookupByLibrary.simpleMessage("ईमेल दर्ज करें"),
    "enterPassword": MessageLookupByLibrary.simpleMessage("पासवर्ड दर्ज करें"),
    "enterValidEmail": MessageLookupByLibrary.simpleMessage(
      "वैध ईमेल दर्ज करें",
    ),
    "enterYourConfirmPassword": MessageLookupByLibrary.simpleMessage(
      "अपने कन्फर्म पासवर्ड को दर्ज करें",
    ),
    "enterYourEmail": MessageLookupByLibrary.simpleMessage(
      "अपना ईमेल दर्ज करें",
    ),
    "enterYourPassword": MessageLookupByLibrary.simpleMessage(
      "अपना पासवर्ड दर्ज करें",
    ),
    "excelInYourStudiesAndMasterExams": MessageLookupByLibrary.simpleMessage(
      "अपनी पढ़ाई में उत्कृष्ट प्रदर्शन करें और परीक्षाओं में महारत हासिल करें।",
    ),
    "exit": MessageLookupByLibrary.simpleMessage("बाहर निकलें"),
    "exitLesson": MessageLookupByLibrary.simpleMessage("पाठ से बाहर निकलें?"),
    "expertKnowledgeLookingForAdvancedNuances":
        MessageLookupByLibrary.simpleMessage(
          "विशेषज्ञ ज्ञान, उन्नत बारीकियों की तलाश में।",
        ),
    "fastTrack": MessageLookupByLibrary.simpleMessage("फास्ट ट्रैक"),
    "female": MessageLookupByLibrary.simpleMessage("महिला"),
    "fifteenMinPerDay": MessageLookupByLibrary.simpleMessage(
      "15 मिनट/दिन | वास्तविक प्रगति करें",
    ),
    "fifteenMinsPerDay": MessageLookupByLibrary.simpleMessage(
      "15 मिनट प्रति दिन",
    ),
    "fillInTheBlank": m3,
    "finish": MessageLookupByLibrary.simpleMessage("पूरा करें"),
    "fiveMinPerDay": MessageLookupByLibrary.simpleMessage(
      "5 मिनट/दिन | शुरुआती लोगों के लिए बिल्कुल सही",
    ),
    "fiveMinsPerDay": MessageLookupByLibrary.simpleMessage("5 मिनट प्रति दिन"),
    "gender": MessageLookupByLibrary.simpleMessage("लिंग"),
    "generatingYourVocabulary": MessageLookupByLibrary.simpleMessage(
      "आपकी शब्दावली तैयार की जा रही है...",
    ),
    "generationFailedPleaseRetry": MessageLookupByLibrary.simpleMessage(
      "जेनरेशन विफल रहा, कृपया पुनः प्रयास करें",
    ),
    "getStarted": MessageLookupByLibrary.simpleMessage("शुरू करें"),
    "greatJob": MessageLookupByLibrary.simpleMessage("बहुत बढ़िया!"),
    "heading1": MessageLookupByLibrary.simpleMessage("रोजाना एक नई भाषा सीखें"),
    "heading2": MessageLookupByLibrary.simpleMessage(
      "आत्मविश्वास के साथ बोलें",
    ),
    "heading3": MessageLookupByLibrary.simpleMessage("अपनी गति से सीखें"),
    "helloThere": MessageLookupByLibrary.simpleMessage("नमस्ते,"),
    "history": MessageLookupByLibrary.simpleMessage("इतिहास"),
    "home": MessageLookupByLibrary.simpleMessage("होम"),
    "howCanIHelpYouToday": MessageLookupByLibrary.simpleMessage(
      "आज मैं आपकी क्या सहायता कर सकता हूँ?",
    ),
    "howMuchTimeCanYouDedicate": MessageLookupByLibrary.simpleMessage(
      "आप कितना समय समर्पित कर सकते हैं?",
    ),
    "iAlreadyHaveAnAccount": MessageLookupByLibrary.simpleMessage(
      "मेरे पास पहले से एक खाता है",
    ),
    "incorrect": MessageLookupByLibrary.simpleMessage("गलत"),
    "intense": MessageLookupByLibrary.simpleMessage("तीव्र"),
    "intermediate": MessageLookupByLibrary.simpleMessage("मध्यम"),
    "invalidCredential": MessageLookupByLibrary.simpleMessage(
      "अमान्य क्रेडेंशियल",
    ),
    "joinTheJourney": MessageLookupByLibrary.simpleMessage(
      "यात्रा में शामिल हों",
    ),
    "language": MessageLookupByLibrary.simpleMessage("भाषा"),
    "languageNotSelected": MessageLookupByLibrary.simpleMessage(
      "भाषा चुनी नहीं गई",
    ),
    "lastLesson": MessageLookupByLibrary.simpleMessage("आखरी पाठ"),
    "learnAnytime": MessageLookupByLibrary.simpleMessage(
      "कभी भी, कहीं भी सीखें",
    ),
    "learningLanguage": MessageLookupByLibrary.simpleMessage(
      "सीखी जा रही भाषा :",
    ),
    "lesson": MessageLookupByLibrary.simpleMessage("पाठ"),
    "lessonComplete": MessageLookupByLibrary.simpleMessage("पाठ पूरा हुआ!"),
    "lessonReview": MessageLookupByLibrary.simpleMessage("पाठ की समीक्षा"),
    "lessonsBuiltByLinguistsForRealWorldApplication":
        MessageLookupByLibrary.simpleMessage(
          "वास्तविक दुनिया में उपयोग के लिए भाषाविदों द्वारा बनाए गए पाठ।",
        ),
    "login": MessageLookupByLibrary.simpleMessage("लॉग इन"),
    "loginFailed": MessageLookupByLibrary.simpleMessage("लॉगिन असफल रहा"),
    "logout": MessageLookupByLibrary.simpleMessage("लॉग आउट"),
    "logoutConfirmationTitle": MessageLookupByLibrary.simpleMessage(
      "क्या आप वाकई लॉग आउट करना चाहते हैं?",
    ),
    "male": MessageLookupByLibrary.simpleMessage("पुरुष"),
    "masterAnyLang": MessageLookupByLibrary.simpleMessage(
      "किसी भी भाषा पर महारत हासिल करें",
    ),
    "masterNewPhrases": m4,
    "masterNewSkills": MessageLookupByLibrary.simpleMessage(
      "एक इमर्सिव, गेम जैसे अनुभव के साथ नए कौशल में महारत हासिल करें।",
    ),
    "masteredWords": MessageLookupByLibrary.simpleMessage("✅ सीखे गए शब्द"),
    "meaning": MessageLookupByLibrary.simpleMessage("अर्थ"),
    "minimalistUiDesignedForZeroDistractionStudy":
        MessageLookupByLibrary.simpleMessage(
          "बिना किसी भटकाव के अध्ययन के लिए डिज़ाइन किया गया मिनिमलिस्ट UI।",
        ),
    "minimumEightCharactersRequired": MessageLookupByLibrary.simpleMessage(
      "न्यूनतम 8 अक्षर आवश्यक हैं",
    ),
    "mustContainAtLeastOneLowercaseLetter":
        MessageLookupByLibrary.simpleMessage(
          "कम से कम 1 छोटा अक्षर (Lowercase) होना चाहिए",
        ),
    "mustContainAtLeastOneNumber": MessageLookupByLibrary.simpleMessage(
      "कम से कम 1 अंक होना चाहिए",
    ),
    "mustContainAtLeastOneUppercaseLetter":
        MessageLookupByLibrary.simpleMessage(
          "कम से कम 1 बड़ा अक्षर (Uppercase) होना चाहिए",
        ),
    "mustContainOneSpecialCharacter": MessageLookupByLibrary.simpleMessage(
      "1 विशेष वर्ण (Special Character) होना चाहिए",
    ),
    "navigateNewCitiesAndConnectWithLocals":
        MessageLookupByLibrary.simpleMessage(
          "नए शहरों में घूमें और स्थानीय लोगों से जुड़ें।",
        ),
    "needReview": MessageLookupByLibrary.simpleMessage(
      "📚 समीक्षा की आवश्यकता है",
    ),
    "newChat": MessageLookupByLibrary.simpleMessage("नई चैट"),
    "newToThisTopicStartingFromScratch": MessageLookupByLibrary.simpleMessage(
      "इस विषय के लिए नए हैं, बिल्कुल शुरुआत से शुरू कर रहे हैं।",
    ),
    "next": MessageLookupByLibrary.simpleMessage("आगे"),
    "nextQuestion": MessageLookupByLibrary.simpleMessage("अगला प्रश्न"),
    "nextWord": MessageLookupByLibrary.simpleMessage("अगला शब्द"),
    "noChatHistory": MessageLookupByLibrary.simpleMessage(
      "कोई चैट इतिहास नहीं",
    ),
    "noLessonsAttempted": MessageLookupByLibrary.simpleMessage(
      "अभी तक कोई पाठ का प्रयास नहीं किया गया है",
    ),
    "notFound": MessageLookupByLibrary.simpleMessage("नहीं मिला"),
    "onboardSubtitle1": MessageLookupByLibrary.simpleMessage(
      "लाखों शिक्षार्थियों से जुड़ें और छोटे, गेमिफाइड पाठों के माध्यम से नए कौशल सीखें जो एक खेल जैसे लगते हैं।",
    ),
    "onboardSubtitle2": MessageLookupByLibrary.simpleMessage(
      "चाहे आपके पास ५ मिनट हों या ५०, हमारे पाठ आपके व्यस्त शेड्यूल में पूरी तरह फिट बैठते हैं।",
    ),
    "onboardSubtitle3": MessageLookupByLibrary.simpleMessage(
      "दैनिक स्ट्रीक के साथ प्रेरित रहें, पुरस्कार जीतें, और महारत के नए स्तरों तक पहुँचते ही अपनी प्रगति को ट्रैक करें।",
    ),
    "oneHundredPercent": MessageLookupByLibrary.simpleMessage("100%"),
    "oopsWrongAnswerTryAgain": MessageLookupByLibrary.simpleMessage(
      "ओह! गलत उत्तर, फिर से प्रयास करें।",
    ),
    "other": MessageLookupByLibrary.simpleMessage("अन्य"),
    "password": MessageLookupByLibrary.simpleMessage("पासवर्ड"),
    "passwordDoesntMatch": MessageLookupByLibrary.simpleMessage(
      "पासवर्ड मेल नहीं खाता!",
    ),
    "passwordIsRequired": MessageLookupByLibrary.simpleMessage(
      "पासवर्ड आवश्यक है",
    ),
    "passwordTooShort": MessageLookupByLibrary.simpleMessage(
      "पासवर्ड बहुत छोटा है",
    ),
    "perfExcellent": MessageLookupByLibrary.simpleMessage("🎉 उत्कृष्ट!"),
    "perfGoodWork": MessageLookupByLibrary.simpleMessage("👍 अच्छा काम!"),
    "perfGreatJob": MessageLookupByLibrary.simpleMessage("👏 बहुत बढ़िया काम!"),
    "perfKeepPracticing": MessageLookupByLibrary.simpleMessage(
      "💪 अभ्यास करते रहें!",
    ),
    "perfReviewAndTryAgain": MessageLookupByLibrary.simpleMessage(
      "📚 समीक्षा करें और पुनः प्रयास करें!",
    ),
    "personalInformation": MessageLookupByLibrary.simpleMessage(
      "व्यक्तिगत जानकारी",
    ),
    "pickTheCorrectTranslation": MessageLookupByLibrary.simpleMessage(
      "सही अनुवाद चुनें",
    ),
    "pleaseSelectYourGender": MessageLookupByLibrary.simpleMessage(
      "कृपया अपना लिंग चुनें",
    ),
    "preferences": MessageLookupByLibrary.simpleMessage("प्राथमिकताएं"),
    "previousWord": MessageLookupByLibrary.simpleMessage("पिछला शब्द"),
    "profile": MessageLookupByLibrary.simpleMessage("प्रोफ़ाइल"),
    "question": MessageLookupByLibrary.simpleMessage("प्रश्न"),
    "questionProgress": m5,
    "readyForExercise": MessageLookupByLibrary.simpleMessage(
      "अभ्यास के लिए तैयार हैं?",
    ),
    "readyForToday": MessageLookupByLibrary.simpleMessage(
      "आज के लिए तैयार हैं?",
    ),
    "register": MessageLookupByLibrary.simpleMessage("रजिस्टर करें"),
    "registerSuccessfully": MessageLookupByLibrary.simpleMessage(
      "सफलतापूर्वक पंजीकृत हुआ",
    ),
    "registrationFailed": MessageLookupByLibrary.simpleMessage(
      "पंजीकरण असफल रहा",
    ),
    "regular": MessageLookupByLibrary.simpleMessage("नियमित"),
    "retry": MessageLookupByLibrary.simpleMessage("पुनः प्रयास करें"),
    "reviewWords": MessageLookupByLibrary.simpleMessage(
      "शब्दों की समीक्षा करें",
    ),
    "school": MessageLookupByLibrary.simpleMessage("स्कूल"),
    "scoreFraction": m6,
    "scorePercentageValue": m7,
    "seeResults": MessageLookupByLibrary.simpleMessage("परिणाम देखें"),
    "selectLanguage": MessageLookupByLibrary.simpleMessage("भाषा चुनें"),
    "selectYourGender": MessageLookupByLibrary.simpleMessage("अपना लिंग चुनें"),
    "serious": MessageLookupByLibrary.simpleMessage("गंभीर"),
    "setYourDailyGoal": MessageLookupByLibrary.simpleMessage(
      "अपना दैनिक लक्ष्य निर्धारित करें",
    ),
    "skip": MessageLookupByLibrary.simpleMessage("छोड़ें"),
    "smartProgress": MessageLookupByLibrary.simpleMessage("स्मार्ट प्रगति"),
    "somethingWentWrong": MessageLookupByLibrary.simpleMessage(
      "कुछ गलत हो गया",
    ),
    "startExercise": MessageLookupByLibrary.simpleMessage("अभ्यास शुरू करें"),
    "startLesson": MessageLookupByLibrary.simpleMessage("पाठ शुरू करें"),
    "stepProgressFraction": m8,
    "streak": MessageLookupByLibrary.simpleMessage("स्ट्रीक"),
    "streakDays": m9,
    "syncingProgress": MessageLookupByLibrary.simpleMessage(
      "प्रगति सिंक (Sync) हो रही है...",
    ),
    "tapToRevealMeaning": MessageLookupByLibrary.simpleMessage(
      "अर्थ देखने के लिए टैप करें",
    ),
    "tenMinPerDay": MessageLookupByLibrary.simpleMessage(
      "10 मिनट/दिन | निरंतरता बनाए रखें",
    ),
    "tenMinsPerDay": MessageLookupByLibrary.simpleMessage("10 मिनट प्रति दिन"),
    "thisHelpsUsTailorTheLessonsToYourCurrentKnowledgeAndLearningPace":
        MessageLookupByLibrary.simpleMessage(
          "इससे हमें आपकी वर्तमान जानकारी और सीखने की गति के अनुसार पाठों को तैयार करने में मदद मिलती।",
        ),
    "timeDaysAgo": m10,
    "timeTaken": MessageLookupByLibrary.simpleMessage("लिया गया समय"),
    "timeToday": MessageLookupByLibrary.simpleMessage("आज"),
    "timeYesterday": MessageLookupByLibrary.simpleMessage("कल"),
    "tooManyAttemptsTryAgainLater": MessageLookupByLibrary.simpleMessage(
      "बहुत सारे प्रयास किए गए, कृपया बाद में पुनः प्रयास करें",
    ),
    "translation": MessageLookupByLibrary.simpleMessage("अनुवाद"),
    "travel": MessageLookupByLibrary.simpleMessage("यात्रा"),
    "twentyMinPerDay": MessageLookupByLibrary.simpleMessage(
      "20 मिनट/दिन | तेज़ी से महारत हासिल करें",
    ),
    "twentyMinsPerDay": MessageLookupByLibrary.simpleMessage(
      "20 मिनट प्रति दिन",
    ),
    "unlockYourPotential": MessageLookupByLibrary.simpleMessage(
      "अपनी क्षमताओं को अनलॉक करें",
    ),
    "visiblePassword": MessageLookupByLibrary.simpleMessage("पासवर्ड दिखाएं"),
    "visualizeYourJourneyWithTonalProgressTracking":
        MessageLookupByLibrary.simpleMessage(
          "टोनल प्रोग्रेस ट्रैकिंग के साथ अपनी यात्रा की कल्पना करें।",
        ),
    "vocab": MessageLookupByLibrary.simpleMessage("शब्दावली"),
    "welcomeBack": MessageLookupByLibrary.simpleMessage("आपका स्वागत है"),
    "wellTailorYourExperienceToHelpYouReachYourGoalsFaster":
        MessageLookupByLibrary.simpleMessage(
          "हम आपके लक्ष्यों तक तेज़ी से पहुँचने में मदद करने के लिए आपके अनुभव को कस्टमाइज़ करेंगे।",
        ),
    "whatDoYouWantToLearn": MessageLookupByLibrary.simpleMessage(
      "आप क्या सीखना चाहते हैं?",
    ),
    "whyAreYouLearning": MessageLookupByLibrary.simpleMessage(
      "आप क्यों सीख रहे हैं?",
    ),
    "wordCountValue": m11,
    "wordProgressFraction": m12,
    "wordsExercise": MessageLookupByLibrary.simpleMessage("शब्द / अभ्यास"),
    "xpEarned": MessageLookupByLibrary.simpleMessage("अर्जित XP"),
    "xpPointsValue": m13,
    "yearsOld": MessageLookupByLibrary.simpleMessage("वर्ष"),
    "yourAnswer": MessageLookupByLibrary.simpleMessage("आपका जवाब"),
    "yourExperienceLevel": MessageLookupByLibrary.simpleMessage(
      "आपका अनुभव स्तर?",
    ),
    "yourJourneyToFluencyContinuesHere": MessageLookupByLibrary.simpleMessage(
      "आपकी प्रवहमानता (Fluency) की यात्रा यहाँ जारी है।",
    ),
    "yourProgressWillBeLostIfYouExitNow": MessageLookupByLibrary.simpleMessage(
      "यदि आप अभी बाहर निकलते हैं, तो आपकी प्रगति खो जाएगी।",
    ),
    "youreMakingExcellentProgress": MessageLookupByLibrary.simpleMessage(
      "आप बेहतरीन प्रगति कर रहे हैं।",
    ),
    "youveCompletedYourVocabularySession": MessageLookupByLibrary.simpleMessage(
      "आपने अपना शब्दावली सत्र पूरा कर लिया है",
    ),
  };
}
