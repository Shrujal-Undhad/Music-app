import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/Library_controller.dart';
import '../widgets/album_card.dart';
import '../widgets/genre_chip.dart';

class LibraryScreen extends StatelessWidget {
  LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final libraryProvider = Provider.of<LibraryProvider>(context);

    libraryProvider.fetchAlbumsByGenre('Pop');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
      ),
      body: Column(
        children: [
          // Genre chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                for (String genre in libraryProvider.genres)
                  GenreChip(
                    genre: genre,
                  ),
              ],
            ),
          ),
          // Display albums
          Expanded(
            child: Consumer<LibraryProvider>(
              builder: (context, provider, child) {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: provider.albums.length,
                  itemBuilder: (context, index) {
                    final album = provider.albums[index];
                    return AlbumCard(
                      album: album,
                      songs: album.songs,
                      onTap: () {
                        // Handle album tap
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
