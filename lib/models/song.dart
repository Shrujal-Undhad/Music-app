class Song {
  final String id;
  final String name;
  final String artist;
  final String albumArtPath;
  final String link;
  final String album; 
  final String duration;

  Song({
    required this.id,
    required this.name,
    required this.artist,
    required this.albumArtPath,
    required this.link, 
    required this.album, 
    required this.duration,
  });

  var isFavorite = false;
}
