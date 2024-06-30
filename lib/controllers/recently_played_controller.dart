import 'package:flutter/material.dart';
import '../models/song.dart';

class RecentlyPlayedProvider with ChangeNotifier {
  final List<Song> _recentlyPlayedSongs = <Song>[];

  List<Song> get recentlyPlayedSongs => _recentlyPlayedSongs;

  void addRecentlyPlayedSong(Song song) {
    _recentlyPlayedSongs.add(song);
    notifyListeners();
  }

  void clearRecentlyPlayedSongs() {
    _recentlyPlayedSongs.clear();
    notifyListeners();
  }
}
