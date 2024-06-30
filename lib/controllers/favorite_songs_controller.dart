import 'package:flutter/material.dart';
import '../models/song.dart';

class FavoriteSongsProvider with ChangeNotifier {
  final List<Song> _favoriteSongs = [];

  List<Song> get favoriteSongs => _favoriteSongs;

  void addFavoriteSong(Song song) {
    if (!_favoriteSongs.contains(song)) {
      _favoriteSongs.add(song);
      notifyListeners();
    }
  }

  void removeFavoriteSong(Song song) {
    _favoriteSongs.remove(song);
    notifyListeners();
  }

  bool isSongFavorite(Song song) {
    return _favoriteSongs.contains(song);
  }

  void clearFavoriteSongs() {
    _favoriteSongs.clear();
    notifyListeners();
  }

  List<Song> getFavoriteSongs() {
    return List.unmodifiable(_favoriteSongs);
  }
}
