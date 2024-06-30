import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/album.dart';
import '../models/artist.dart';
import '../models/play_list.dart';
import '../models/song.dart';

class ApiService with ChangeNotifier {
  static const String _clientId = 'd7d3cff7624c48f2bf104d2499c2d1e2';
  static const String _clientSecret = '13644ce3bd5d44c4b2fd0dc871295259';

  final Dio _dio = Dio();
  String? _accessToken;

  Future<String> _getAccessToken() async {
    if (_accessToken != null) {
      return _accessToken!;
    }
    try {
      final String credentials = '$_clientId:$_clientSecret';
      final String encodedCredentials = base64Encode(utf8.encode(credentials));

      final response = await _dio.post(
        'https://accounts.spotify.com/api/token',
        options: Options(
          headers: {
            'Authorization': 'Basic $encodedCredentials',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
        data: {'grant_type': 'client_credentials'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        _accessToken = data['access_token'];
        return _accessToken!;
      } else {
        print('Failed to get access token: ${response.statusCode} ${response.data}');
        throw Exception('Failed to get access token: ${response.statusCode} ${response.data}');
      }
    } catch (e) {
      print('Error getting access token: $e');
      throw Exception('Failed to get access token');
    }
  }

  Future<List<Album>> searchAlbums(String query) async {
    try {
      final accessToken = await _getAccessToken();

      final response = await _dio.get(
        'https://api.spotify.com/v1/search',
        queryParameters: {
          'q': query,
          'type': 'album',
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<Album> albums = [];
        final List<dynamic> items = response.data['albums']['items'];

        for (var item in items) {
          final String albumName = item['name'] ?? '';
          final String albumArtPath = item['images']?.isNotEmpty == true
              ? item['images'][0]['url'] ?? ''
              : '';
          final String artistName = item['artists']?.isNotEmpty == true
              ? item['artists'][0]['name'] ?? ''
              : '';

          final Album album = Album(
            albumName: albumName,
            albumArtPath: albumArtPath,
            songs: [],
            artistName: artistName,
          );

          albums.add(album);
        }
        return albums;
      } else {
        print('Failed to load albums: ${response.statusCode} ${response.data}');
        throw Exception('Failed to load albums: ${response.statusCode} ${response.data}');
      }
    } catch (e) {
      print('Error searching albums: $e');
      throw Exception('Failed to load albums');
    }
  }

  Future<List<Song>> searchSongs(String query) async {
    try {
      final accessToken = await _getAccessToken();

      final response = await _dio.get(
        'https://api.spotify.com/v1/search',
        queryParameters: {
          'q': query,
          'type': 'track',
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<Song> songs = [];
        final List<dynamic> items = response.data['tracks']['items'];

        for (var item in items) {
          final String trackId = item['id'] ?? '';
          final String trackName = item['name'] ?? '';
          final String artistName = item['artists'][0]['name'] ?? '';
          final String albumName = item['album']['name'] ?? '';
          final String albumArtPath = item['album']['images']?.isNotEmpty == true
              ? item['album']['images'][0]['url'] ?? ''
              : '';
          final String trackLink = item['external_urls']['spotify'] ?? '';
          final int durationMs = item['duration_ms'] ?? 0;

          final int minutes = (durationMs / 60000).floor();
          final int seconds = ((durationMs % 60000) / 1000).round();
          final String duration = '$minutes:${seconds < 10 ? '0' : ''}$seconds';

          final Song song = Song(
            id: trackId,
            name: trackName,
            artist: artistName,
            album: albumName,
            albumArtPath: albumArtPath,
            link: trackLink,
            duration: duration,
          );

          songs.add(song);
        }
        return songs;
      } else {
        print('Failed to search songs: ${response.statusCode} ${response.data}');
        throw Exception('Failed to search songs: ${response.statusCode} ${response.data}');
      }
    } catch (e) {
      print('Error searching songs: $e');
      throw Exception('Failed to search songs');
    }
  }

  Future<List<Album>> searchAlbumsByGenre(String genre) async {
    try {
      final accessToken = await _getAccessToken();

      final response = await _dio.get(
        'https://api.spotify.com/v1/search',
        queryParameters: {
          'q': 'genre:"$genre"',
          'type': 'album',
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<Album> albums = [];
        final List<dynamic> items = response.data['albums']['items'];

        for (var item in items) {
          final String albumName = item['name'] ?? '';
          final String albumArtPath = item['images']?.isNotEmpty == true
              ? item['images'][0]['url'] ?? ''
              : '';
          final String artistName = item['artists']?.isNotEmpty == true
              ? item['artists'][0]['name'] ?? ''
              : '';

          final Album album = Album(
            albumName: albumName,
            albumArtPath: albumArtPath,
            songs: [],
            artistName: artistName,
          );

          albums.add(album);
        }
        return albums;
      } else {
        print('Failed to load albums by genre: ${response.statusCode} ${response.data}');
        throw Exception('Failed to load albums by genre: ${response.statusCode} ${response.data}');
      }
    } catch (e) {
      print('Error searching albums by genre: $e');
      throw Exception('Failed to load albums by genre');
    }
  }

  Future<List<Playlist>> searchPlaylists(String query) async {
    try {
      final accessToken = await _getAccessToken();

      final response = await _dio.get(
        'https://api.spotify.com/v1/search',
        queryParameters: {
          'q': query,
          'type': 'playlist',
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<Playlist> playlists = [];
        final List<dynamic> items = response.data['playlists']['items'];

        for (var item in items) {
          final String playlistId = item['id'] ?? '';
          final String playlistName = item['name'] ?? '';
          final String bannerImagePath = item['images']?.isNotEmpty == true
              ? item['images'][0]['url'] ?? ''
              : '';

          final Playlist playlist = Playlist(
            id: playlistId,
            name: playlistName,
            songIds: [],
            bannerImagePath: bannerImagePath,
            songs: [],
          );

          playlists.add(playlist);
        }
        return playlists;
      } else {
        print('Failed to search playlists: ${response.statusCode} ${response.data}');
        throw Exception('Failed to search playlists: ${response.statusCode} ${response.data}');
      }
    } catch (e) {
      print('Error searching playlists: $e');
      throw Exception('Failed to search playlists');
    }
  }

  Future<List<Artist>> searchArtists(String query) async {
    try {
      final accessToken = await _getAccessToken();

      final response = await _dio.get(
        'https://api.spotify.com/v1/search',
        queryParameters: {
          'q': query,
          'type': 'artist',
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<Artist> artists = [];
        final List<dynamic> items = response.data['artists']['items'];

        for (var item in items) {
          final String artistId = item['id'] ?? '';
          final String artistName = item['name'] ?? '';
          final String artistImage = item['images']?.isNotEmpty == true
              ? item['images'][0]['url'] ?? ''
              : '';

          final Artist artist = Artist(
            id: artistId,
            name: artistName,
            image: artistImage,
          );

          artists.add(artist);
        }
        return artists;
      } else {
        print('Failed to search artists: ${response.statusCode} ${response.data}');
        throw Exception('Failed to search artists: ${response.statusCode} ${response.data}');
      }
    } catch (e) {
      print('Error searching artists: $e');
      throw Exception('Failed to search artists');
    }
  }
}