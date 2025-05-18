import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:me_lond/models/livestream.dart';
import 'package:me_lond/models/user.dart';
import 'package:me_lond/widgets/live_stream_card.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  String _searchQuery = '';

  // Mock data
  List<User> _users = [];
  List<Livestream> _livestreams = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });

    if (_searchQuery.isNotEmpty) {
      _performSearch(_searchQuery);
    } else {
      setState(() {
        _users.clear();
        _livestreams.clear();
      });
    }
  }

  Future<void> _performSearch(String query) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 500));

      if (query.isNotEmpty) {
        // Mock search results
        final mockUsers = [
          User(
            id: '1',
            username: 'sophia_stream',
            displayName: 'Sophia',
            profileImage: 'https://i.pravatar.cc/150?img=1',
            followers: 15000,
            isVerified: true,
          ),
          User(
            id: '2',
            username: 'jackson_live',
            displayName: 'Jackson',
            profileImage: 'https://i.pravatar.cc/150?img=2',
            followers: 8500,
          ),
          User(
            id: '3',
            username: 'emma_dance',
            displayName: 'Emma',
            profileImage: 'https://i.pravatar.cc/150?img=3',
            followers: 22000,
            isVerified: true,
          ),
        ];

        final mockLivestreams = [
          Livestream(
            id: '1',
            host: mockUsers[0],
            title: 'Dance Workshop 💃',
            thumbnailUrl: 'https://picsum.photos/400/300?random=1',
            startTime: DateTime.now().subtract(const Duration(minutes: 35)),
            viewerCount: 1258,
            tags: ['dance', 'workshop', 'fitness'],
          ),
          Livestream(
            id: '2',
            host: mockUsers[1],
            title: 'Guitar Session 🎸',
            thumbnailUrl: 'https://picsum.photos/400/300?random=2',
            startTime: DateTime.now().subtract(const Duration(minutes: 15)),
            viewerCount: 856,
            tags: ['music', 'guitar', 'acoustic'],
          ),
        ];

        setState(() {
          _users =
              mockUsers
                  .where(
                    (user) =>
                        user.username.toLowerCase().contains(
                          query.toLowerCase(),
                        ) ||
                        user.displayName.toLowerCase().contains(
                          query.toLowerCase(),
                        ),
                  )
                  .toList();

          _livestreams =
              mockLivestreams
                  .where(
                    (livestream) =>
                        livestream.title.toLowerCase().contains(
                          query.toLowerCase(),
                        ) ||
                        livestream.tags.any(
                          (tag) =>
                              tag.toLowerCase().contains(query.toLowerCase()),
                        ),
                  )
                  .toList();
        });
      } else {
        setState(() {
          _users.clear();
          _livestreams.clear();
        });
      }
    } catch (e) {
      // Handle errors
      debugPrint('Search error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Text('Search', style: theme.textTheme.h4),
        backgroundColor: theme.colorScheme.background,
        foregroundColor: theme.colorScheme.foreground,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search users, streams, tags...',
                    hintStyle: TextStyle(color: theme.colorScheme.muted),
                    prefixIcon: Icon(
                      Icons.search,
                      color: theme.colorScheme.muted,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: theme.colorScheme.border),
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.card,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              TabBar(
                controller: _tabController,
                tabs: const [Tab(text: 'Users'), Tab(text: 'Livestreams')],
                labelColor: theme.colorScheme.primary,
                unselectedLabelColor: theme.colorScheme.muted,
                indicatorColor: theme.colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
                controller: _tabController,
                children: [
                  // Users tab
                  _users.isEmpty
                      ? _buildEmptyState(
                        'No users found',
                        'Try searching with a different term',
                        Icons.person_search,
                      )
                      : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _users.length,
                        itemBuilder: (context, index) {
                          final user = _users[index];
                          return _buildUserListItem(context, user);
                        },
                      ),

                  // Livestreams tab
                  _livestreams.isEmpty
                      ? _buildEmptyState(
                        'No livestreams found',
                        'Try searching with a different term',
                        Icons.live_tv,
                      )
                      : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                        itemCount: _livestreams.length,
                        itemBuilder: (context, index) {
                          return LiveStreamCard(
                            livestream: _livestreams[index],
                          );
                        },
                      ),
                ],
              ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle, IconData icon) {
    final theme = ShadTheme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 64, color: theme.colorScheme.muted),
          const SizedBox(height: 16),
          Text(title, style: theme.textTheme.h4),
          const SizedBox(height: 8),
          Text(subtitle, style: theme.textTheme.muted),
        ],
      ),
    );
  }

  Widget _buildUserListItem(BuildContext context, User user) {
    final theme = ShadTheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ShadCard(
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage:
                user.profileImage != null
                    ? NetworkImage(user.profileImage!)
                    : null,
            radius: 24,
            child:
                user.profileImage == null
                    ? Text(
                      user.displayName.substring(0, 1),
                      style: const TextStyle(fontSize: 18),
                    )
                    : null,
          ),
          title: Row(
            children: [
              Text(
                user.displayName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              if (user.isVerified)
                Container(
                  margin: const EdgeInsets.only(left: 4),
                  child: Icon(
                    Icons.verified,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                ),
            ],
          ),
          subtitle: Text('@${user.username}'),
          trailing: ShadButton.outline(
            onPressed: () {
              // Follow user
            },
            child: const Text('Follow'),
          ),
          onTap: () {
            // Navigate to user profile or chat
            context.push('/chat/${user.id}');
          },
        ),
      ),
    );
  }
}
