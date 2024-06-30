// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../controllers/profile_controller.dart'; 
// import '../models/user_data.dart';

// class ProfileScreen extends StatelessWidget {
//   ProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Obtain the userData instance from somewhere (in this case, assuming from a controller)
//     final UserData userData = Provider.of<UserData>(context);

//     return ChangeNotifierProvider(
//       create: (context) => ProfileProvider(), // Provide the ProfileProvider instance
//       builder: (context, _) {
//         final profileProvider = Provider.of<ProfileProvider>(context, listen: false);

//         // Initialize the controller
//         profileProvider.init(userData);

//         return Scaffold(
//           appBar: AppBar(
//             title: const Text('User Profile'),
//           ),
//           body: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Consumer<UserData>(
//                   builder: (context, userData, _) {
//                     return CircleAvatar(
//                       radius: 50,
//                       backgroundImage: NetworkImage(userData.avatarPath),
//                     );
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 Consumer<UserData>(
//                   builder: (context, userData, _) {
//                     return Text('Name: ${userData.name}');
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () {
//                     // Navigate to settings screen
//                     // Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsScreen()));
//                   },
//                   child: const Text('Settings'),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
