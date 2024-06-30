// import 'package:spotify_sdk/models/player_state.dart';
// import 'package:spotify_sdk/spotify_sdk.dart';

// class SpotifyService {
//   Future<void> connectToSpotifyRemote() async {
//     try {
//       var result = await SpotifySdk.connectToSpotifyRemote(
//         clientId: 'd7d3cff7624c48f2bf104d2499c2d1e2',
//         redirectUrl: 'your-app-redirect-url',
//       );
//       print('connect to spotify remote result: $result');
//     } catch (error) {
//       print('error connecting to spotify remote: $error');
//     }
//   }

//   Future<void> play(String spotifyUri) async {
//     try {
//       await SpotifySdk.play(spotifyUri: spotifyUri);
//     } catch (error) {
//       print('error playing track: $error');
//     }
//   }

//   Future<void> pause() async {
//     try {
//       await SpotifySdk.pause();
//     } catch (error) {
//       print('error pausing track: $error');
//     }
//   }

//   Future<PlayerState?> getPlayerState() async {
//     try {
//       return await SpotifySdk.getPlayerState();
//     } catch (error) {
//       print('error getting player state: $error');
//       rethrow;
//     }
//   }
// }
