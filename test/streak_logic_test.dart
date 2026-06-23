import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

// Simulating the Firestore update logic for testing
Map<String, dynamic> checkAndUpdateStreakSimulated({
  required Map<String, dynamic> data,
  required DateTime today,
}) {
  final todayStr = DateFormat('yyyy-MM-dd').format(today);
  final lastSessionDateStr = data['lastSessionDate'] as String?;
  final lastCheckedDateStr = data['lastCheckedDate'] as String?;

  if (lastCheckedDateStr == todayStr) {
    return {}; // No updates, skipped
  }

  final updates = <String, dynamic>{
    'lastCheckedDate': todayStr,
  };

  if (lastSessionDateStr != null) {
    final lastSessionDate = DateTime.parse(lastSessionDateStr);
    final todayMidnight = DateTime(today.year, today.month, today.day);
    final lastSessionMidnight = DateTime(
      lastSessionDate.year,
      lastSessionDate.month,
      lastSessionDate.day,
    );
    final daysDiff = todayMidnight.difference(lastSessionMidnight).inDays;

    if (daysDiff > 1) {
      final missedDays = daysDiff - 1;
      final freezesOwned = (data['freezesOwned'] ?? 0) as int;

      if (freezesOwned >= missedDays) {
        updates['freezesOwned'] = freezesOwned - missedDays;
        updates['consecutiveSessionDays'] = 0;
        final yesterday = todayMidnight.subtract(const Duration(days: 1));
        updates['lastSessionDate'] = DateFormat('yyyy-MM-dd').format(yesterday);
      } else {
        updates['currentStreak'] = 0;
        updates['current_streak'] = 0;
        updates['consecutiveSessionDays'] = 0;
        updates['freezesOwned'] = 0;
      }
    }
  } else {
    updates['currentStreak'] = data['currentStreak'] ?? data['current_streak'] ?? 0;
    updates['consecutiveSessionDays'] = data['consecutiveSessionDays'] ?? 0;
    updates['freezesOwned'] = data['freezesOwned'] ?? 0;
  }

  return updates;
}

Map<String, dynamic> onSessionCompletedSimulated({
  required Map<String, dynamic> data,
  required DateTime today,
}) {
  final todayStr = DateFormat('yyyy-MM-dd').format(today);
  final lastSessionDateStr = data['lastSessionDate'] as String?;
  int currentStreak = (data['currentStreak'] ?? data['current_streak'] ?? 0) as int;
  int consecutiveSessionDays = (data['consecutiveSessionDays'] ?? 0) as int;
  int freezesOwned = (data['freezesOwned'] ?? 0) as int;
  final isPremium = (data['isPremium'] ?? data['is_premium'] ?? false) as bool;

  if (lastSessionDateStr == todayStr) {
    return {}; // skipped
  }

  currentStreak += 1;
  consecutiveSessionDays += 1;

  if (consecutiveSessionDays >= 7) {
    consecutiveSessionDays = 0;
    if (isPremium) {
      freezesOwned += 1;
    } else {
      if (freezesOwned < 1) {
        freezesOwned = 1;
      }
    }
  }

  final longestStreak = (data['longest_streak'] ?? 0) as int;
  final newLongest = currentStreak > longestStreak ? currentStreak : longestStreak;

  return {
    'currentStreak': currentStreak,
    'current_streak': currentStreak,
    'consecutiveSessionDays': consecutiveSessionDays,
    'freezesOwned': freezesOwned,
    'lastSessionDate': todayStr,
    'longest_streak': newLongest,
  };
}

void main() {
  group('Streak logic unit tests', () {
    test('checkAndUpdateStreak - same day skip', () {
      final today = DateTime(2026, 6, 23);
      final data = {
        'lastCheckedDate': '2026-06-23',
        'lastSessionDate': '2026-06-22',
        'currentStreak': 5,
        'consecutiveSessionDays': 3,
        'freezesOwned': 1,
      };

      final updates = checkAndUpdateStreakSimulated(data: data, today: today);
      expect(updates, isEmpty);
    });

    test('checkAndUpdateStreak - no missed days (session yesterday)', () {
      final today = DateTime(2026, 6, 23);
      final data = {
        'lastCheckedDate': '2026-06-22',
        'lastSessionDate': '2026-06-22',
        'currentStreak': 5,
        'consecutiveSessionDays': 3,
        'freezesOwned': 1,
      };

      final updates = checkAndUpdateStreakSimulated(data: data, today: today);
      expect(updates['lastCheckedDate'], '2026-06-23');
      // No other updates since streak is not broken
      expect(updates.length, 1);
    });

    test('checkAndUpdateStreak - missed 1 day with 1 freeze (should consume freeze)', () {
      final today = DateTime(2026, 6, 23);
      final data = {
        'lastCheckedDate': '2026-06-21',
        'lastSessionDate': '2026-06-21', // missed yesterday (June 22)
        'currentStreak': 5,
        'consecutiveSessionDays': 3,
        'freezesOwned': 1,
      };

      final updates = checkAndUpdateStreakSimulated(data: data, today: today);
      expect(updates['lastCheckedDate'], '2026-06-23');
      expect(updates['freezesOwned'], 0);
      expect(updates['consecutiveSessionDays'], 0);
      expect(updates['lastSessionDate'], '2026-06-22'); // set to yesterday to preserve streak
    });

    test('checkAndUpdateStreak - missed 1 day with 0 freezes (should break streak)', () {
      final today = DateTime(2026, 6, 23);
      final data = {
        'lastCheckedDate': '2026-06-21',
        'lastSessionDate': '2026-06-21', // missed yesterday
        'currentStreak': 5,
        'consecutiveSessionDays': 3,
        'freezesOwned': 0,
      };

      final updates = checkAndUpdateStreakSimulated(data: data, today: today);
      expect(updates['lastCheckedDate'], '2026-06-23');
      expect(updates['currentStreak'], 0);
      expect(updates['consecutiveSessionDays'], 0);
      expect(updates['freezesOwned'], 0);
    });

    test('checkAndUpdateStreak - missed 2 days with 2 freezes (should consume both freezes)', () {
      final today = DateTime(2026, 6, 23);
      final data = {
        'lastCheckedDate': '2026-06-20',
        'lastSessionDate': '2026-06-20', // missed June 21 and June 22
        'currentStreak': 5,
        'consecutiveSessionDays': 3,
        'freezesOwned': 2,
      };

      final updates = checkAndUpdateStreakSimulated(data: data, today: today);
      expect(updates['lastCheckedDate'], '2026-06-23');
      expect(updates['freezesOwned'], 0);
      expect(updates['consecutiveSessionDays'], 0);
      expect(updates['lastSessionDate'], '2026-06-22'); // set to yesterday
    });

    test('checkAndUpdateStreak - missed 2 days with 1 freeze (not enough freezes, streak breaks)', () {
      final today = DateTime(2026, 6, 23);
      final data = {
        'lastCheckedDate': '2026-06-20',
        'lastSessionDate': '2026-06-20',
        'currentStreak': 5,
        'consecutiveSessionDays': 3,
        'freezesOwned': 1,
      };

      final updates = checkAndUpdateStreakSimulated(data: data, today: today);
      expect(updates['lastCheckedDate'], '2026-06-23');
      expect(updates['currentStreak'], 0);
      expect(updates['consecutiveSessionDays'], 0);
      expect(updates['freezesOwned'], 0);
    });

    test('onSessionCompleted - increment streak and consecutive days', () {
      final today = DateTime(2026, 6, 23);
      final data = {
        'lastSessionDate': '2026-06-22',
        'currentStreak': 5,
        'consecutiveSessionDays': 3,
        'freezesOwned': 0,
        'isPremium': false,
        'longest_streak': 5,
      };

      final updates = onSessionCompletedSimulated(data: data, today: today);
      expect(updates['currentStreak'], 6);
      expect(updates['consecutiveSessionDays'], 4);
      expect(updates['freezesOwned'], 0);
      expect(updates['lastSessionDate'], '2026-06-23');
      expect(updates['longest_streak'], 6);
    });

    test('onSessionCompleted - earn freeze for free user (cap 1)', () {
      final today = DateTime(2026, 6, 23);
      final data = {
        'lastSessionDate': '2026-06-22',
        'currentStreak': 6,
        'consecutiveSessionDays': 6, // will hit 7
        'freezesOwned': 0,
        'isPremium': false,
      };

      final updates = onSessionCompletedSimulated(data: data, today: today);
      expect(updates['consecutiveSessionDays'], 0);
      expect(updates['freezesOwned'], 1);
    });

    test('onSessionCompleted - earn freeze for free user capped at 1', () {
      final today = DateTime(2026, 6, 23);
      final data = {
        'lastSessionDate': '2026-06-22',
        'currentStreak': 6,
        'consecutiveSessionDays': 6, // will hit 7
        'freezesOwned': 1,
        'isPremium': false,
      };

      final updates = onSessionCompletedSimulated(data: data, today: today);
      expect(updates['consecutiveSessionDays'], 0);
      expect(updates['freezesOwned'], 1); // remains 1 (capped)
    });

    test('onSessionCompleted - earn freeze for premium user (no cap)', () {
      final today = DateTime(2026, 6, 23);
      final data = {
        'lastSessionDate': '2026-06-22',
        'currentStreak': 6,
        'consecutiveSessionDays': 6, // will hit 7
        'freezesOwned': 2,
        'isPremium': true,
      };

      final updates = onSessionCompletedSimulated(data: data, today: today);
      expect(updates['consecutiveSessionDays'], 0);
      expect(updates['freezesOwned'], 3); // increments to 3
    });

    test('onSessionCompleted - duplicate session same day (should skip)', () {
      final today = DateTime(2026, 6, 23);
      final data = {
        'lastSessionDate': '2026-06-23',
        'currentStreak': 7,
        'consecutiveSessionDays': 0,
        'freezesOwned': 1,
      };

      final updates = onSessionCompletedSimulated(data: data, today: today);
      expect(updates, isEmpty);
    });
  });

  group('Specific edge cases', () {
    test('checkAndUpdateStreak - initializing missing fields', () {
      final today = DateTime(2026, 6, 23);
      final data = <String, dynamic>{};
      final updates = checkAndUpdateStreakSimulated(data: data, today: today);
      expect(updates['lastCheckedDate'], '2026-06-23');
      expect(updates['currentStreak'], 0);
      expect(updates['consecutiveSessionDays'], 0);
      expect(updates['freezesOwned'], 0);
    });
  });
}
