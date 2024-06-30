import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/album.dart';

class AlbumProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Album> _albums = [];
  List<Album> _filteredAlbums = [];
  List<Album> _library = [];
  bool _isLoading = false;
  bool _isError = false;

  List<Album> get albums => _albums;
  List<Album> get filteredAlbums => _filteredAlbums;
  List<Album> get library => _library;
  bool get isLoading => _isLoading;
  bool get isError => _isError;

  AlbumProvider() {
  }

  Future<void> fetchAlbums(String query) async {
    _isLoading = true;
    notifyListeners();

    try {
      final fetchedAlbums = await _apiService.searchAlbums(query);
      _albums = fetchedAlbums;
      filterAlbums('');
      _isError = false;
    } catch (e) {
      print('Error fetching albums: $e');
      _isError = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterAlbums(String query) {
    if (query.isEmpty) {
      _filteredAlbums = _albums;
    } else {
      final lowercaseQuery = query.toLowerCase();
      _filteredAlbums = _albums.where((album) =>
          album.albumName.toLowerCase().contains(lowercaseQuery)).toList();
    }
    notifyListeners();
  }

  void addToLibrary(Album album) {
    if (!_library.contains(album)) {
      _library.add(album);
      notifyListeners();
    }
  }

  void removeFromLibrary(Album album) {
    _library.remove(album);
    notifyListeners();
  }

  bool isAlbumAdded(Album album) {
    return _library.contains(album);
  }
}
