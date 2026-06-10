// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Ask Anything`
  String get askAnything {
    return Intl.message(
      'Ask Anything',
      name: 'askAnything',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email`
  String get enterYourEmail {
    return Intl.message(
      'Enter your email',
      name: 'enterYourEmail',
      desc: '',
      args: [],
    );
  }

  /// `Too many attempts, try again later`
  String get tooManyAttemptsTryAgainLater {
    return Intl.message(
      'Too many attempts, try again later',
      name: 'tooManyAttemptsTryAgainLater',
      desc: '',
      args: [],
    );
  }

  /// `Enter your password`
  String get enterYourPassword {
    return Intl.message(
      'Enter your password',
      name: 'enterYourPassword',
      desc: '',
      args: [],
    );
  }

  /// `Invalid credential`
  String get invalidCredential {
    return Intl.message(
      'Invalid credential',
      name: 'invalidCredential',
      desc: '',
      args: [],
    );
  }

  /// `Enter your confirm password`
  String get enterYourConfirmPassword {
    return Intl.message(
      'Enter your confirm password',
      name: 'enterYourConfirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Email address already exists, try to login`
  String get emailAddressAlreadyExistsTryToLogin {
    return Intl.message(
      'Email address already exists, try to login',
      name: 'emailAddressAlreadyExistsTryToLogin',
      desc: '',
      args: [],
    );
  }

  /// `Hello there`
  String get helloThere {
    return Intl.message('Hello there', name: 'helloThere', desc: '', args: []);
  }

  /// `How can I help you today?`
  String get howCanIHelpYouToday {
    return Intl.message(
      'How can I help you today?',
      name: 'howCanIHelpYouToday',
      desc: '',
      args: [],
    );
  }

  /// `Get Started`
  String get getStarted {
    return Intl.message('Get Started', name: 'getStarted', desc: '', args: []);
  }

  /// `Welcome back`
  String get welcomeBack {
    return Intl.message(
      'Welcome back',
      name: 'welcomeBack',
      desc: '',
      args: [],
    );
  }

  /// `Email is required`
  String get emailIsRequired {
    return Intl.message(
      'Email is required',
      name: 'emailIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Password is required`
  String get passwordIsRequired {
    return Intl.message(
      'Password is required',
      name: 'passwordIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Enter valid email`
  String get enterValidEmail {
    return Intl.message(
      'Enter valid email',
      name: 'enterValidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Password too short`
  String get passwordTooShort {
    return Intl.message(
      'Password too short',
      name: 'passwordTooShort',
      desc: '',
      args: [],
    );
  }

  /// `Registered successfully`
  String get registerSuccessfully {
    return Intl.message(
      'Registered successfully',
      name: 'registerSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message('Register', name: 'register', desc: '', args: []);
  }

  /// `Copied`
  String get copied {
    return Intl.message('Copied', name: 'copied', desc: '', args: []);
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Incorrect`
  String get incorrect {
    return Intl.message('Incorrect', name: 'incorrect', desc: '', args: []);
  }

  /// `Correct`
  String get correct {
    return Intl.message('Correct', name: 'correct', desc: '', args: []);
  }

  /// `Log out`
  String get logout {
    return Intl.message('Log out', name: 'logout', desc: '', args: []);
  }

  /// `Edit`
  String get edit {
    return Intl.message('Edit', name: 'edit', desc: '', args: []);
  }

  /// `Exit`
  String get exit {
    return Intl.message('Exit', name: 'exit', desc: '', args: []);
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `New Chat`
  String get newChat {
    return Intl.message('New Chat', name: 'newChat', desc: '', args: []);
  }

  /// `Multilingo`
  String get appName {
    return Intl.message('Multilingo', name: 'appName', desc: '', args: []);
  }

  /// `Mastery through immersion`
  String get appNameSubtitle {
    return Intl.message(
      'Mastery through immersion',
      name: 'appNameSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Learn a new language daily`
  String get heading1 {
    return Intl.message(
      'Learn a new language daily',
      name: 'heading1',
      desc: '',
      args: [],
    );
  }

  /// `Speak with confidence`
  String get heading2 {
    return Intl.message(
      'Speak with confidence',
      name: 'heading2',
      desc: '',
      args: [],
    );
  }

  /// `Learn at your own pace`
  String get heading3 {
    return Intl.message(
      'Learn at your own pace',
      name: 'heading3',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account?`
  String get alreadyHaveAnAccount {
    return Intl.message(
      'Already have an account?',
      name: 'alreadyHaveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `I already have an account`
  String get iAlreadyHaveAnAccount {
    return Intl.message(
      'I already have an account',
      name: 'iAlreadyHaveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get dontHaveAnAccount {
    return Intl.message(
      'Don\'t have an account?',
      name: 'dontHaveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Not found`
  String get notFound {
    return Intl.message('Not found', name: 'notFound', desc: '', args: []);
  }

  /// `Fast track`
  String get fastTrack {
    return Intl.message('Fast track', name: 'fastTrack', desc: '', args: []);
  }

  /// `Deep Focus`
  String get deepFocus {
    return Intl.message('Deep Focus', name: 'deepFocus', desc: '', args: []);
  }

  /// `Travel`
  String get travel {
    return Intl.message('Travel', name: 'travel', desc: '', args: []);
  }

  /// `Curated Content`
  String get curatedContent {
    return Intl.message(
      'Curated Content',
      name: 'curatedContent',
      desc: '',
      args: [],
    );
  }

  /// `Your progress will be lost if you exit now.`
  String get yourProgressWillBeLostIfYouExitNow {
    return Intl.message(
      'Your progress will be lost if you exit now.',
      name: 'yourProgressWillBeLostIfYouExitNow',
      desc: '',
      args: [],
    );
  }

  /// `Lessons built by linguists for real-world application.`
  String get lessonsBuiltByLinguistsForRealWorldApplication {
    return Intl.message(
      'Lessons built by linguists for real-world application.',
      name: 'lessonsBuiltByLinguistsForRealWorldApplication',
      desc: '',
      args: [],
    );
  }

  /// `Smart Progress`
  String get smartProgress {
    return Intl.message(
      'Smart Progress',
      name: 'smartProgress',
      desc: '',
      args: [],
    );
  }

  /// `Visualize your journey with tonal progress tracking.`
  String get visualizeYourJourneyWithTonalProgressTracking {
    return Intl.message(
      'Visualize your journey with tonal progress tracking.',
      name: 'visualizeYourJourneyWithTonalProgressTracking',
      desc: '',
      args: [],
    );
  }

  /// `Aesthetic Focus`
  String get aestheticFocus {
    return Intl.message(
      'Aesthetic Focus',
      name: 'aestheticFocus',
      desc: '',
      args: [],
    );
  }

  /// `Minimalist UI designed for zero-distraction study.`
  String get minimalistUiDesignedForZeroDistractionStudy {
    return Intl.message(
      'Minimalist UI designed for zero-distraction study.',
      name: 'minimalistUiDesignedForZeroDistractionStudy',
      desc: '',
      args: [],
    );
  }

  /// `What do you want to learn?`
  String get whatDoYouWantToLearn {
    return Intl.message(
      'What do you want to learn?',
      name: 'whatDoYouWantToLearn',
      desc: '',
      args: [],
    );
  }

  /// `Choose a language to start your journey into quiet productivity and focused growth.`
  String
  get chooseALanguageToStartYourJourneyIntoQuietProductivityAndFocusedGrowth {
    return Intl.message(
      'Choose a language to start your journey into quiet productivity and focused growth.',
      name:
          'chooseALanguageToStartYourJourneyIntoQuietProductivityAndFocusedGrowth',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continueText {
    return Intl.message('Continue', name: 'continueText', desc: '', args: []);
  }

  /// `Why are you learning?`
  String get whyAreYouLearning {
    return Intl.message(
      'Why are you learning?',
      name: 'whyAreYouLearning',
      desc: '',
      args: [],
    );
  }

  /// `We'll tailor your experience to help you reach your goals faster.`
  String get wellTailorYourExperienceToHelpYouReachYourGoalsFaster {
    return Intl.message(
      'We\'ll tailor your experience to help you reach your goals faster.',
      name: 'wellTailorYourExperienceToHelpYouReachYourGoalsFaster',
      desc: '',
      args: [],
    );
  }

  /// `This helps us tailor the lessons to your current knowledge and learning pace.`
  String get thisHelpsUsTailorTheLessonsToYourCurrentKnowledgeAndLearningPace {
    return Intl.message(
      'This helps us tailor the lessons to your current knowledge and learning pace.',
      name: 'thisHelpsUsTailorTheLessonsToYourCurrentKnowledgeAndLearningPace',
      desc: '',
      args: [],
    );
  }

  /// `Navigate new cities and connect with locals.`
  String get navigateNewCitiesAndConnectWithLocals {
    return Intl.message(
      'Navigate new cities and connect with locals.',
      name: 'navigateNewCitiesAndConnectWithLocals',
      desc: '',
      args: [],
    );
  }

  /// `Excel in your studies and master exams.`
  String get excelInYourStudiesAndMasterExams {
    return Intl.message(
      'Excel in your studies and master exams.',
      name: 'excelInYourStudiesAndMasterExams',
      desc: '',
      args: [],
    );
  }

  /// `School`
  String get school {
    return Intl.message('School', name: 'school', desc: '', args: []);
  }

  /// `Career`
  String get career {
    return Intl.message('Career', name: 'career', desc: '', args: []);
  }

  /// `Vocab`
  String get vocab {
    return Intl.message('Vocab', name: 'vocab', desc: '', args: []);
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `Chat`
  String get chat {
    return Intl.message('Chat', name: 'chat', desc: '', args: []);
  }

  /// `Start Lesson`
  String get startLesson {
    return Intl.message(
      'Start Lesson',
      name: 'startLesson',
      desc: '',
      args: [],
    );
  }

  /// `Boost your resume and unlock global opportunities.`
  String get boostYourResumeAndUnlockGlobalOpportunities {
    return Intl.message(
      'Boost your resume and unlock global opportunities.',
      name: 'boostYourResumeAndUnlockGlobalOpportunities',
      desc: '',
      args: [],
    );
  }

  /// `Set your daily goal`
  String get setYourDailyGoal {
    return Intl.message(
      'Set your daily goal',
      name: 'setYourDailyGoal',
      desc: '',
      args: [],
    );
  }

  /// `Consistency is key to mastering new skills.`
  String get consistencyIsKeyToMasteringNewSkills {
    return Intl.message(
      'Consistency is key to mastering new skills.',
      name: 'consistencyIsKeyToMasteringNewSkills',
      desc: '',
      args: [],
    );
  }

  /// `Choose a pace that fits your lifestyle.`
  String get chooseAPaceThatFitsYourLifestyle {
    return Intl.message(
      'Choose a pace that fits your lifestyle.',
      name: 'chooseAPaceThatFitsYourLifestyle',
      desc: '',
      args: [],
    );
  }

  /// `5 mins per day`
  String get fiveMinsPerDay {
    return Intl.message(
      '5 mins per day',
      name: 'fiveMinsPerDay',
      desc: '',
      args: [],
    );
  }

  /// `10 mins per day`
  String get tenMinsPerDay {
    return Intl.message(
      '10 mins per day',
      name: 'tenMinsPerDay',
      desc: '',
      args: [],
    );
  }

  /// `15 mins per day`
  String get fifteenMinsPerDay {
    return Intl.message(
      '15 mins per day',
      name: 'fifteenMinsPerDay',
      desc: '',
      args: [],
    );
  }

  /// `20 mins per day`
  String get twentyMinsPerDay {
    return Intl.message(
      '20 mins per day',
      name: 'twentyMinsPerDay',
      desc: '',
      args: [],
    );
  }

  /// `Casual`
  String get casual {
    return Intl.message('Casual', name: 'casual', desc: '', args: []);
  }

  /// `Regular`
  String get regular {
    return Intl.message('Regular', name: 'regular', desc: '', args: []);
  }

  /// `Serious`
  String get serious {
    return Intl.message('Serious', name: 'serious', desc: '', args: []);
  }

  /// `Intense`
  String get intense {
    return Intl.message('Intense', name: 'intense', desc: '', args: []);
  }

  /// `Beginner`
  String get beginner {
    return Intl.message('Beginner', name: 'beginner', desc: '', args: []);
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `New to this topic, starting from scratch.`
  String get newToThisTopicStartingFromScratch {
    return Intl.message(
      'New to this topic, starting from scratch.',
      name: 'newToThisTopicStartingFromScratch',
      desc: '',
      args: [],
    );
  }

  /// `Intermediate`
  String get intermediate {
    return Intl.message(
      'Intermediate',
      name: 'intermediate',
      desc: '',
      args: [],
    );
  }

  /// `Comfortable with basics, seeking deeper mastery.`
  String get comfortableWithBasicsSeekingDeeperMastery {
    return Intl.message(
      'Comfortable with basics, seeking deeper mastery.',
      name: 'comfortableWithBasicsSeekingDeeperMastery',
      desc: '',
      args: [],
    );
  }

  /// `Advanced`
  String get advanced {
    return Intl.message('Advanced', name: 'advanced', desc: '', args: []);
  }

  /// `Expert knowledge, looking for advanced nuances.`
  String get expertKnowledgeLookingForAdvancedNuances {
    return Intl.message(
      'Expert knowledge, looking for advanced nuances.',
      name: 'expertKnowledgeLookingForAdvancedNuances',
      desc: '',
      args: [],
    );
  }

  /// `Your experience level?`
  String get yourExperienceLevel {
    return Intl.message(
      'Your experience level?',
      name: 'yourExperienceLevel',
      desc: '',
      args: [],
    );
  }

  /// `Next Word`
  String get nextWord {
    return Intl.message('Next Word', name: 'nextWord', desc: '', args: []);
  }

  /// `Next Question`
  String get nextQuestion {
    return Intl.message(
      'Next Question',
      name: 'nextQuestion',
      desc: '',
      args: [],
    );
  }

  /// `See Results`
  String get seeResults {
    return Intl.message('See Results', name: 'seeResults', desc: '', args: []);
  }

  /// `Question`
  String get question {
    return Intl.message('Question', name: 'question', desc: '', args: []);
  }

  /// `Previous Word`
  String get previousWord {
    return Intl.message(
      'Previous Word',
      name: 'previousWord',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get history {
    return Intl.message('History', name: 'history', desc: '', args: []);
  }

  /// `You're making excellent progress.`
  String get youreMakingExcellentProgress {
    return Intl.message(
      'You\'re making excellent progress.',
      name: 'youreMakingExcellentProgress',
      desc: '',
      args: [],
    );
  }

  /// `Great Job!`
  String get greatJob {
    return Intl.message('Great Job!', name: 'greatJob', desc: '', args: []);
  }

  /// `You've completed your vocabulary session`
  String get youveCompletedYourVocabularySession {
    return Intl.message(
      'You\'ve completed your vocabulary session',
      name: 'youveCompletedYourVocabularySession',
      desc: '',
      args: [],
    );
  }

  /// `Ready for Exercise?`
  String get readyForExercise {
    return Intl.message(
      'Ready for Exercise?',
      name: 'readyForExercise',
      desc: '',
      args: [],
    );
  }

  /// `Start Exercise`
  String get startExercise {
    return Intl.message(
      'Start Exercise',
      name: 'startExercise',
      desc: '',
      args: [],
    );
  }

  /// `Review Words`
  String get reviewWords {
    return Intl.message(
      'Review Words',
      name: 'reviewWords',
      desc: '',
      args: [],
    );
  }

  /// `100%`
  String get oneHundredPercent {
    return Intl.message('100%', name: 'oneHundredPercent', desc: '', args: []);
  }

  /// `Exit Lesson?`
  String get exitLesson {
    return Intl.message('Exit Lesson?', name: 'exitLesson', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Check Answer`
  String get checkAnswer {
    return Intl.message(
      'Check Answer',
      name: 'checkAnswer',
      desc: '',
      args: [],
    );
  }

  /// `Drag words here:`
  String get dragWordsHere {
    return Intl.message(
      'Drag words here:',
      name: 'dragWordsHere',
      desc: '',
      args: [],
    );
  }

  /// `Oops! Wrong answer, try again.`
  String get oopsWrongAnswerTryAgain {
    return Intl.message(
      'Oops! Wrong answer, try again.',
      name: 'oopsWrongAnswerTryAgain',
      desc: '',
      args: [],
    );
  }

  /// `Drag the correct word to the blank space:`
  String get dragTheCorrectWordToTheBlankSpace {
    return Intl.message(
      'Drag the correct word to the blank space:',
      name: 'dragTheCorrectWordToTheBlankSpace',
      desc: '',
      args: [],
    );
  }

  /// `Current streak`
  String get currentStreak {
    return Intl.message(
      'Current streak',
      name: 'currentStreak',
      desc: '',
      args: [],
    );
  }

  /// `Preferences`
  String get preferences {
    return Intl.message('Preferences', name: 'preferences', desc: '', args: []);
  }

  /// `Account`
  String get account {
    return Intl.message('Account', name: 'account', desc: '', args: []);
  }

  /// `Learning Language :`
  String get learningLanguage {
    return Intl.message(
      'Learning Language :',
      name: 'learningLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Daily Goal :`
  String get dailyGoal {
    return Intl.message('Daily Goal :', name: 'dailyGoal', desc: '', args: []);
  }

  /// `Personal Information`
  String get personalInformation {
    return Intl.message(
      'Personal Information',
      name: 'personalInformation',
      desc: '',
      args: [],
    );
  }

  /// `Current points`
  String get currentPoints {
    return Intl.message(
      'Current points',
      name: 'currentPoints',
      desc: '',
      args: [],
    );
  }

  /// `{count} days`
  String streakDays(Object count) {
    return Intl.message(
      '$count days',
      name: 'streakDays',
      desc: '',
      args: [count],
    );
  }

  /// `{points} XP`
  String xpPointsValue(Object points) {
    return Intl.message(
      '$points XP',
      name: 'xpPointsValue',
      desc: '',
      args: [points],
    );
  }

  /// `Generating your vocabulary...`
  String get generatingYourVocabulary {
    return Intl.message(
      'Generating your vocabulary...',
      name: 'generatingYourVocabulary',
      desc: '',
      args: [],
    );
  }

  /// `Language not selected`
  String get languageNotSelected {
    return Intl.message(
      'Language not selected',
      name: 'languageNotSelected',
      desc: '',
      args: [],
    );
  }

  /// `Tap to reveal meaning`
  String get tapToRevealMeaning {
    return Intl.message(
      'Tap to reveal meaning',
      name: 'tapToRevealMeaning',
      desc: '',
      args: [],
    );
  }

  /// `Question {currentIndex} of {totalCount}`
  String questionProgress(Object currentIndex, Object totalCount) {
    return Intl.message(
      'Question $currentIndex of $totalCount',
      name: 'questionProgress',
      desc: '',
      args: [currentIndex, totalCount],
    );
  }

  /// `Lesson Complete!`
  String get lessonComplete {
    return Intl.message(
      'Lesson Complete!',
      name: 'lessonComplete',
      desc: '',
      args: [],
    );
  }

  /// `{percentage}%`
  String scorePercentageValue(Object percentage) {
    return Intl.message(
      '$percentage%',
      name: 'scorePercentageValue',
      desc: '',
      args: [percentage],
    );
  }

  /// `{score}/{total}`
  String scoreFraction(Object score, Object total) {
    return Intl.message(
      '$score/$total',
      name: 'scoreFraction',
      desc: '',
      args: [score, total],
    );
  }

  /// `XP Earned`
  String get xpEarned {
    return Intl.message('XP Earned', name: 'xpEarned', desc: '', args: []);
  }

  /// `Streak`
  String get streak {
    return Intl.message('Streak', name: 'streak', desc: '', args: []);
  }

  /// `✅ Mastered Words`
  String get masteredWords {
    return Intl.message(
      '✅ Mastered Words',
      name: 'masteredWords',
      desc: '',
      args: [],
    );
  }

  /// `📚 Need Review`
  String get needReview {
    return Intl.message(
      '📚 Need Review',
      name: 'needReview',
      desc: '',
      args: [],
    );
  }

  /// `{count, plural, =1{1 word} other{{count} words}}`
  String wordCountValue(num count) {
    return Intl.plural(
      count,
      one: '1 word',
      other: '$count words',
      name: 'wordCountValue',
      desc: '',
      args: [count],
    );
  }

  /// `🎉 Excellent!`
  String get perfExcellent {
    return Intl.message(
      '🎉 Excellent!',
      name: 'perfExcellent',
      desc: '',
      args: [],
    );
  }

  /// `👏 Great job!`
  String get perfGreatJob {
    return Intl.message(
      '👏 Great job!',
      name: 'perfGreatJob',
      desc: '',
      args: [],
    );
  }

  /// `👍 Good work!`
  String get perfGoodWork {
    return Intl.message(
      '👍 Good work!',
      name: 'perfGoodWork',
      desc: '',
      args: [],
    );
  }

  /// `💪 Keep practicing!`
  String get perfKeepPracticing {
    return Intl.message(
      '💪 Keep practicing!',
      name: 'perfKeepPracticing',
      desc: '',
      args: [],
    );
  }

  /// `📚 Review and try again!`
  String get perfReviewAndTryAgain {
    return Intl.message(
      '📚 Review and try again!',
      name: 'perfReviewAndTryAgain',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get timeToday {
    return Intl.message('Today', name: 'timeToday', desc: '', args: []);
  }

  /// `Yesterday`
  String get timeYesterday {
    return Intl.message('Yesterday', name: 'timeYesterday', desc: '', args: []);
  }

  /// `{count, plural, =1{1 day ago} other{{count} days ago}}`
  String timeDaysAgo(num count) {
    return Intl.plural(
      count,
      one: '1 day ago',
      other: '$count days ago',
      name: 'timeDaysAgo',
      desc: '',
      args: [count],
    );
  }

  /// `No chat history`
  String get noChatHistory {
    return Intl.message(
      'No chat history',
      name: 'noChatHistory',
      desc: '',
      args: [],
    );
  }

  /// `App Language`
  String get appLanguage {
    return Intl.message(
      'App Language',
      name: 'appLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Select Language`
  String get selectLanguage {
    return Intl.message(
      'Select Language',
      name: 'selectLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Word {currentIndex} / {totalCount}`
  String wordProgressFraction(Object currentIndex, Object totalCount) {
    return Intl.message(
      'Word $currentIndex / $totalCount',
      name: 'wordProgressFraction',
      desc: '',
      args: [currentIndex, totalCount],
    );
  }

  /// `Change Language?`
  String get changeLanguageDialogTitle {
    return Intl.message(
      'Change Language?',
      name: 'changeLanguageDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `If you change the app language now, vocabulary translations will update for newly generated words only. Your current vocabulary will remain in the previous language.\n\nDo you want to continue?`
  String get changeLanguageDialogMessage {
    return Intl.message(
      'If you change the app language now, vocabulary translations will update for newly generated words only. Your current vocabulary will remain in the previous language.\n\nDo you want to continue?',
      name: 'changeLanguageDialogMessage',
      desc: '',
      args: [],
    );
  }

  /// `Yes, Change`
  String get changeLanguageDialogConfirm {
    return Intl.message(
      'Yes, Change',
      name: 'changeLanguageDialogConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get changeLanguageDialogCancel {
    return Intl.message(
      'Cancel',
      name: 'changeLanguageDialogCancel',
      desc: '',
      args: [],
    );
  }

  /// `Generation failed, please retry`
  String get generationFailedPleaseRetry {
    return Intl.message(
      'Generation failed, please retry',
      name: 'generationFailedPleaseRetry',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get retry {
    return Intl.message('Retry', name: 'retry', desc: '', args: []);
  }

  /// `Arrange the words to form: {currentTranslation}`
  String arrangeWordsToForm(Object currentTranslation) {
    return Intl.message(
      'Arrange the words to form: $currentTranslation',
      name: 'arrangeWordsToForm',
      desc: '',
      args: [currentTranslation],
    );
  }

  /// `Correct order: {currentSentence}`
  String correctOrder(Object currentSentence) {
    return Intl.message(
      'Correct order: $currentSentence',
      name: 'correctOrder',
      desc: '',
      args: [currentSentence],
    );
  }

  /// `Fill in the blank for: '{wordTranslation}' → _____`
  String fillInTheBlank(Object wordTranslation) {
    return Intl.message(
      'Fill in the blank for: \'$wordTranslation\' → _____',
      name: 'fillInTheBlank',
      desc: '',
      args: [wordTranslation],
    );
  }

  /// `Pick the correct translation`
  String get pickTheCorrectTranslation {
    return Intl.message(
      'Pick the correct translation',
      name: 'pickTheCorrectTranslation',
      desc: '',
      args: [],
    );
  }

  /// `Join the Journey`
  String get joinTheJourney {
    return Intl.message(
      'Join the Journey',
      name: 'joinTheJourney',
      desc: '',
      args: [],
    );
  }

  /// `Master new skills with an immersive, game-like experience.`
  String get masterNewSkills {
    return Intl.message(
      'Master new skills with an immersive, game-like experience.',
      name: 'masterNewSkills',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Confirm password`
  String get confirmPassword {
    return Intl.message(
      'Confirm password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm password is required`
  String get confirmPasswordIsRequired {
    return Intl.message(
      'Confirm password is required',
      name: 'confirmPasswordIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `password doesnt match!`
  String get passwordDoesntMatch {
    return Intl.message(
      'password doesnt match!',
      name: 'passwordDoesntMatch',
      desc: '',
      args: [],
    );
  }

  /// `Please select your gender`
  String get pleaseSelectYourGender {
    return Intl.message(
      'Please select your gender',
      name: 'pleaseSelectYourGender',
      desc: '',
      args: [],
    );
  }

  /// `Age`
  String get age {
    return Intl.message('Age', name: 'age', desc: '', args: []);
  }

  /// `Select your gender`
  String get selectYourGender {
    return Intl.message(
      'Select your gender',
      name: 'selectYourGender',
      desc: '',
      args: [],
    );
  }

  /// `years old`
  String get yearsOld {
    return Intl.message('years old', name: 'yearsOld', desc: '', args: []);
  }

  /// `Minimum 8 characters required`
  String get minimumEightCharactersRequired {
    return Intl.message(
      'Minimum 8 characters required',
      name: 'minimumEightCharactersRequired',
      desc: '',
      args: [],
    );
  }

  /// `Must contain at least 1 uppercase letter`
  String get mustContainAtLeastOneUppercaseLetter {
    return Intl.message(
      'Must contain at least 1 uppercase letter',
      name: 'mustContainAtLeastOneUppercaseLetter',
      desc: '',
      args: [],
    );
  }

  /// `Must contain at least 1 lowercase letter`
  String get mustContainAtLeastOneLowercaseLetter {
    return Intl.message(
      'Must contain at least 1 lowercase letter',
      name: 'mustContainAtLeastOneLowercaseLetter',
      desc: '',
      args: [],
    );
  }

  /// `Must contain at least 1 number`
  String get mustContainAtLeastOneNumber {
    return Intl.message(
      'Must contain at least 1 number',
      name: 'mustContainAtLeastOneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Must contain 1 special character`
  String get mustContainOneSpecialCharacter {
    return Intl.message(
      'Must contain 1 special character',
      name: 'mustContainOneSpecialCharacter',
      desc: '',
      args: [],
    );
  }

  /// `Gender`
  String get gender {
    return Intl.message('Gender', name: 'gender', desc: '', args: []);
  }

  /// `Male`
  String get male {
    return Intl.message('Male', name: 'male', desc: '', args: []);
  }

  /// `Female`
  String get female {
    return Intl.message('Female', name: 'female', desc: '', args: []);
  }

  /// `Other`
  String get other {
    return Intl.message('Other', name: 'other', desc: '', args: []);
  }

  /// `How much time can you dedicate?`
  String get howMuchTimeCanYouDedicate {
    return Intl.message(
      'How much time can you dedicate?',
      name: 'howMuchTimeCanYouDedicate',
      desc: '',
      args: [],
    );
  }

  /// `5 min/day | Perfect for beginners`
  String get fiveMinPerDay {
    return Intl.message(
      '5 min/day | Perfect for beginners',
      name: 'fiveMinPerDay',
      desc: '',
      args: [],
    );
  }

  /// `10 min/day | Stay consistent`
  String get tenMinPerDay {
    return Intl.message(
      '10 min/day | Stay consistent',
      name: 'tenMinPerDay',
      desc: '',
      args: [],
    );
  }

  /// `15 min/day | Make real progress`
  String get fifteenMinPerDay {
    return Intl.message(
      '15 min/day | Make real progress',
      name: 'fifteenMinPerDay',
      desc: '',
      args: [],
    );
  }

  /// `20 min/day | Fast track to fluency`
  String get twentyMinPerDay {
    return Intl.message(
      '20 min/day | Fast track to fluency',
      name: 'twentyMinPerDay',
      desc: '',
      args: [],
    );
  }

  /// `words / exercise`
  String get wordsExercise {
    return Intl.message(
      'words / exercise',
      name: 'wordsExercise',
      desc: '',
      args: [],
    );
  }

  /// `Master {count} new phrases in your {language} essentials course.`
  String masterNewPhrases(Object count, Object language) {
    return Intl.message(
      'Master $count new phrases in your $language essentials course.',
      name: 'masterNewPhrases',
      desc: '',
      args: [count, language],
    );
  }

  /// `Ready for today?`
  String get readyForToday {
    return Intl.message(
      'Ready for today?',
      name: 'readyForToday',
      desc: '',
      args: [],
    );
  }

  /// `Finish`
  String get finish {
    return Intl.message('Finish', name: 'finish', desc: '', args: []);
  }

  /// `Change Daily Goal?`
  String get changeDailyGoalDialogTitle {
    return Intl.message(
      'Change Daily Goal?',
      name: 'changeDailyGoalDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your daily vocabulary will change to {wordCount} words per session.`
  String changeDailyGoalDialogMessage(Object wordCount) {
    return Intl.message(
      'Your daily vocabulary will change to $wordCount words per session.',
      name: 'changeDailyGoalDialogMessage',
      desc: '',
      args: [wordCount],
    );
  }

  /// `Translation`
  String get translation {
    return Intl.message('Translation', name: 'translation', desc: '', args: []);
  }

  /// `Enter email`
  String get enterEmail {
    return Intl.message('Enter email', name: 'enterEmail', desc: '', args: []);
  }

  /// `Enter password`
  String get enterPassword {
    return Intl.message(
      'Enter password',
      name: 'enterPassword',
      desc: '',
      args: [],
    );
  }

  /// `Visible password`
  String get visiblePassword {
    return Intl.message(
      'Visible password',
      name: 'visiblePassword',
      desc: '',
      args: [],
    );
  }

  /// `Step {currentIndex} of {totalCount}`
  String stepProgressFraction(Object currentIndex, Object totalCount) {
    return Intl.message(
      'Step $currentIndex of $totalCount',
      name: 'stepProgressFraction',
      desc: '',
      args: [currentIndex, totalCount],
    );
  }

  /// `Syncing progress...`
  String get syncingProgress {
    return Intl.message(
      'Syncing progress...',
      name: 'syncingProgress',
      desc: '',
      args: [],
    );
  }

  /// `Master any language`
  String get masterAnyLang {
    return Intl.message(
      'Master any language',
      name: 'masterAnyLang',
      desc: '',
      args: [],
    );
  }

  /// `Learn anytime, anywhere`
  String get learnAnytime {
    return Intl.message(
      'Learn anytime, anywhere',
      name: 'learnAnytime',
      desc: '',
      args: [],
    );
  }

  /// `Unlock your potential`
  String get unlockYourPotential {
    return Intl.message(
      'Unlock your potential',
      name: 'unlockYourPotential',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Your journey to fluency continues here.`
  String get yourJourneyToFluencyContinuesHere {
    return Intl.message(
      'Your journey to fluency continues here.',
      name: 'yourJourneyToFluencyContinuesHere',
      desc: '',
      args: [],
    );
  }

  /// `Join millions of learners and master new skills through bite-sized, gamified lessons that feel like a game.`
  String get onboardSubtitle1 {
    return Intl.message(
      'Join millions of learners and master new skills through bite-sized, gamified lessons that feel like a game.',
      name: 'onboardSubtitle1',
      desc: '',
      args: [],
    );
  }

  /// `Whether you have 5 minutes or 50, our lessons fit perfectly into your busy schedule.`
  String get onboardSubtitle2 {
    return Intl.message(
      'Whether you have 5 minutes or 50, our lessons fit perfectly into your busy schedule.',
      name: 'onboardSubtitle2',
      desc: '',
      args: [],
    );
  }

  /// `Stay motivated with daily streaks, earn rewards, and track your progress as you reach new levels of mastery.`
  String get onboardSubtitle3 {
    return Intl.message(
      'Stay motivated with daily streaks, earn rewards, and track your progress as you reach new levels of mastery.',
      name: 'onboardSubtitle3',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong`
  String get somethingWentWrong {
    return Intl.message(
      'Something went wrong',
      name: 'somethingWentWrong',
      desc: '',
      args: [],
    );
  }

  /// `Login failed`
  String get loginFailed {
    return Intl.message(
      'Login failed',
      name: 'loginFailed',
      desc: '',
      args: [],
    );
  }

  /// `Registration failed`
  String get registrationFailed {
    return Intl.message(
      'Registration failed',
      name: 'registrationFailed',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message('Next', name: 'next', desc: '', args: []);
  }

  /// `Skip`
  String get skip {
    return Intl.message('Skip', name: 'skip', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'gu'),
      Locale.fromSubtags(languageCode: 'hi'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
