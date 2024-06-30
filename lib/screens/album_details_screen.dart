import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/album_controller.dart';
import 'music_player_screen.dart';
import '../models/album.dart';
import '../models/song.dart';
import '../widgets/song_card.dart';

class AlbumDetailScreen extends StatelessWidget {
  final Album album;
  final List<Song> songs;

  const AlbumDetailScreen({
    super.key,
    required this.album,
    required this.songs,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AlbumProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(album.albumName),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                album.albumArtPath,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error);
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  album.albumName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  album.artistName,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Songs',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
              Consumer<AlbumProvider>(
                builder: (context, albumProvider, child) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: songs.length,
                    itemBuilder: (context, index) {
                      final song = songs[index];
                      return SongCard(
                        songData: song,
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => MusicPlayerScreen(
                              song: song,
                            ),
                          ));
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
