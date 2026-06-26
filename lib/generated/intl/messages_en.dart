// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(currentTranslation) =>
      "Arrange the words to form: ${currentTranslation}";

  static String m1(wordCount) =>
      "Your daily vocabulary will change to ${wordCount} words per session.";

  static String m2(currentSentence) => "Correct order: ${currentSentence}";

  static String m3(wordTranslation) =>
      "Fill in the blank for: \'${wordTranslation}\' → _____";

  static String m4(count, language) =>
      "Master ${count} new phrases in your ${language} essentials course.";

  static String m5(currentIndex, totalCount) =>
      "Question ${currentIndex} of ${totalCount}";

  static String m6(score, total) => "${score}/${total}";

  static String m7(percentage) => "${percentage}%";

  static String m8(currentIndex, totalCount) =>
      "Step ${currentIndex} of ${totalCount}";

  static String m9(count) => "${count} days";

  static String m10(count) =>
      "${Intl.plural(count, one: '1 day ago', other: '${count} days ago')}";

  static String m11(count) =>
      "${Intl.plural(count, one: '1 word', other: '${count} words')}";

  static String m12(currentIndex, totalCount) =>
      "Word ${currentIndex} / ${totalCount}";

  static String m13(points) => "${points} XP";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "account": MessageLookupByLibrary.simpleMessage("Account"),
    "advanced": MessageLookupByLibrary.simpleMessage("Advanced"),
    "aestheticFocus": MessageLookupByLibrary.simpleMessage("Aesthetic Focus"),
    "age": MessageLookupByLibrary.simpleMessage("Age"),
    "alreadyHaveAnAccount": MessageLookupByLibrary.simpleMessage(
      "Already have an account?",
    ),
    "appLanguage": MessageLookupByLibrary.simpleMessage("App Language"),
    "appName": MessageLookupByLibrary.simpleMessage("Multilingo"),
    "appNameSubtitle": MessageLookupByLibrary.simpleMessage(
      "Mastery through immersion",
    ),
    "arrangeWordsToForm": m0,
    "askAnything": MessageLookupByLibrary.simpleMessage("Ask Anything"),
    "beginner": MessageLookupByLibrary.simpleMessage("Beginner"),
    "boostYourResumeAndUnlockGlobalOpportunities":
        MessageLookupByLibrary.simpleMessage(
          "Boost your resume and unlock global opportunities.",
        ),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "career": MessageLookupByLibrary.simpleMessage("Career"),
    "casual": MessageLookupByLibrary.simpleMessage("Casual"),
    "changeDailyGoalDialogMessage": m1,
    "changeDailyGoalDialogTitle": MessageLookupByLibrary.simpleMessage(
      "Change Daily Goal?",
    ),
    "changeLanguageDialogCancel": MessageLookupByLibrary.simpleMessage(
      "Cancel",
    ),
    "changeLanguageDialogConfirm": MessageLookupByLibrary.simpleMessage(
      "Yes, Change",
    ),
    "changeLanguageDialogMessage": MessageLookupByLibrary.simpleMessage(
      "If you change the app language now, vocabulary translations will update for newly generated words only. Your current vocabulary will remain in the previous language.\n\nDo you want to continue?",
    ),
    "changeLanguageDialogTitle": MessageLookupByLibrary.simpleMessage(
      "Change Language?",
    ),
    "chat": MessageLookupByLibrary.simpleMessage("Chat"),
    "checkAnswer": MessageLookupByLibrary.simpleMessage("Check Answer"),
    "chooseALanguageToStartYourJourneyIntoQuietProductivityAndFocusedGrowth":
        MessageLookupByLibrary.simpleMessage(
          "Choose a language to start your journey into quiet productivity and focused growth.",
        ),
    "chooseAPaceThatFitsYourLifestyle": MessageLookupByLibrary.simpleMessage(
      "Choose a pace that fits your lifestyle.",
    ),
    "comfortableWithBasicsSeekingDeeperMastery":
        MessageLookupByLibrary.simpleMessage(
          "Comfortable with basics, seeking deeper mastery.",
        ),
    "completeLessonToSeeHistory": MessageLookupByLibrary.simpleMessage(
      "Complete a lesson to see your history here",
    ),
    "confirmPassword": MessageLookupByLibrary.simpleMessage("Confirm password"),
    "confirmPasswordIsRequired": MessageLookupByLibrary.simpleMessage(
      "Confirm password is required",
    ),
    "consistencyIsKeyToMasteringNewSkills":
        MessageLookupByLibrary.simpleMessage(
          "Consistency is key to mastering new skills.",
        ),
    "continueText": MessageLookupByLibrary.simpleMessage("Continue"),
    "copied": MessageLookupByLibrary.simpleMessage("Copied"),
    "correct": MessageLookupByLibrary.simpleMessage("Correct"),
    "correctAnswerText": MessageLookupByLibrary.simpleMessage("Correct Answer"),
    "correctOrder": m2,
    "curatedContent": MessageLookupByLibrary.simpleMessage("Curated Content"),
    "currentPoints": MessageLookupByLibrary.simpleMessage("Current points"),
    "currentStreak": MessageLookupByLibrary.simpleMessage("Current streak"),
    "dailyGoal": MessageLookupByLibrary.simpleMessage("Daily Goal :"),
    "deepFocus": MessageLookupByLibrary.simpleMessage("Deep Focus"),
    "delete": MessageLookupByLibrary.simpleMessage("Delete"),
    "dontHaveAnAccount": MessageLookupByLibrary.simpleMessage(
      "Don\'t have an account?",
    ),
    "dragTheCorrectWordToTheBlankSpace": MessageLookupByLibrary.simpleMessage(
      "Drag the correct word to the blank space:",
    ),
    "dragWordsHere": MessageLookupByLibrary.simpleMessage("Drag words here:"),
    "edit": MessageLookupByLibrary.simpleMessage("Edit"),
    "email": MessageLookupByLibrary.simpleMessage("Email"),
    "emailAddressAlreadyExistsTryToLogin": MessageLookupByLibrary.simpleMessage(
      "Email address already exists, try to login",
    ),
    "emailIsRequired": MessageLookupByLibrary.simpleMessage(
      "Email is required",
    ),
    "enterEmail": MessageLookupByLibrary.simpleMessage("Enter email"),
    "enterPassword": MessageLookupByLibrary.simpleMessage("Enter password"),
    "enterValidEmail": MessageLookupByLibrary.simpleMessage(
      "Enter valid email",
    ),
    "enterYourConfirmPassword": MessageLookupByLibrary.simpleMessage(
      "Enter your confirm password",
    ),
    "enterYourEmail": MessageLookupByLibrary.simpleMessage("Enter your email"),
    "enterYourPassword": MessageLookupByLibrary.simpleMessage(
      "Enter your password",
    ),
    "example": MessageLookupByLibrary.simpleMessage("Example"),
    "excelInYourStudiesAndMasterExams": MessageLookupByLibrary.simpleMessage(
      "Excel in your studies and master exams.",
    ),
    "exit": MessageLookupByLibrary.simpleMessage("Exit"),
    "exitLesson": MessageLookupByLibrary.simpleMessage("Exit Lesson?"),
    "expertKnowledgeLookingForAdvancedNuances":
        MessageLookupByLibrary.simpleMessage(
          "Expert knowledge, looking for advanced nuances.",
        ),
    "fastTrack": MessageLookupByLibrary.simpleMessage("Fast track"),
    "female": MessageLookupByLibrary.simpleMessage("Female"),
    "fifteenMinPerDay": MessageLookupByLibrary.simpleMessage(
      "15 min/day | Make real progress",
    ),
    "fifteenMinsPerDay": MessageLookupByLibrary.simpleMessage(
      "15 mins per day",
    ),
    "fillInTheBlank": m3,
    "finish": MessageLookupByLibrary.simpleMessage("Finish"),
    "fiveMinPerDay": MessageLookupByLibrary.simpleMessage(
      "5 min/day | Perfect for beginners",
    ),
    "fiveMinsPerDay": MessageLookupByLibrary.simpleMessage("5 mins per day"),
    "gender": MessageLookupByLibrary.simpleMessage("Gender"),
    "generatingYourVocabulary": MessageLookupByLibrary.simpleMessage(
      "Generating your vocabulary...",
    ),
    "generationFailedPleaseRetry": MessageLookupByLibrary.simpleMessage(
      "Generation failed, please retry",
    ),
    "getStarted": MessageLookupByLibrary.simpleMessage("Get Started"),
    "greatJob": MessageLookupByLibrary.simpleMessage("Great Job!"),
    "heading1": MessageLookupByLibrary.simpleMessage(
      "Learn a new language daily",
    ),
    "heading2": MessageLookupByLibrary.simpleMessage("Speak with confidence"),
    "heading3": MessageLookupByLibrary.simpleMessage("Learn at your own pace"),
    "helloThere": MessageLookupByLibrary.simpleMessage("Hello there"),
    "history": MessageLookupByLibrary.simpleMessage("History"),
    "home": MessageLookupByLibrary.simpleMessage("Home"),
    "howCanIHelpYouToday": MessageLookupByLibrary.simpleMessage(
      "How can I help you today?",
    ),
    "howMuchTimeCanYouDedicate": MessageLookupByLibrary.simpleMessage(
      "How much time can you dedicate?",
    ),
    "iAlreadyHaveAnAccount": MessageLookupByLibrary.simpleMessage(
      "I already have an account",
    ),
    "incorrect": MessageLookupByLibrary.simpleMessage("Incorrect"),
    "intense": MessageLookupByLibrary.simpleMessage("Intense"),
    "intermediate": MessageLookupByLibrary.simpleMessage("Intermediate"),
    "invalidCredential": MessageLookupByLibrary.simpleMessage(
      "Invalid credential",
    ),
    "joinTheJourney": MessageLookupByLibrary.simpleMessage("Join the Journey"),
    "language": MessageLookupByLibrary.simpleMessage("Language"),
    "languageNotSelected": MessageLookupByLibrary.simpleMessage(
      "Language not selected",
    ),
    "lastLesson": MessageLookupByLibrary.simpleMessage("Last lesson"),
    "learnAnytime": MessageLookupByLibrary.simpleMessage(
      "Learn anytime, anywhere",
    ),
    "learningLanguage": MessageLookupByLibrary.simpleMessage(
      "Learning Language :",
    ),
    "lesson": MessageLookupByLibrary.simpleMessage("Lesson"),
    "lessonComplete": MessageLookupByLibrary.simpleMessage("Lesson Complete!"),
    "lessonReview": MessageLookupByLibrary.simpleMessage("Lesson Review"),
    "lessonsBuiltByLinguistsForRealWorldApplication":
        MessageLookupByLibrary.simpleMessage(
          "Lessons built by linguists for real-world application.",
        ),
    "login": MessageLookupByLibrary.simpleMessage("Login"),
    "loginFailed": MessageLookupByLibrary.simpleMessage("Login failed"),
    "logout": MessageLookupByLibrary.simpleMessage("Log out"),
    "logoutConfirmationTitle": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to log out?",
    ),
    "male": MessageLookupByLibrary.simpleMessage("Male"),
    "masterAnyLang": MessageLookupByLibrary.simpleMessage(
      "Master any language",
    ),
    "masterNewPhrases": m4,
    "masterNewSkills": MessageLookupByLibrary.simpleMessage(
      "Master new skills with an immersive, game-like experience.",
    ),
    "masteredWords": MessageLookupByLibrary.simpleMessage("✅ Mastered Words"),
    "meaning": MessageLookupByLibrary.simpleMessage("Meaning"),
    "minimalistUiDesignedForZeroDistractionStudy":
        MessageLookupByLibrary.simpleMessage(
          "Minimalist UI designed for zero-distraction study.",
        ),
    "minimumEightCharactersRequired": MessageLookupByLibrary.simpleMessage(
      "Minimum 8 characters required",
    ),
    "mustContainAtLeastOneLowercaseLetter":
        MessageLookupByLibrary.simpleMessage(
          "Must contain at least 1 lowercase letter",
        ),
    "mustContainAtLeastOneNumber": MessageLookupByLibrary.simpleMessage(
      "Must contain at least 1 number",
    ),
    "mustContainAtLeastOneUppercaseLetter":
        MessageLookupByLibrary.simpleMessage(
          "Must contain at least 1 uppercase letter",
        ),
    "mustContainOneSpecialCharacter": MessageLookupByLibrary.simpleMessage(
      "Must contain 1 special character",
    ),
    "navigateNewCitiesAndConnectWithLocals":
        MessageLookupByLibrary.simpleMessage(
          "Navigate new cities and connect with locals.",
        ),
    "needReview": MessageLookupByLibrary.simpleMessage("📚 Need Review"),
    "newChat": MessageLookupByLibrary.simpleMessage("New Chat"),
    "newToThisTopicStartingFromScratch": MessageLookupByLibrary.simpleMessage(
      "New to this topic, starting from scratch.",
    ),
    "next": MessageLookupByLibrary.simpleMessage("Next"),
    "nextQuestion": MessageLookupByLibrary.simpleMessage("Next Question"),
    "nextWord": MessageLookupByLibrary.simpleMessage("Next Word"),
    "noChatHistory": MessageLookupByLibrary.simpleMessage("No chat history"),
    "noLessonsAttempted": MessageLookupByLibrary.simpleMessage(
      "No lessons attempted yet",
    ),
    "notFound": MessageLookupByLibrary.simpleMessage("Not found"),
    "onboardSubtitle1": MessageLookupByLibrary.simpleMessage(
      "Join millions of learners and master new skills through bite-sized, gamified lessons that feel like a game.",
    ),
    "onboardSubtitle2": MessageLookupByLibrary.simpleMessage(
      "Whether you have 5 minutes or 50, our lessons fit perfectly into your busy schedule.",
    ),
    "onboardSubtitle3": MessageLookupByLibrary.simpleMessage(
      "Stay motivated with daily streaks, earn rewards, and track your progress as you reach new levels of mastery.",
    ),
    "oneHundredPercent": MessageLookupByLibrary.simpleMessage("100%"),
    "oopsWrongAnswerTryAgain": MessageLookupByLibrary.simpleMessage(
      "Oops! Wrong answer, try again.",
    ),
    "other": MessageLookupByLibrary.simpleMessage("Other"),
    "password": MessageLookupByLibrary.simpleMessage("Password"),
    "passwordDoesntMatch": MessageLookupByLibrary.simpleMessage(
      "password doesnt match!",
    ),
    "passwordIsRequired": MessageLookupByLibrary.simpleMessage(
      "Password is required",
    ),
    "passwordTooShort": MessageLookupByLibrary.simpleMessage(
      "Password too short",
    ),
    "perfExcellent": MessageLookupByLibrary.simpleMessage("🎉 Excellent!"),
    "perfGoodWork": MessageLookupByLibrary.simpleMessage("👍 Good work!"),
    "perfGreatJob": MessageLookupByLibrary.simpleMessage("👏 Great job!"),
    "perfKeepPracticing": MessageLookupByLibrary.simpleMessage(
      "💪 Keep practicing!",
    ),
    "perfReviewAndTryAgain": MessageLookupByLibrary.simpleMessage(
      "📚 Review and try again!",
    ),
    "personalInformation": MessageLookupByLibrary.simpleMessage(
      "Personal Information",
    ),
    "pickTheCorrectTranslation": MessageLookupByLibrary.simpleMessage(
      "Pick the correct translation",
    ),
    "pleaseSelectYourGender": MessageLookupByLibrary.simpleMessage(
      "Please select your gender",
    ),
    "preferences": MessageLookupByLibrary.simpleMessage("Preferences"),
    "previousWord": MessageLookupByLibrary.simpleMessage("Previous Word"),
    "profile": MessageLookupByLibrary.simpleMessage("Profile"),
    "question": MessageLookupByLibrary.simpleMessage("Question"),
    "questionProgress": m5,
    "readyForExercise": MessageLookupByLibrary.simpleMessage(
      "Ready for Exercise?",
    ),
    "readyForToday": MessageLookupByLibrary.simpleMessage("Ready for today?"),
    "register": MessageLookupByLibrary.simpleMessage("Register"),
    "registerSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Registered successfully",
    ),
    "registrationFailed": MessageLookupByLibrary.simpleMessage(
      "Registration failed",
    ),
    "regular": MessageLookupByLibrary.simpleMessage("Regular"),
    "retry": MessageLookupByLibrary.simpleMessage("Retry"),
    "reviewWords": MessageLookupByLibrary.simpleMessage("Review Words"),
    "school": MessageLookupByLibrary.simpleMessage("School"),
    "scoreFraction": m6,
    "scorePercentageValue": m7,
    "seeResults": MessageLookupByLibrary.simpleMessage("See Results"),
    "selectLanguage": MessageLookupByLibrary.simpleMessage("Select Language"),
    "selectYourGender": MessageLookupByLibrary.simpleMessage(
      "Select your gender",
    ),
    "serious": MessageLookupByLibrary.simpleMessage("Serious"),
    "setYourDailyGoal": MessageLookupByLibrary.simpleMessage(
      "Set your daily goal",
    ),
    "skip": MessageLookupByLibrary.simpleMessage("Skip"),
    "smartProgress": MessageLookupByLibrary.simpleMessage("Smart Progress"),
    "somethingWentWrong": MessageLookupByLibrary.simpleMessage(
      "Something went wrong",
    ),
    "startExercise": MessageLookupByLibrary.simpleMessage("Start Exercise"),
    "startLesson": MessageLookupByLibrary.simpleMessage("Start Lesson"),
    "stepProgressFraction": m8,
    "streak": MessageLookupByLibrary.simpleMessage("Streak"),
    "streakDays": m9,
    "syncingProgress": MessageLookupByLibrary.simpleMessage(
      "Syncing progress...",
    ),
    "tapToRevealMeaning": MessageLookupByLibrary.simpleMessage(
      "Tap to reveal meaning",
    ),
    "tenMinPerDay": MessageLookupByLibrary.simpleMessage(
      "10 min/day | Stay consistent",
    ),
    "tenMinsPerDay": MessageLookupByLibrary.simpleMessage("10 mins per day"),
    "thisHelpsUsTailorTheLessonsToYourCurrentKnowledgeAndLearningPace":
        MessageLookupByLibrary.simpleMessage(
          "This helps us tailor the lessons to your current knowledge and learning pace.",
        ),
    "timeDaysAgo": m10,
    "timeTaken": MessageLookupByLibrary.simpleMessage("Time Taken"),
    "timeToday": MessageLookupByLibrary.simpleMessage("Today"),
    "timeYesterday": MessageLookupByLibrary.simpleMessage("Yesterday"),
    "tooManyAttemptsTryAgainLater": MessageLookupByLibrary.simpleMessage(
      "Too many attempts, try again later",
    ),
    "translation": MessageLookupByLibrary.simpleMessage("Translation"),
    "travel": MessageLookupByLibrary.simpleMessage("Travel"),
    "twentyMinPerDay": MessageLookupByLibrary.simpleMessage(
      "20 min/day | Fast track to fluency",
    ),
    "twentyMinsPerDay": MessageLookupByLibrary.simpleMessage("20 mins per day"),
    "unlockYourPotential": MessageLookupByLibrary.simpleMessage(
      "Unlock your potential",
    ),
    "visiblePassword": MessageLookupByLibrary.simpleMessage("Visible password"),
    "visualizeYourJourneyWithTonalProgressTracking":
        MessageLookupByLibrary.simpleMessage(
          "Visualize your journey with tonal progress tracking.",
        ),
    "vocab": MessageLookupByLibrary.simpleMessage("Vocab"),
    "welcomeBack": MessageLookupByLibrary.simpleMessage("Welcome back"),
    "wellTailorYourExperienceToHelpYouReachYourGoalsFaster":
        MessageLookupByLibrary.simpleMessage(
          "We\'ll tailor your experience to help you reach your goals faster.",
        ),
    "whatDoYouWantToLearn": MessageLookupByLibrary.simpleMessage(
      "What do you want to learn?",
    ),
    "whyAreYouLearning": MessageLookupByLibrary.simpleMessage(
      "Why are you learning?",
    ),
    "wordCountValue": m11,
    "wordProgressFraction": m12,
    "wordsExercise": MessageLookupByLibrary.simpleMessage("words / exercise"),
    "xpEarned": MessageLookupByLibrary.simpleMessage("XP Earned"),
    "xpPointsValue": m13,
    "yearsOld": MessageLookupByLibrary.simpleMessage("years old"),
    "yourAnswer": MessageLookupByLibrary.simpleMessage("Your Answer"),
    "yourExperienceLevel": MessageLookupByLibrary.simpleMessage(
      "Your experience level?",
    ),
    "yourJourneyToFluencyContinuesHere": MessageLookupByLibrary.simpleMessage(
      "Your journey to fluency continues here.",
    ),
    "yourProgressWillBeLostIfYouExitNow": MessageLookupByLibrary.simpleMessage(
      "Your progress will be lost if you exit now.",
    ),
    "youreMakingExcellentProgress": MessageLookupByLibrary.simpleMessage(
      "You\'re making excellent progress.",
    ),
    "youveCompletedYourVocabularySession": MessageLookupByLibrary.simpleMessage(
      "You\'ve completed your vocabulary session",
    ),
  };
}
