import 'song.dart';

class Album {
  final String albumName;
  final String artistName;
  final String albumArtPath;
  final List<Song> songs;

  Album({
    required this.albumName,
    required this.artistName,
    required this.albumArtPath,
    required this.songs,
  });
}