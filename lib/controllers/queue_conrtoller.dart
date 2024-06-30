import 'package:flutter/material.dart';
import '../models/song.dart';

class QueueProvider with ChangeNotifier {
  List<Song> _queue = [];

  List<Song> get queue => _queue;

  void addToQueue(Song song) {
    _queue.add(song);
    notifyListeners();
  }

  void removeFromQueue(Song song) {
    _queue.remove(song);
    notifyListeners();
  }

  void setQueue(List<Song> songs) {
    _queue = songs;
    notifyListeners();
  }
}
