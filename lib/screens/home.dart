import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mood_tunes/models/cards.dart';
import 'package:mood_tunes/models/drawer_items.dart';
import 'package:audioplayers/audioplayers.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key});
  final AudioPlayer audioPlayer = AudioPlayer();
  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAllNamed('/login'); // Navigate to login screen after logout
    } catch (e) {
      // Handle any errors that occur during the logout process
      print('Error during logout: $e');
      // You can show a snackbar or other UI to inform the user about the error
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "MoodTunes",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              onPressed: _logout,
            ),
          ],
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0, // Remove app bar shadow
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: Text(
                  'Your Name', // Add user's name or username dynamically
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              DrawerItem(
                icon: Icons.library_music,
                title: 'Playlists',
                onTap: () {
                  // Navigate to playlists screen or perform an action
                  // Example: Get.toNamed('/playlists');
                },
              ),
              DrawerItem(
                icon: Icons.settings,
                title: 'Settings',
                onTap: () {
                  // Navigate to settings screen or perform an action
                  // Example: Get.toNamed('/settings');
                },
              ),
              DrawerItem(
                icon: Icons.person,
                title: 'Profile',
                onTap: () {
                  // Navigate to profile screen or perform an action
                  // Example: Get.toNamed('/profile');
                },
              ),
              DrawerItem(
                icon: Icons.music_note,
                title: 'Other Music Options',
                onTap: () {
                  // Navigate to other music options screen or perform an action
                  // Example: Get.toNamed('/other_music_options');
                },
              ),
              // Add yourself
              DrawerItem(
                icon: Icons.person_pin,
                title: 'Add Yourself',
                onTap: () {
                  // Perform an action for adding yourself
                  // Example: Get.toNamed('/add_yourself');
                },
              ),
              DrawerItem(
                icon: Icons.star,
                title: 'Favorites',
                onTap: () {
                  // Navigate to favorites screen or perform an action
                  // Example: Get.toNamed('/favorites');
                },
              ),
              DrawerItem(
                icon: Icons.radio,
                title: 'Radio',
                onTap: () {
                  // Navigate to radio screen or perform an action
                  // Example: Get.toNamed('/radio');
                },
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Mix for You",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5, // Change this to the actual number of cards
                  itemBuilder: (context, index) {
                    return GlassyCard(); // Create a GlassyCard widget
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Latest",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5, // Change this to the actual number of cards
                  itemBuilder: (context, index) {
                    return GlassyCard(); // Create a GlassyCard widget
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () async {
                    String url =
                        'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';
                    await audioPlayer.play(url as Source);
                  },
                  child: Text('Play')),
              ElevatedButton(
                  onPressed: () {
                    audioPlayer.pause();
                  },
                  child: Text('Pause')),
            ],
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }
}
