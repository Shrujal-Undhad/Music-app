import 'package:flutter/material.dart';

class GenreChipProvider with ChangeNotifier {
  String _selectedGenre = '';

  String get selectedGenre => _selectedGenre;

  void selectGenre(String genre) {
    if (_selectedGenre == genre) {
      _selectedGenre = '';
    } else {
      _selectedGenre = genre;
    }
    notifyListeners();
  }

  bool isGenreSelected(String genre) {
    return _selectedGenre == genre;
  }
}
