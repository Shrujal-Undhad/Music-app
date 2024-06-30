import 'song.dart';

class Playlist {
  final String id;
  final String name;
  final List<String> songIds;
  final String bannerImagePath; 
  final List<Song> songs; 

  Playlist({
    required this.id,
    required this.name,
    required this.songIds,
    required this.bannerImagePath,
    required this.songs,
  });
}