import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:me_lond/providers/livestream_provider.dart';
import 'package:me_lond/providers/user_provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';

class StartLivestreamScreen extends StatefulWidget {
  const StartLivestreamScreen({super.key});

  @override
  State<StartLivestreamScreen> createState() => _StartLivestreamScreenState();
}

class _StartLivestreamScreenState extends State<StartLivestreamScreen>
    with WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final List<String> _selectedTags = [];
  bool _isLoading = false;
  String? _error;

  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  String? _cameraError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _cameraController?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (_cameraController == null && state != AppLifecycleState.resumed) {
      return;
    }
    if (_cameraController != null &&
        !_cameraController!.value.isInitialized &&
        state != AppLifecycleState.resumed) {
      return;
    }

    switch (state) {
      case AppLifecycleState.resumed:
        if (_cameraController == null && mounted) {
          _initializeCamera();
        }
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        _cameraController?.dispose();
        _cameraController = null;
        if (mounted) {
          setState(() {
            _isCameraInitialized = false;
          });
        }
        break;
      case AppLifecycleState.detached:
        _cameraController?.dispose();
        _cameraController = null;
        break;
      case AppLifecycleState.hidden:
        _cameraController?.dispose();
        _cameraController = null;
        if (mounted) {
          setState(() {
            _isCameraInitialized = false;
          });
        }
        break;
    }
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        setState(() {
          _cameraError = 'No cameras available';
          _isCameraInitialized = false;
        });
        return;
      }
      // Use the first available camera (usually back camera by default, or front if only one)
      // You can add logic to select between front/back if multiple are available
      final firstCamera = _cameras!.firstWhere(
        (camera) =>
            camera.lensDirection ==
            CameraLensDirection.front, // Prefer front camera
        orElse:
            () =>
                _cameras!
                    .first, // Fallback to the first camera if no front camera
      );

      _cameraController = CameraController(
        firstCamera,
        ResolutionPreset.medium,
        enableAudio: true, // Enable audio for livestream
      );

      await _cameraController!.initialize();
      if (!mounted) return;
      setState(() {
        _isCameraInitialized = true;
        _cameraError = null;
      });
    } on CameraException catch (e) {
      if (!mounted) return;
      String errorMessage;
      if (e.code == 'CameraAccessDenied') {
        errorMessage =
            'Camera access was denied. Please enable camera permissions in app settings.';
      } else if (e.code == 'CameraAccessDeniedWithoutPrompt') {
        errorMessage =
            'Camera permission has been denied and you chose not to be asked again. Please enable it in app settings.';
      } else if (e.code == 'CameraAccessRestricted') {
        errorMessage =
            'Camera access is restricted by the system (e.g., parental controls).';
      } else {
        errorMessage = 'Error initializing camera: ${e.description ?? e.code}';
      }
      setState(() {
        _cameraError = errorMessage;
        _isCameraInitialized = false;
      });
      print('Camera Error: ${e.code} ${e.description}');
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _cameraError = 'An unexpected error occurred: $e';
        _isCameraInitialized = false;
      });
      print('Unexpected Camera Init Error: $e');
    }
  }

  void _handleStartLivestream() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      try {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        final livestreamProvider = Provider.of<LivestreamProvider>(
          context,
          listen: false,
        );

        if (userProvider.currentUser == null) {
          throw Exception('You need to be logged in to start a livestream');
        }

        final livestream = await livestreamProvider.startLivestream(
          userProvider.currentUser!,
          _titleController.text,
          _selectedTags,
        );

        if (!mounted) return;

        if (livestream != null) {
          // Toggle user's live status
          userProvider.toggleLiveStatus(true);

          // Navigate to livestream page
          // context.pushReplacement('/livestream/${livestream.id}');
          context.push('/livestream/${livestream.id}');
        } else {
          setState(() {
            _error = 'Failed to start livestream';
            _isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          _error = 'Failed to start livestream: $e';
          _isLoading = false;
        });
      }
    }
  }

  void _toggleTag(String tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else if (_selectedTags.length < 3) {
        _selectedTags.add(tag);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    final availableTags = [
      'Music',
      'Dance',
      'Fitness',
      'Gaming',
      'Chatting',
      'Cooking',
      'Art',
      'Education',
      'Travel',
      'Tech',
    ];

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Text('Start Livestream', style: theme.textTheme.h4),
        backgroundColor: theme.colorScheme.background,
        foregroundColor: theme.colorScheme.foreground,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Camera preview
                AspectRatio(
                  aspectRatio: 9 / 16, // Common portrait aspect ratio for live
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.muted,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: theme.colorScheme.border),
                    ),
                    child:
                        _cameraError != null
                            ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      color: theme.colorScheme.destructive,
                                      size: 40,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _cameraError!,
                                      style: theme.textTheme.p.copyWith(
                                        color: theme.colorScheme.destructive,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8),
                                    ShadButton.outline(
                                      child: const Text('Retry Camera'),
                                      onPressed: _initializeCamera,
                                    ),
                                  ],
                                ),
                              ),
                            )
                            : _isCameraInitialized &&
                                _cameraController != null &&
                                _cameraController!.value.isInitialized
                            ? ClipRRect(
                              borderRadius: BorderRadius.circular(
                                11,
                              ), // slightly less than container to hide border issues
                              child: CameraPreview(_cameraController!),
                            )
                            : Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const CircularProgressIndicator(),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Initializing Camera...',
                                    style: theme.textTheme.p,
                                  ),
                                ],
                              ),
                            ),
                  ),
                ),
                // Button to flip camera if multiple cameras are available and controller is initialized
                if (_isCameraInitialized &&
                    _cameras != null &&
                    _cameras!.length > 1)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ShadButton.outline(
                      icon: const Icon(Icons.flip_camera_ios_outlined),
                      child: const Text('Switch Camera'),
                      onPressed: _switchCamera,
                    ),
                  ),

                const SizedBox(height: 24),

                // Title input
                Text(
                  'Livestream Title',
                  style: theme.textTheme.large.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'Enter a title for your livestream',
                    hintStyle: TextStyle(color: theme.colorScheme.muted),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: theme.colorScheme.border),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.card,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // Tags selection
                Text(
                  'Tags (select up to 3)',
                  style: theme.textTheme.large.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      availableTags.map((tag) {
                        final isSelected = _selectedTags.contains(tag);
                        return GestureDetector(
                          onTap: () {
                            if (isSelected || _selectedTags.length < 3) {
                              _toggleTag(tag);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.card,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color:
                                    isSelected
                                        ? theme.colorScheme.primary
                                        : theme.colorScheme.border,
                              ),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                color:
                                    isSelected
                                        ? theme.colorScheme.primaryForeground
                                        : theme.colorScheme.foreground,
                                fontWeight:
                                    isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),

                if (_error != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    _error!,
                    style: TextStyle(color: theme.colorScheme.destructive),
                  ),
                ],

                const SizedBox(height: 24),

                // Start button
                ShadButton(
                  onPressed:
                      _isLoading ||
                              !_isCameraInitialized ||
                              _cameraError != null
                          ? null
                          : _handleStartLivestream,
                  child:
                      _isLoading
                          ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: theme.colorScheme.primaryForeground,
                            ),
                          )
                          : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.live_tv),
                              const SizedBox(width: 8),
                              const Text('Go Live!'),
                            ],
                          ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _switchCamera() async {
    if (_cameras == null || _cameras!.length < 2 || _cameraController == null)
      return;

    setState(() {
      _isCameraInitialized = false; // Show loading indicator
    });

    // Get current camera description
    final currentCameraDescription = _cameraController!.description;
    // Find the index of the current camera
    int currentCameraIndex = _cameras!.indexWhere(
      (camera) => camera.name == currentCameraDescription.name,
    );

    // Get the next camera
    final nextCameraDescription =
        _cameras![(currentCameraIndex + 1) % _cameras!.length];

    // Dispose the old controller
    await _cameraController!.dispose();

    // Initialize the new controller
    _cameraController = CameraController(
      nextCameraDescription,
      ResolutionPreset.medium,
      enableAudio: true,
    );

    try {
      await _cameraController!.initialize();
      if (!mounted) return;
      setState(() {
        _isCameraInitialized = true;
        _cameraError = null;
      });
    } on CameraException catch (e) {
      if (!mounted) return;
      setState(() {
        _cameraError = 'Error switching camera: ${e.description}';
        _isCameraInitialized = false;
        _cameraController = null; // Clear controller on error
      });
      print('Camera Switch Error: ${e.code} ${e.description}');
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _cameraError = 'An unexpected error occurred while switching: $e';
        _isCameraInitialized = false;
        _cameraController = null; // Clear controller on error
      });
      print('Unexpected Camera Switch Error: $e');
    }
  }
}
