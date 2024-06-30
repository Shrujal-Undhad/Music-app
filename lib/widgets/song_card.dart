import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/song.dart';
import '../controllers/song_controller.dart';

class SongCard extends StatelessWidget {
  final Song songData;
  final VoidCallback onTap;

  const SongCard({
    required this.songData,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[200],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              songData.albumArtPath,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 8),
            Text(
              songData.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              songData.artist,
              style: TextStyle(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class SongListCard extends StatelessWidget {
  final Song song;
  final VoidCallback? onAddToPlaylist;
  final VoidCallback? onAddToQueue;

  const SongListCard({
    Key? key,
    required this.song,
    this.onAddToPlaylist,
    this.onAddToQueue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final songProvider = Provider.of<SongProvider>(context, listen: false);

    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(
          song.albumArtPath,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(song.name),
      subtitle: Text(song.artist),
      trailing: PopupMenuButton(
        icon: const Icon(Icons.more_vert),
        itemBuilder: (context) => [
          PopupMenuItem(
            child: Consumer<SongProvider>(
              builder: (context, songProvider, child) {
                return ListTile(
                  leading: Icon(song.isFavorite ? Icons.favorite : Icons.favorite_border),
                  title: Text(song.isFavorite ? 'Remove from Favorites' : 'Add to Favorites'),
                  onTap: () {
                    songProvider.toggleFavorite(song);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          PopupMenuItem(
            child: ListTile(
              leading: const Icon(Icons.playlist_add),
              title: const Text('Add to Playlist'),
              onTap: () {
                if (onAddToPlaylist != null) {
                  onAddToPlaylist!();
                }
                songProvider.addToPlaylist(song);
                Navigator.pop(context);
              },
            ),
          ),
          PopupMenuItem(
            child: ListTile(
              leading: const Icon(Icons.queue),
              title: const Text('Add to Queue'),
              onTap: () {
                if (onAddToQueue != null) {
                  onAddToQueue!();
                }
                songProvider.addToQueue(song);
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
