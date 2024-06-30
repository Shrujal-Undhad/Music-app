import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/album_controller.dart';
import '../models/album.dart';
import '../models/song.dart';
import '../screens/album_details_screen.dart';

class AlbumCard extends StatelessWidget {
  final Album album;
  final List<Song> songs;
  final VoidCallback onTap;

  const AlbumCard({
    super.key,
    required this.album,
    required this.songs,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final albumProvider = Provider.of<AlbumProvider>(context, listen: false);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AlbumDetailScreen(album: album, songs: songs),
        ));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                album.albumArtPath,
                width: double.infinity,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error);
                },
              ),
            ),
            const SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          album.albumName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          album.artistName,
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Consumer<AlbumProvider>(
                    builder: (context, provider, child) {
                      bool isAlbumAdded = provider.isAlbumAdded(album);
                      return IconButton(
                        icon: Icon(isAlbumAdded ? Icons.remove : Icons.add),
                        onPressed: () {
                          if (isAlbumAdded) {
                            provider.removeFromLibrary(album);
                          } else {
                            provider.addToLibrary(album);
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
