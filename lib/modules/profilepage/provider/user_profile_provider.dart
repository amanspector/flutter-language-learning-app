import 'package:flutter/material.dart';

class UserProfileProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _selectedGender;
  int _age = 24;

  bool get isLoading => _isLoading;
  String? get selectedGender => _selectedGender;
  int get age => _age;

  void init(String? initialGender, int initialAge) {
    _isLoading = false;
    _selectedGender = initialGender;
    _age = initialAge > 0 ? initialAge : 24;
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setGender(String gender) {
    _selectedGender = gender;
    notifyListeners();
  }

  void setAge(int newAge) {
    _age = newAge.clamp(10, 60);
    notifyListeners();
  }
}
