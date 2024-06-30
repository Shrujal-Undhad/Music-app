import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/song_controller.dart';
import '../widgets/song_card.dart';
import 'music_player_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final songProvider = Provider.of<SongProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  _performSearch(songProvider, value);
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                _performSearch(songProvider, _searchController.text);
              },
            ),
          ],
        ),
      ),
      body: _buildBody(songProvider),
    );
  }

  Widget _buildBody(SongProvider songProvider) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (_errorMessage.isNotEmpty) {
      return Center(child: Text(_errorMessage));
    } else {
      return _buildSearchResults(songProvider);
    }
  }

  Widget _buildSearchResults(SongProvider songProvider) {
    if (songProvider.songs.isEmpty && _searchController.text.isNotEmpty) {
      return Center(child: Text('No results found.'));
    }

    return ListView.builder(
      itemCount: songProvider.songs.length,
      itemBuilder: (context, index) {
        final song = songProvider.songs[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MusicPlayerScreen(song: song)),
            );
          },
          child: SongListCard(
            song: song,
          ),
        );
      },
    );
  }

  void _performSearch(SongProvider songProvider, String query) {
    if (query.isNotEmpty) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });
      songProvider.fetchSongs(query).then((_) {
        setState(() {
          _isLoading = false;
        });
      }).catchError((error) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Error searching songs: $error';
        });
      });
    } else {
      // Clear search results if query is empty
      songProvider.fetchSongs(query).then((_) {
        setState(() {
          _isLoading = false;
        });
      }).catchError((error) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Error fetching all songs: $error';
        });
      });
    }
  }
}
