import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
// import 'package:lucide_icons/lucide_icons.dart';

class VideoCallScreen extends StatefulWidget {
  final String userId;

  const VideoCallScreen({super.key, required this.userId});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  bool _isMicMuted = false;
  bool _isCameraOff = true; // Default camera to off for privacy
  bool _isSpeakerOn = true;
  bool _isLocalVideoVisible = true; // To toggle local video preview

  // Placeholder for actual video rendering logic
  Widget _buildVideoFeed(BuildContext context, Color color, String text) {
    final theme = ShadTheme.of(context);
    return Container(
      color: color,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _isCameraOff && text == "Local Video"
                  ? LucideIcons.videoOff
                  : LucideIcons.video,
              size: 48,
              color: theme.colorScheme.mutedForeground.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 8),
            Text(
              _isCameraOff && text == "Local Video" ? "Camera Off" : text,
              style: theme.textTheme.muted.copyWith(
                color: theme.colorScheme.mutedForeground.withValues(alpha: 0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Stack(
        children: [
          // Remote Video Feed (Main Area)
          Positioned.fill(
            child: _buildVideoFeed(
              context,
              theme.colorScheme.card,
              'Remote User ${widget.userId}',
            ),
          ),

          // Local Video Feed (Picture-in-Picture style)
          Positioned(
            top: 80,
            right: 16,
            child: Visibility(
              visible: _isLocalVideoVisible,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isLocalVideoVisible = !_isLocalVideoVisible;
                  });
                },
                child: SizedBox(
                  width: 100,
                  height: 150,
                  child: ClipRRect(
                    borderRadius: theme.radius,
                    child: _buildVideoFeed(
                      context,
                      theme.colorScheme.muted,
                      "Local Video",
                    ),
                  ),
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ShadButton.ghost(
                        icon: const Icon(LucideIcons.arrowLeft, size: 20),
                        onPressed: () => context.pop(),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'User ${widget.userId}',
                            style: theme.textTheme.p.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '00:00',
                            style: theme.textTheme.small.copyWith(
                              color: theme.colorScheme.mutedForeground,
                            ),
                          ),
                        ],
                      ),
                      ShadButton.ghost(
                        icon: const Icon(Icons.more_vert, size: 20),
                        onPressed: () {
                          setState(() {
                            _isSpeakerOn = !_isSpeakerOn;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                _isSpeakerOn ? 'Speaker ON' : 'Speaker OFF',
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  // Bottom Controls
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.popover.withValues(alpha: 0.8),
                      borderRadius: theme.radius,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildControlButton(
                          context: context,
                          icon:
                              _isMicMuted
                                  ? LucideIcons.micOff
                                  : LucideIcons.mic,
                          onPressed: () {
                            setState(() {
                              _isMicMuted = !_isMicMuted;
                            });
                          },
                          tooltip: _isMicMuted ? 'Unmute Mic' : 'Mute Mic',
                        ),
                        _buildControlButton(
                          context: context,
                          icon:
                              _isCameraOff
                                  ? LucideIcons.videoOff
                                  : LucideIcons.video,
                          onPressed: () {
                            setState(() {
                              _isCameraOff = !_isCameraOff;
                            });
                          },
                          tooltip:
                              _isCameraOff
                                  ? 'Turn Camera On'
                                  : 'Turn Camera Off',
                        ),
                        _buildControlButton(
                          context: context,
                          icon:
                              _isLocalVideoVisible
                                  ? LucideIcons.eye
                                  : LucideIcons.eyeOff,
                          onPressed: () {
                            setState(() {
                              _isLocalVideoVisible = !_isLocalVideoVisible;
                            });
                          },
                          tooltip:
                              _isLocalVideoVisible
                                  ? 'Hide My Video'
                                  : 'Show My Video',
                        ),
                        ShadButton.destructive(
                          icon: const Icon(LucideIcons.phoneOff, size: 20),
                          onPressed: () {
                            context.pop();
                          },
                          size: ShadButtonSize.lg,
                          child: const Text("End"),
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

  Widget _buildControlButton({
    required BuildContext context,
    required IconData icon,
    required VoidCallback onPressed,
    String? tooltip,
  }) {
    final theme = ShadTheme.of(context);
    final button = ShadButton.ghost(
      icon: Icon(icon, size: 24, color: theme.colorScheme.foreground),
      onPressed: onPressed,
    );

    if (tooltip != null) {
      return ShadTooltip(builder: (context) => Text(tooltip), child: button);
    }
    return button;
  }
}
