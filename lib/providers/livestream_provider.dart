import 'package:flutter/material.dart';
import 'package:me_lond/models/livestream.dart';
import 'package:me_lond/models/user.dart';

class LivestreamProvider extends ChangeNotifier {
  final List<Livestream> _livestreams = [];
  Livestream? _activeLivestream;
  bool _isLoading = false;
  String? _error;

  List<Livestream> get livestreams => List.unmodifiable(_livestreams);
  Livestream? get activeLivestream => _activeLivestream;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Simple ID generator
  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  // Load mock livestreams
  Future<void> loadLivestreams() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // Clear existing data
      _livestreams.clear();

      // Create mock users
      final users = [
        User(
          id: '1',
          username: 'sophia_stream',
          displayName: 'Sophia',
          profileImage: 'https://i.pravatar.cc/150?img=1',
          followers: 15000,
          isLive: true,
          isVerified: true,
        ),
        User(
          id: '2',
          username: 'jackson_live',
          displayName: 'Jackson',
          profileImage: 'https://i.pravatar.cc/150?img=2',
          followers: 8500,
          isLive: true,
        ),
        User(
          id: '3',
          username: 'emma_dance',
          displayName: 'Emma',
          profileImage: 'https://i.pravatar.cc/150?img=3',
          followers: 22000,
          isLive: true,
          isVerified: true,
        ),
        User(
          id: '4',
          username: 'alex_music',
          displayName: 'Alex',
          profileImage: 'https://i.pravatar.cc/150?img=4',
          followers: 5800,
          isLive: true,
        ),
      ];

      // Create mock livestreams
      final now = DateTime.now();
      _livestreams.addAll([
        Livestream(
          id: '1',
          host: users[0],
          title: 'Dance Workshop 💃',
          thumbnailUrl: 'https://picsum.photos/400/300?random=1',
          startTime: now.subtract(const Duration(minutes: 35)),
          viewerCount: 1258,
          tags: ['dance', 'workshop', 'fitness'],
        ),
        Livestream(
          id: '2',
          host: users[1],
          title: 'Guitar Session 🎸',
          thumbnailUrl: 'https://picsum.photos/400/300?random=2',
          startTime: now.subtract(const Duration(minutes: 15)),
          viewerCount: 856,
          tags: ['music', 'guitar', 'acoustic'],
        ),
        Livestream(
          id: '3',
          host: users[2],
          title: 'Q&A with fans ✨',
          thumbnailUrl: 'https://picsum.photos/400/300?random=3',
          startTime: now.subtract(const Duration(minutes: 45)),
          viewerCount: 2547,
          tags: ['qa', 'fans', 'chat'],
        ),
        Livestream(
          id: '4',
          host: users[3],
          title: 'Gaming night 🎮',
          thumbnailUrl: 'https://picsum.photos/400/300?random=4',
          startTime: now.subtract(const Duration(minutes: 5)),
          viewerCount: 632,
          tags: ['gaming', 'fun', 'competition'],
        ),
      ]);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load livestreams: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Start a new livestream
  Future<Livestream?> startLivestream(
    User host,
    String title,
    List<String> tags,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      final newLivestream = Livestream(
        id: _generateId(),
        host: host,
        title: title,
        startTime: DateTime.now(),
        viewerCount: 0,
        tags: tags,
      );

      _livestreams.add(newLivestream);
      _activeLivestream = newLivestream;

      _isLoading = false;
      notifyListeners();
      return newLivestream;
    } catch (e) {
      _error = 'Failed to start livestream: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  // End an active livestream
  Future<bool> endLivestream(String livestreamId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Find and update the livestream
      final index = _livestreams.indexWhere(
        (stream) => stream.id == livestreamId,
      );
      if (index != -1) {
        // In a real app, we would update the isActive property
        // Here we're removing it for simplicity
        _livestreams.removeAt(index);
      }

      // Clear active livestream if it's the one being ended
      if (_activeLivestream?.id == livestreamId) {
        _activeLivestream = null;
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to end livestream: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Join a livestream as a viewer
  void joinLivestream(String livestreamId) {
    final livestream = _livestreams.firstWhere(
      (stream) => stream.id == livestreamId,
      orElse: () => throw Exception('Livestream not found'),
    );

    _activeLivestream = livestream;
    notifyListeners();
  }

  // Leave a livestream as a viewer
  void leaveLivestream() {
    _activeLivestream = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
