import 'package:flutter/material.dart';
import '../models/song.dart';
import '../services/api_service.dart';

class SongProvider extends ChangeNotifier {
  List<Song> _songs = [];
  List<Song> _recentlyPlayedSongs = [];
  List<Song> _queue = []; // Queue of songs
  List<Song> _playlist = []; // Playlist of songs
  final ApiService _apiService = ApiService();

  List<Song> get songs => _songs;
  List<Song> get recentlyPlayedSongs => _recentlyPlayedSongs;
  List<Song> get queue => _queue;
  List<Song> get playlist => _playlist;

  SongProvider() {
    fetchSongs('rap');
  }

  Future<void> fetchSongs(String query) async {
    try {
      final List<Song> fetchedSongs = await _apiService.searchSongs(query);
      _songs = fetchedSongs;
      notifyListeners();
    } catch (e) {
      print('Error fetching songs: $e');
      // Handle error appropriately, maybe with a snackbar or another notification mechanism
    }
  }

  void toggleFavorite(Song song) {
    song.isFavorite = !song.isFavorite;
    notifyListeners();
  }

  void addSong(Song song) {
    _recentlyPlayedSongs.add(song);
    if (_recentlyPlayedSongs.length > 50) {
      _recentlyPlayedSongs.removeAt(0);
    }
    notifyListeners();
  }

  void addToQueue(Song song) {
    _queue.add(song);
    notifyListeners();
  }

  void addToPlaylist(Song song) {
    _playlist.add(song);
    notifyListeners();
  }
}
