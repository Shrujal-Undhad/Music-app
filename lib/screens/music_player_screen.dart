import 'package:flutter/material.dart';
import 'package:musicapp/controllers/myaudioplayer.dart';
import 'package:provider/provider.dart';
import '../models/song.dart';

class MusicPlayerScreen extends StatelessWidget {
  final Song song;

  MusicPlayerScreen({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {},
        child: Stack(
          children: [
            _buildBackgroundImage(song.albumArtPath),
            _buildGradientOverlay(),
            Positioned.fill(
              child: SingleChildScrollView(
                child: _buildContent(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundImage(String imageUrl) {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }

  Widget _buildGradientOverlay() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black87, Colors.transparent],
        ),
      ),
      width: double.infinity,
      height: double.infinity,
    );
  }

  Widget _buildContent(BuildContext context) {
    return Consumer<MyAudioPlayerProvider>(
      builder: (context, audioPlayerState, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40.0),
            _buildAppBar(context),
            const SizedBox(height: 40.0),
            _buildSongInfo(),
            const SizedBox(height: 16.0),
            _buildProgressBar(audioPlayerState),
            const SizedBox(height: 16.0),
            _buildPlayerControls(audioPlayerState),
            const SizedBox(height: 16.0),
            _buildActionButtons(context, audioPlayerState),
            const SizedBox(height: 16.0),
            _buildQueueButton(context),
            const SizedBox(height: 40.0),
          ],
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          Text(
            song.name,
            style: const TextStyle(fontSize: 20.0, color: Colors.white),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSongInfo() {
    return Column(
      children: [
        Text(
          song.name,
          style: const TextStyle(fontSize: 24.0, color: Colors.white),
        ),
        const SizedBox(height: 8.0),
        Text(
          song.artist,
          style: const TextStyle(fontSize: 16.0, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildProgressBar(MyAudioPlayerProvider audioPlayerState) {
    final positionMilliseconds = audioPlayerState.position.inMilliseconds;
    final durationMilliseconds = audioPlayerState.duration.inMilliseconds;

    final double sliderValue = durationMilliseconds > 0
        ? positionMilliseconds / durationMilliseconds
        : 0.0;

    return Column(
      children: [
        Slider(
          onChanged: (value) {
            final newPosition = value * durationMilliseconds;
            audioPlayerState.seek(Duration(milliseconds: newPosition.round()));
          },
          value: sliderValue.clamp(0.0, 1.0),
          activeColor: Colors.white,
          inactiveColor: Colors.grey,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(audioPlayerState.position),
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                _formatDuration(audioPlayerState.duration),
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerControls(MyAudioPlayerProvider audioPlayerState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ControlButton(
          icon: Icons.repeat,
          onPressed: () {
            audioPlayerState.toggleRepeatMode();
          },
        ),
        ControlButton(
          icon: Icons.skip_previous,
          onPressed: () {
            audioPlayerState.skipToPrevious();
          },
        ),
        FloatingActionButton(
          onPressed: () {
            audioPlayerState.playPause();
          },
          child: Icon(
            audioPlayerState.isPlaying ? Icons.pause : Icons.play_arrow,
            color: Colors.white,
          ),
        ),
        ControlButton(
          icon: Icons.skip_next,
          onPressed: () {
            audioPlayerState.skipToNext();
          },
        ),
        ControlButton(
          icon: Icons.shuffle,
          onPressed: () {
            audioPlayerState.toggleShuffleMode();
          },
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, MyAudioPlayerProvider audioPlayerState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(
            song.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: Colors.white,
          ),
          onPressed: () {
            audioPlayerState.toggleFavorite(song);
          },
        ),
        IconButton(
          icon: const Icon(Icons.queue_music, color: Colors.white),
          onPressed: () {
            _navigateToQueueScreen(context);
          },
        ),
      ],
    );
  }

  Widget _buildQueueButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        _navigateToQueueScreen(context);
      },
      child: const Icon(Icons.queue_music, color: Colors.white),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _navigateToQueueScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const QueuePage(),
      ),
    );
  }
}

class ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const ControlButton({Key? key, required this.icon, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: Colors.white),
      onPressed: onPressed,
    );
  }
}

class QueuePage extends StatelessWidget {
  const QueuePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Queue'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'This is the queue page.',
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'You can view and manage your play queue here.',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
