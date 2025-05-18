import 'package:flutter/material.dart';
import 'package:me_lond/models/user.dart';

class UserProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;
  String? get error => _error;

  // Simple ID generator
  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  // Mock login for development
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock user creation - In a real app, this would come from a backend
      _currentUser = User(
        id: _generateId(),
        username: email.split('@').first,
        displayName: 'User ${email.split('@').first}',
        profileImage: 'https://i.pravatar.cc/300',
        bio: 'I love streaming!',
        followers: 100,
        following: 50,
        diamonds: 1000,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to login: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 500));

      _currentUser = null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to logout: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update user's diamond balance
  void updateDiamonds(int amount) {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        diamonds: _currentUser!.diamonds + amount,
      );
      notifyListeners();
    }
  }

  // Toggle user's live status
  void toggleLiveStatus(bool isLive) {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(isLive: isLive);
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
