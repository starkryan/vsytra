import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:me_lond/models/message.dart';
import 'package:me_lond/models/user.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ChatScreen extends StatefulWidget {
  final String userId;

  const ChatScreen({super.key, required this.userId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Message> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = true;
  User? _chatPartner;

  @override
  void initState() {
    super.initState();
    _loadChatData();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadChatData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 800));

      // Mock chat partner
      final chatPartner = User(
        id: widget.userId,
        username: 'chat_user',
        displayName: 'Chat User',
        profileImage:
            'https://i.pravatar.cc/150?img=${int.parse(widget.userId)}',
        followers: 500,
        isVerified: widget.userId == '1',
      );

      // Mock messages
      final currentUser = User(
        id: 'current_user',
        username: 'current_user',
        displayName: 'Me',
        profileImage: 'https://i.pravatar.cc/150?img=10',
      );

      final mockMessages = [
        Message.text(
          id: '1',
          sender: chatPartner,
          text: 'Hi there! How are you?',
          timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        ),
        Message.text(
          id: '2',
          sender: currentUser,
          text: 'I\'m good! Thanks for asking. How about you?',
          timestamp: DateTime.now().subtract(const Duration(minutes: 14)),
        ),
        Message.text(
          id: '3',
          sender: chatPartner,
          text: 'Doing well! Are you going to be streaming today?',
          timestamp: DateTime.now().subtract(const Duration(minutes: 12)),
        ),
        Message.text(
          id: '4',
          sender: currentUser,
          text: 'Yes, I\'m planning to go live in about an hour!',
          timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
        ),
        Message.text(
          id: '5',
          sender: chatPartner,
          text:
              'Great! I\'ll try to catch your stream. What will you be doing?',
          timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
        ),
      ];

      setState(() {
        _chatPartner = chatPartner;
        _messages.addAll(mockMessages);
        _isLoading = false;
      });

      // Scroll to bottom after layout is complete
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    } catch (e) {
      debugPrint('Error loading chat data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final currentUser = User(
      id: 'current_user',
      username: 'current_user',
      displayName: 'Me',
      profileImage: 'https://i.pravatar.cc/150?img=10',
    );

    final newMessage = Message.text(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sender: currentUser,
      text: _messageController.text,
    );

    setState(() {
      _messages.add(newMessage);
      _messageController.clear();
    });

    // Scroll to bottom after layout is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    if (_isLoading) {
      return Scaffold(
        backgroundColor: theme.colorScheme.background,
        appBar: AppBar(
          backgroundColor: theme.colorScheme.background,
          foregroundColor: theme.colorScheme.foreground,
          elevation: 0,
          title: const Text('Loading...'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.background,
        foregroundColor: theme.colorScheme.foreground,
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage:
                  _chatPartner?.profileImage != null
                      ? NetworkImage(_chatPartner!.profileImage!)
                      : null,
              radius: 18,
              child:
                  _chatPartner?.profileImage == null
                      ? Text(_chatPartner?.displayName.substring(0, 1) ?? '?')
                      : null,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      _chatPartner?.displayName ?? 'User',
                      style: theme.textTheme.p.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_chatPartner?.isVerified ?? false)
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Icon(
                          Icons.verified,
                          size: 14,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                  ],
                ),
                Text(
                  '@${_chatPartner?.username ?? 'user'}',
                  style: theme.textTheme.small,
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.video_call),
            onPressed: () {
              // Navigate to video call screen
              // Navigator.pushNamed(
              //   context,
              //   '/video-call/${_chatPartner?.id ?? 'unknown'}',
              // );
              context.push('/video-call/${_chatPartner?.id ?? 'unknown'}');
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Show options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child:
                _messages.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 64,
                            color: theme.colorScheme.muted,
                          ),
                          const SizedBox(height: 16),
                          Text('No messages yet', style: theme.textTheme.h4),
                          const SizedBox(height: 8),
                          Text(
                            'Start a conversation!',
                            style: theme.textTheme.muted,
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        final isCurrentUser =
                            message.sender.id == 'current_user';

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            mainAxisAlignment:
                                isCurrentUser
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!isCurrentUser) ...[
                                CircleAvatar(
                                  backgroundImage:
                                      message.sender.profileImage != null
                                          ? NetworkImage(
                                            message.sender.profileImage!,
                                          )
                                          : null,
                                  radius: 16,
                                  child:
                                      message.sender.profileImage == null
                                          ? Text(
                                            message.sender.displayName
                                                .substring(0, 1),
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          )
                                          : null,
                                ),
                                const SizedBox(width: 8),
                              ],
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.7,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color:
                                      isCurrentUser
                                          ? theme.colorScheme.primary
                                          : theme.colorScheme.card,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.1,
                                      ),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      message.text ?? '',
                                      style: TextStyle(
                                        color:
                                            isCurrentUser
                                                ? theme
                                                    .colorScheme
                                                    .primaryForeground
                                                : theme.colorScheme.foreground,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _formatTime(message.timestamp),
                                      style: TextStyle(
                                        fontSize: 10,
                                        color:
                                            isCurrentUser
                                                ? theme
                                                    .colorScheme
                                                    .primaryForeground
                                                    .withValues(alpha: 0.8)
                                                : theme.colorScheme.muted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isCurrentUser) const SizedBox(width: 8),
                            ],
                          ),
                        );
                      },
                    ),
          ),

          // Message input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.background,
              border: Border(top: BorderSide(color: theme.colorScheme.border)),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.emoji_emotions_outlined,
                    color: theme.colorScheme.foreground,
                  ),
                  onPressed: () {
                    // Show emoji picker
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: TextStyle(color: theme.colorScheme.muted),
                      filled: true,
                      fillColor: theme.colorScheme.card,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.send,
                      color: theme.colorScheme.primaryForeground,
                    ),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');

    if (date == today) {
      return '$hour:$minute';
    } else if (date == today.subtract(const Duration(days: 1))) {
      return 'Yesterday, $hour:$minute';
    } else {
      return '${dateTime.day}/${dateTime.month}, $hour:$minute';
    }
  }
}
