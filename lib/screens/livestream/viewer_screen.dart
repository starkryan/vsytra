import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:me_lond/models/livestream.dart';
import 'package:me_lond/models/user.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ViewerScreen extends StatefulWidget {
  final String livestreamId;

  const ViewerScreen({super.key, required this.livestreamId});

  @override
  State<ViewerScreen> createState() => _ViewerScreenState();
}

class _ViewerScreenState extends State<ViewerScreen> {
  Livestream? _livestream;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadLivestream();
  }

  Future<void> _loadLivestream() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // In a real app, this would make an API call to get the livestream
      // For now, we'll simulate it using the provider

      // Wait a bit to simulate loading
      await Future.delayed(const Duration(milliseconds: 500));

      // For demo, we'll create a mock stream
      final host = User(
        id: '123',
        username: 'emma_dance',
        displayName: 'Emma',
        profileImage: 'https://i.pravatar.cc/300?img=5',
        followers: 15000,
        isLive: true,
        isVerified: true,
      );

      _livestream = Livestream(
        id: widget.livestreamId,
        host: host,
        title: 'Live Dance Session 💃',
        thumbnailUrl: 'https://picsum.photos/800/450?random=1',
        startTime: DateTime.now().subtract(const Duration(minutes: 15)),
        viewerCount: 1258,
        tags: ['dance', 'fitness', 'tutorial'],
      );

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Failed to load livestream: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    if (_isLoading) {
      return Scaffold(
        backgroundColor: theme.colorScheme.background,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null || _livestream == null) {
      return Scaffold(
        backgroundColor: theme.colorScheme.background,
        appBar: AppBar(
          backgroundColor: theme.colorScheme.background,
          foregroundColor: theme.colorScheme.foreground,
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: theme.colorScheme.destructive,
              ),
              const SizedBox(height: 16),
              Text('Failed to load livestream', style: theme.textTheme.h4),
              const SizedBox(height: 8),
              Text(_error ?? 'Unknown error', style: theme.textTheme.muted),
              const SizedBox(height: 24),
              ShadButton(
                onPressed: _loadLivestream,
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Video area
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                // Video placeholder
                SizedBox.expand(
                  child: Image.network(
                    _livestream!.thumbnailUrl ??
                        'https://picsum.photos/800/450',
                    fit: BoxFit.cover,
                  ),
                ),

                // Overlay controls
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              onPressed: () => context.pop(),
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Text(
                                        'LIVE',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.6),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.visibility,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${_livestream!.viewerCount}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const Spacer(),

                        // Host info at bottom of video
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage:
                                  _livestream!.host.profileImage != null
                                      ? NetworkImage(
                                        _livestream!.host.profileImage!,
                                      )
                                      : null,
                              radius: 20,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      _livestream!.host.displayName,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    if (_livestream!.host.isVerified)
                                      Container(
                                        margin: const EdgeInsets.only(left: 4),
                                        child: const Icon(
                                          Icons.verified,
                                          size: 16,
                                          color: Colors.blue,
                                        ),
                                      ),
                                  ],
                                ),
                                Text(
                                  '@${_livestream!.host.username}',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.8),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            OutlinedButton(
                              onPressed: () {
                                // Follow host
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Colors.white),
                              ),
                              child: const Text('Follow'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Chat area
          Expanded(
            flex: 2,
            child: Container(
              color: theme.colorScheme.background,
              child: Column(
                children: [
                  // Stream title bar
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: theme.colorScheme.border,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _livestream!.title,
                                style: theme.textTheme.h4,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Started ${_formatTimeAgo(_livestream!.startTime)}',
                                style: theme.textTheme.small,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.share,
                            color: theme.colorScheme.foreground,
                          ),
                          onPressed: () {
                            // Share livestream
                          },
                        ),
                      ],
                    ),
                  ),

                  // Chat messages - this would be a ListView in a real app
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 48,
                              color: theme.colorScheme.muted,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Chat messages will appear here',
                              style: theme.textTheme.p,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Say hello to join the conversation',
                              style: theme.textTheme.muted,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Chat input
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: theme.colorScheme.border,
                          width: 1,
                        ),
                      ),
                      color: theme.colorScheme.background,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.emoji_emotions_outlined,
                            color: theme.colorScheme.foreground,
                          ),
                          onPressed: () {
                            // Open emoji picker
                          },
                        ),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Send a message...',
                              hintStyle: TextStyle(
                                color: theme.colorScheme.muted,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                            ),
                            style: TextStyle(
                              color: theme.colorScheme.foreground,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.send,
                            color: theme.colorScheme.primary,
                          ),
                          onPressed: () {
                            // Send message
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'just now';
    }
  }
}
