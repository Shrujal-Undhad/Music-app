import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../models/song.dart';
import '../controllers/song_controller.dart';

class MyAudioPlayerProvider with ChangeNotifier {
  final AudioPlayer justAudioPlayer = AudioPlayer();
  final SongProvider _songProvider;

  MyAudioPlayerProvider(this._songProvider) {
    _songProvider.addListener(_onSongsChanged);
    justAudioPlayer.positionStream.listen((pos) {
      _position = pos;
      notifyListeners();
    });
    justAudioPlayer.durationStream.listen((dur) {
      _duration = dur ?? Duration.zero;
      notifyListeners();
    });
  }

  LoopMode _repeatMode = LoopMode.off;
  List<Song> _queue = [];
  Song? _currentSong;
  bool _isPlaying = false;
  bool _isShuffle = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  bool get isPlaying => _isPlaying;
  Song? get currentSong => _currentSong;
  bool get isShuffle => _isShuffle;
  List<Song> get queue => _queue;
  Duration get position => _position;
  Duration get duration => _duration;
  LoopMode get repeatMode => _repeatMode;

  void _onSongsChanged() {
    if (_currentSong == null || !_songProvider.songs.contains(_currentSong)) {
      justAudioPlayer.stop();
      _isPlaying = false;
      _currentSong = null;
      notifyListeners();
    }
  }

  Future<void> playSong(Song song) async {
    try {
      await justAudioPlayer.setUrl(song.link);
      await justAudioPlayer.play();
      _currentSong = song;
      _isPlaying = true;
      notifyListeners();
    } catch (e) {
      print('Error playing song: $e');
    }
  }

  void playPause() {
    if (_isPlaying) {
      justAudioPlayer.pause();
      _isPlaying = false;
    } else {
      if (_currentSong != null) {
        justAudioPlayer.play();
        _isPlaying = true;
      }
    }
    notifyListeners();
  }

  void skipToNext() {
    if (_currentSong != null) {
      final currentIndex = _queue.indexOf(_currentSong!);
      if (_isShuffle) {
        final nextIndex = (currentIndex + 1) % _queue.length;
        playSong(_queue[nextIndex]);
      } else {
        final nextIndex = currentIndex < _queue.length - 1 ? currentIndex + 1 : 0;
        playSong(_queue[nextIndex]);
      }
    }
  }

  void skipToPrevious() {
    if (_currentSong != null) {
      final currentIndex = _queue.indexOf(_currentSong!);
      if (_isShuffle) {
        final prevIndex = (currentIndex - 1 + _queue.length) % _queue.length;
        playSong(_queue[prevIndex]);
      } else {
        final prevIndex = currentIndex > 0 ? currentIndex - 1 : _queue.length - 1;
        playSong(_queue[prevIndex]);
      }
    }
  }

  void addToQueue(Song song) {
    _queue.add(song);
    notifyListeners();
  }

  void removeFromQueue(Song song) {
    _queue.remove(song);
    notifyListeners();
  }

  void seek(Duration position) {
    justAudioPlayer.seek(position);
  }

  void toggleRepeatMode() {
    switch (_repeatMode) {
      case LoopMode.off:
        _repeatMode = LoopMode.one;
        break;
      case LoopMode.one:
        _repeatMode = LoopMode.all;
        break;
      case LoopMode.all:
        _repeatMode = LoopMode.off;
        break;
    }
    notifyListeners();
  }

  void toggleShuffleMode() {
    _isShuffle = !_isShuffle;
    notifyListeners();
  }

  void toggleFavorite(Song song) {
    _songProvider.toggleFavorite(song);
  }

  @override
  void dispose() {
    justAudioPlayer.dispose();
    _songProvider.removeListener(_onSongsChanged);
    super.dispose();
  }
}
