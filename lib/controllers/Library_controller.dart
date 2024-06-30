import 'package:flutter/material.dart';
import '../models/album.dart';
import '../services/api_service.dart';

class LibraryProvider with ChangeNotifier {
  List<Album> _albums = [];
  List<String> _genres = [];
  String _selectedGenre = '';
  List<Album> _library = [];

  List<Album> get library => _library;
  List<Album> get albums => _albums;
  List<String> get genres => _genres;
  String get selectedGenre => _selectedGenre;

  final ApiService apiService = ApiService();

  void setAlbums(List<Album> albums) {
    _albums = albums;
    notifyListeners();
  }

  void setGenres(List<String> genres) {
    _genres = genres;
    notifyListeners();
  }

  void setSelectedGenre(String genre) {
    _selectedGenre = genre;
    notifyListeners();
  }

  void addToLibrary(Album album) {
    _library.add(album);
    notifyListeners();
  }

  void removeFromLibrary(Album album) {
    _library.remove(album);
    notifyListeners();
  }

  Future<void> fetchAlbumsByGenre(String genre) async {
    try {
      final fetchedAlbums = await apiService.searchAlbumsByGenre(genre);
      setAlbums(fetchedAlbums);
    } catch (e) {
      // Handle error
      print('Error fetching albums by genre: $e');
    }
  }
}
