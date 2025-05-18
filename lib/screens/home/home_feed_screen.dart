import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:me_lond/providers/livestream_provider.dart';
import 'package:me_lond/providers/user_provider.dart';
import 'package:me_lond/widgets/live_stream_card.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:provider/provider.dart';

class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Load livestreams when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadLivestreams();
    });
  }

  Future<void> _loadLivestreams() async {
    final livestreamProvider = Provider.of<LivestreamProvider>(
      context,
      listen: false,
    );
    await livestreamProvider.loadLivestreams();

    setState(() {
      _isLoading = false;
    });
  }

  void _navigateToSearch() {
    context.push('/search');
  }

  void _startLivestream() {
    context.push('/start-livestream');
  }

  void _handleNavTap(int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/dashboard');
        break;
      case 2:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final userProvider = Provider.of<UserProvider>(context);
    final livestreamProvider = Provider.of<LivestreamProvider>(context);
    final livestreams = livestreamProvider.livestreams;

    // Determine selectedIndex from current route
    final String currentLocation = GoRouterState.of(context).uri.toString();
    int selectedIndex = 0;
    if (currentLocation == '/dashboard') {
      selectedIndex = 1;
    } else if (currentLocation == '/profile') {
      selectedIndex = 2;
    } else if (currentLocation == '/') {
      selectedIndex = 0;
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage:
                  userProvider.currentUser?.profileImage != null
                      ? NetworkImage(userProvider.currentUser!.profileImage!)
                      : null,
              radius: 16,
              child:
                  userProvider.currentUser?.profileImage == null
                      ? Text(
                        userProvider.currentUser?.displayName.substring(0, 1) ??
                            'U',
                      )
                      : null,
            ),
            const SizedBox(width: 10),
            Text(
              'MeLond',
              style: theme.textTheme.h4.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _navigateToSearch,
          ),
          IconButton(
            icon: const Icon(Icons.message),
            onPressed: () {
              // Navigate to messages
            },
          ),
        ],
        backgroundColor: theme.colorScheme.background,
        foregroundColor: theme.colorScheme.foreground,
        elevation: 0,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: _loadLivestreams,
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      sliver: SliverToBoxAdapter(
                        child: Text(
                          'Trending Lives',
                          style: theme.textTheme.h3,
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return LiveStreamCard(livestream: livestreams[index]);
                        }, childCount: livestreams.length),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 16)),
                  ],
                ),
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startLivestream,
        backgroundColor: theme.colorScheme.primary,
        child: const Icon(Icons.video_call),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        backgroundColor: theme.colorScheme.background,
        indicatorColor: theme.colorScheme.primary.withValues(alpha: 0.2),
        onDestinationSelected: _handleNavTap,
        destinations: [
          NavigationDestination(
            icon: Icon(
              Icons.home,
              color:
                  selectedIndex == 0
                      ? theme.colorScheme.primary
                      : theme.colorScheme.foreground,
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.trending_up,
              color:
                  selectedIndex == 1
                      ? theme.colorScheme.primary
                      : theme.colorScheme.foreground,
            ),
            label: 'Top',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.person,
              color:
                  selectedIndex == 2
                      ? theme.colorScheme.primary
                      : theme.colorScheme.foreground,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
