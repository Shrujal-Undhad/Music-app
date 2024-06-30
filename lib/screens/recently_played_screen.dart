import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/song_controller.dart';
import '../widgets/song_card.dart';

class RecentlyPlayedSongs extends StatelessWidget {
  const RecentlyPlayedSongs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final songProvider = Provider.of<SongProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recently Played'),
      ),
      body: Consumer<SongProvider>(
        builder: (context, songController, _) {
          final recentlyPlayedSongs = songController.recentlyPlayedSongs;

          return ListView.builder(
            itemCount: recentlyPlayedSongs.length,
            itemBuilder: (context, index) {
              final song = recentlyPlayedSongs[index];
              return SongListCard(song: song);
            },
          );
        },
      ),
    );
  }
}
