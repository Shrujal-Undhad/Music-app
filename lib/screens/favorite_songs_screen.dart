import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/favorite_songs_Controller.dart';
import 'music_player_screen.dart';

class FavoriteSongsScreen extends StatelessWidget {
  const FavoriteSongsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Songs'),
      ),
      body: Consumer<FavoriteSongsProvider>(
        builder: (context, favoriteSongsProvider, child) {
          final favoriteSongs = favoriteSongsProvider.favoriteSongs;

          if (favoriteSongs.isEmpty) {
            return const Center(
              child: Text('No favorite songs.'),
            );
          }

          return ListView.builder(
            itemCount: favoriteSongs.length,
            itemBuilder: (context, index) {
              final song = favoriteSongs[index];
              return ListTile(
                title: Text(song.name),
                subtitle: Text(song.artist),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MusicPlayerScreen(song: song),
                  ));
                },
              );
            },
          );
        },
      ),
    );
  }
}
