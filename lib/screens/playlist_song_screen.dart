// PlaylistSongsScreen

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mood_tunes/firebase_firestore_db.dart';
import 'package:mood_tunes/models/song_model.dart';
import 'package:mood_tunes/screens/song_item_card.dart';
// import 'package:mood_tunes/widgets/song_item_card.dart';

class PlaylistSongsScreen extends StatelessWidget {
  final String userId;
  final String playlistId;
  final String playlistName;

  PlaylistSongsScreen({
    required this.playlistName,
    required this.userId,
    required this.playlistId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Playlist Songs'),
      ),
      body: StreamBuilder<List<SongModel>>(
        stream: FirebaseDb().getSongsInPlaylistStream(userId, playlistId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.white),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No songs in the playlist.',
                style: TextStyle(color: Colors.white),
              ),
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Background Image with Glassy Effect
                Container(
                  height: MediaQuery.of(context).size.height / 3,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        snapshot.data![0].thumbnails.isNotEmpty
                            ? snapshot.data![0].thumbnails[0]['url']
                            : 'placeholder_url',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Glassy Effect
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                        child: Container(
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),
                      // Playlist Name
                      Positioned(
                        bottom: 16.0,
                        left: 35.0,
                        child: Text(
                          playlistName,
                          style: TextStyle(
                            color: Colors.amber,
                            fontSize: 34.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Playlist Songs
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      SongModel song = snapshot.data![index];
                      return SongItemCard(
                        userId: userId,
                        playlistId: playlistId,
                        playlistName: playlistName,
                        song: song,
                        onOptionsPressed: () {
                          // Handle options for PlaylistSongsScreen
                          // e.g., show add to playlist and remove from this playlist
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
