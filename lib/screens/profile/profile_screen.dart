import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:me_lond/providers/user_provider.dart'; // Assuming you have a UserProvider
// import 'package:me_lond/models/user.dart'; // And a User model

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    // final userProvider = Provider.of<UserProvider>(context);
    // final User? currentUser = userProvider.currentUser; // Placeholder for actual user data

    // Placeholder user data for UI design
    const String placeholderImageUrl =
        'https://avatars.githubusercontent.com/u/1234567?v=4';
    const String placeholderDisplayName = 'Neo Lond';
    const String placeholderUsername = '@neo_lond';
    const int placeholderFollowers = 1250;
    const int placeholderFollowing = 300;
    const int placeholderStreams = 42;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: theme.textTheme.h4),
        backgroundColor: theme.colorScheme.background,
        elevation: 0,
        automaticallyImplyLeading: true, // Shows back button if applicable
      ),
      backgroundColor: theme.colorScheme.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Row(
              children: [
                SizedBox(
                  width: 80, // Control avatar size
                  height: 80,
                  child: ShadAvatar(
                    placeholderImageUrl, // Image URL
                    // alt: placeholderDisplayName, // Removed alt
                    // radius: 40, // Removed radius, size controlled by SizedBox
                    placeholder: Text(
                      placeholderDisplayName.isNotEmpty
                          ? placeholderDisplayName.substring(0, 1)
                          : 'U',
                      style: theme.textTheme.h4.copyWith(
                        color: theme.colorScheme.primaryForeground,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(placeholderDisplayName, style: theme.textTheme.h2),
                      Text(placeholderUsername, style: theme.textTheme.muted),
                    ],
                  ),
                ),
                ShadButton.outline(
                  // text: 'Edit Profile', // Changed to child
                  child: const Text('Edit Profile'),
                  onPressed: () {
                    // TODO: Navigate to edit profile screen
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn(
                  'Followers',
                  placeholderFollowers.toString(),
                  theme,
                ),
                _buildStatColumn(
                  'Following',
                  placeholderFollowing.toString(),
                  theme,
                ),
                _buildStatColumn(
                  'Streams',
                  placeholderStreams.toString(),
                  theme,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Divider(color: theme.colorScheme.border),
            const SizedBox(height: 24),

            // Tabs (e.g., My Streams, Liked) - Placeholder for now
            Text('My Streams', style: theme.textTheme.h3),
            const SizedBox(height: 16),
            // Placeholder for a list of user's streams/content
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3, // Placeholder count
              itemBuilder: (context, index) {
                // return Padding( // Temporarily remove padding
                //   padding: const EdgeInsets.only(bottom: 16),
                return ShadCard(
                  child: Text(
                    'Item ${index + 1}',
                    style: theme.textTheme.p,
                  ), // Most minimal content
                );
                // );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, ShadThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: theme.textTheme.h3.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: theme.textTheme.muted),
      ],
    );
  }
}
