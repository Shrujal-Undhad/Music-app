import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/album_controller.dart';
import '../controllers/myaudioplayer.dart';
import '../controllers/song_controller.dart';
import '../models/song.dart';
import 'music_player_screen.dart';
import 'recently_played_screen.dart';
import 'favorite_songs_screen.dart';
import 'search_screen.dart';
import '../widgets/album_card.dart';
import '../widgets/song_card.dart';
import 'album_details_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  void _fetchData() {
    final albumProvider = Provider.of<AlbumProvider>(context, listen: false);
    final songProvider = Provider.of<SongProvider>(context, listen: false);
    albumProvider.fetchAlbums('pop');
    songProvider.fetchSongs('rap');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Music',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const SearchScreen(),
              ));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Featured Songs'),
            _buildFeaturedSongs(context),
            _buildSectionTitle('Explore'),
            _buildExploreSection(context),
            _buildSectionTitle('Albums'),
            _buildAlbumGrid(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildFeaturedSongs(BuildContext context) {
    return Consumer<SongProvider>(
      builder: (context, songProvider, child) {
        final songList = songProvider.songs;
        return SizedBox(
          height: 175,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: songList.length,
            itemBuilder: (context, index) {
              final song = songList[index];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SongCard(
                  songData: song,
                  onTap: () => _playSong(context, song),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildExploreSection(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildExploreButton(
            text: 'Recently Played',
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => RecentlyPlayedSongs(),
              ));
            },
          ),
          const SizedBox(width: 8.0),
          _buildExploreButton(
            text: 'Favorite Songs',
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const FavoriteSongsScreen(),
              ));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildExploreButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        side: const BorderSide(color: Colors.black),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }

  Widget _buildAlbumGrid(BuildContext context) {
    return Consumer<AlbumProvider>(
      builder: (context, albumProvider, child) {
        final albumList = albumProvider.albums;

        if (albumProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (albumProvider.isError) {
          return const Center(child: Text('Error fetching albums'));
        }

        if (albumList.isEmpty) {
          return const SizedBox.shrink();
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: albumList.length,
          itemBuilder: (context, index) {
            final album = albumList[index];

            return AlbumCard(
              album: album,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AlbumDetailScreen(album: album, songs: album.songs),
                ));
              },
              songs: album.songs,
            );
          },
        );
      },
    );
  }

  void _playSong(BuildContext context, Song song) {
    final myAudioPlayerProvider = Provider.of<MyAudioPlayerProvider>(context, listen: false);
    myAudioPlayerProvider.playSong(song);
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => MusicPlayerScreen(song: song),
    ));
  }
}
