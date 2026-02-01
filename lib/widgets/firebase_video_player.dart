import 'package:LudiArtech/services/firebase_video_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class FirebaseVideoPlayer extends StatefulWidget {
  final String path;
  final Color placeholderColor;

  const FirebaseVideoPlayer({
    super.key,
    required this.path,
    required this.placeholderColor,
  });

  @override
  State<FirebaseVideoPlayer> createState() => _FirebaseVideoPlayerState();
}

class _FirebaseVideoPlayerState extends State<FirebaseVideoPlayer> {
  VideoPlayerController? _controller;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadVideo();
  }

  Future<void> _loadVideo() async {
    final url = await FirebaseVideoService.instance.getUrl(widget.path);
    if (url.isEmpty) {
      setState(() => _loading = false);
      return;
    }

    _controller = VideoPlayerController.networkUrl(Uri.parse(url));
    await _controller!.initialize();
    _controller!
      ..setLooping(false)
      ..setVolume(1.0)
      ..setPlaybackSpeed(1.0);

    setState(() => _loading = false);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlay() {
    if (_controller == null) return;
    setState(() {
      _controller!.value.isPlaying
          ? _controller!.pause()
          : _controller!.play();
    });
  }

  void _enterFullScreen() {
    if (_controller == null) return;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FullScreenVideo(
          controller: _controller!,
          onExit: () {
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.portraitUp,
              DeviceOrientation.portraitDown,
            ]);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Container(
        color: widget.placeholderColor,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_controller == null) {
      return Container(
        color: widget.placeholderColor,
        child: const Center(
          child: Icon(Icons.videocam_off, color: Colors.white, size: 48),
        ),
      );
    }

    return GestureDetector(
      onTap: _togglePlay,
      onDoubleTap: _enterFullScreen,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: VideoPlayer(_controller!),
          ),
          if (!_controller!.value.isPlaying)
            const Icon(Icons.play_circle, color: Colors.white, size: 55),
        ],
      ),
    );
  }
}

class FullScreenVideo extends StatefulWidget {
  final VideoPlayerController controller;
  final VoidCallback onExit;

  const FullScreenVideo({
    super.key,
    required this.controller,
    required this.onExit,
  });

  @override
  State<FullScreenVideo> createState() => _FullScreenVideoState();
}

class _FullScreenVideoState extends State<FullScreenVideo> {
  double _volume = 1.0;
  double _playbackSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    _volume = widget.controller.value.volume;
    _playbackSpeed = widget.controller.value.playbackSpeed;
  }

  void _togglePlay() {
    setState(() {
      widget.controller.value.isPlaying
          ? widget.controller.pause()
          : widget.controller.play();
    });
  }

  void _changeVolume(double value) {
    setState(() {
      _volume = value;
      widget.controller.setVolume(_volume);
    });
  }

  void _changeSpeed(double value) {
    setState(() {
      _playbackSpeed = value;
      widget.controller.setPlaybackSpeed(_playbackSpeed);
    });
  }

  void _seekVideo(Duration position) {
    widget.controller.seekTo(position);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: widget.controller.value.aspectRatio,
                child: VideoPlayer(widget.controller),
              ),
            ),
            Positioned(
              top: 20,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: widget.onExit,
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                children: [
                  VideoProgressIndicator(
                    widget.controller,
                    allowScrubbing: true,
                    colors: const VideoProgressColors(
                      playedColor: Colors.purpleAccent,
                      bufferedColor: Colors.grey,
                      backgroundColor: Colors.black26,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.volume_down, color: Colors.white),
                      Expanded(
                        child: Slider(
                          value: _volume,
                          min: 0,
                          max: 1,
                          activeColor: Colors.purpleAccent,
                          onChanged: _changeVolume,
                        ),
                      ),
                      const Icon(Icons.volume_up, color: Colors.white),
                      const SizedBox(width: 16),
                      Text(
                        "x${_playbackSpeed.toStringAsFixed(1)}",
                        style: const TextStyle(color: Colors.white),
                      ),
                      Slider(
                        value: _playbackSpeed,
                        min: 0.5,
                        max: 2.0,
                        divisions: 6,
                        activeColor: Colors.purpleAccent,
                        onChanged: _changeSpeed,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: _togglePlay,
              child: Center(
                child: widget.controller.value.isPlaying
                    ? const SizedBox.shrink()
                    : const Icon(Icons.play_circle, color: Colors.white, size: 80),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
