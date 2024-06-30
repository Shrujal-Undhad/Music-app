// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controllers/playlist_controller.dart';
// import '../models/play_list.dart';

// class Playlists extends StatelessWidget {
//   const Playlists({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final PlaylistController playlistController = Get.put(PlaylistController());

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Playlists'),
//       ),
//       body: Obx(() {
//         if (playlistController.playlists.isEmpty) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         return ListView.builder(
//           itemCount: playlistController.playlists.length,
//           itemBuilder: (context, index) {
//             Playlist playlist = playlistController.playlists[index];
//             return ListTile(
//               title: Text(playlist.name),
//               subtitle: Text('Number of songs: ${playlist.songCount}'),
//               // Add more details or actions as needed
//               // onTap: () {
//               //   // Add logic to navigate to playlist details or player screen
//               // },
//             );
//           },
//         );
//       }),
//     );
//   }
// }
