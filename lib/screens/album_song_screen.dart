import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mood_tunes/apis/songs_api.dart';
import 'package:mood_tunes/models/album_song_model.dart';

class AlbumSongScreen extends StatefulWidget {
  final String browseId;

  AlbumSongScreen({required this.browseId});

  @override
  _AlbumSongScreenState createState() => _AlbumSongScreenState();
}

class _AlbumSongScreenState extends State<AlbumSongScreen> {
  AlbumSongModel? albumData;

  @override
  void initState() {
    super.initState();
    // Fetch album data when the screen initializes
    fetchAlbumData();
  }

  Future<void> fetchAlbumData() async {
    try {
      Map<String, dynamic> albumDataMap =
          await SongApi().fetchAlbumData(widget.browseId);

      setState(() {
        albumData = AlbumSongModel.fromJson(albumDataMap);
      });
    } catch (e) {
      // Handle the exception
      print('Error fetching album data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(albumData?.title ?? 'Album Songs'),
      ),
      body: albumData != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Background Image with Glassy Effect
                Container(
                  height: MediaQuery.of(context).size.height / 3,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        (albumData!.thumbnails != null &&
                                albumData!.thumbnails.isNotEmpty)
                            ? albumData!.thumbnails[0]['url'] ??
                                'placeholder_url'
                            : 'placeholder_url',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Glassy Effect
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                        child: Container(
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),
                      // Album Name
                      Positioned(
                        bottom: 16.0,
                        left: 35.0,
                        child: Text(
                          albumData!.title ?? 'Album Name',
                          style: TextStyle(
                            color: Colors.amber,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // List of songs
                Expanded(
                  child: ListView.builder(
                    itemCount: albumData!.tracks.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> track = albumData!.tracks[index];
                      return Card(
                        color: Theme.of(context).cardColor.withOpacity(0.01),
                        child: ListTile(
                          // leading: rounded thumnaols
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Container(
                                width: 50.0, // Adjust the width as needed
                                height: 50.0, // Adjust the height as needed

                                // adding thumbnail
                                child: Image.network(
                                  (albumData!.thumbnails != null &&
                                          albumData!.thumbnails.isNotEmpty)
                                      ? albumData!.thumbnails[0]['url'] ?? ''
                                      : '',
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover,
                                )),
                          ),
                          title: Text(
                            track['title'] ?? '',
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            track['album'] ?? '',
                            style: TextStyle(color: Colors.white70),
                          ),
                          onTap: () {
                            // Handle the tap event
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
