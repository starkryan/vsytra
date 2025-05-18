import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:me_lond/providers/user_provider.dart';
import 'package:me_lond/screens/home/home_feed_screen.dart';
import 'package:me_lond/screens/login_screen.dart';
import 'package:me_lond/screens/livestream/viewer_screen.dart';
import 'package:me_lond/screens/start_live/start_livestream_screen.dart';
import 'package:me_lond/screens/videocall/video_call_screen.dart';
import 'package:me_lond/screens/chat/chat_screen.dart';
import 'package:me_lond/screens/search/search_screen.dart';
import 'package:me_lond/screens/profile/profile_screen.dart';
import 'package:provider/provider.dart';

class AppRouter {
  static GoRouter getRouter(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return GoRouter(
      initialLocation: '/',
      redirect: (context, state) {
        final isLoggedIn = userProvider.isLoggedIn;
        final isLoginRoute = state.matchedLocation == '/login';

        // If not logged in and not on login page, redirect to login
        if (!isLoggedIn && !isLoginRoute) {
          return '/login';
        }

        // If logged in and on login page, redirect to home
        if (isLoggedIn && isLoginRoute) {
          return '/';
        }

        // No redirection needed
        return null;
      },
      routes: [
        GoRoute(path: '/', builder: (context, state) => const HomeFeedScreen()),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/livestream/:id',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return ViewerScreen(livestreamId: id);
          },
        ),
        GoRoute(
          path: '/start-livestream',
          builder: (context, state) => const StartLivestreamScreen(),
        ),
        GoRoute(
          path: '/video-call/:userId',
          builder: (context, state) {
            final userId = state.pathParameters['userId']!;
            return VideoCallScreen(userId: userId);
          },
        ),
        GoRoute(
          path: '/chat/:userId',
          builder: (context, state) {
            final userId = state.pathParameters['userId']!;
            return ChatScreen(userId: userId);
          },
        ),
        GoRoute(
          path: '/search',
          builder: (context, state) => const SearchScreen(),
        ),
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const HomeFeedScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
      errorBuilder:
          (context, state) => Scaffold(
            body: Center(child: Text('Error: Page not found for ${state.uri}')),
          ),
    );
  }
}
