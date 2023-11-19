// SearchSongs

import 'package:flutter/material.dart';
import 'package:mood_tunes/apis/songs_api.dart';
import 'package:mood_tunes/firebase_db.dart';
import 'package:mood_tunes/firebase_firestore_db.dart';
import 'package:mood_tunes/models/song_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mood_tunes/screens/song_item_card.dart';
// import 'package:mood_tunes/widgets/song_item_card.dart';

class SearchSongs extends StatefulWidget {
  @override
  _SearchSongsState createState() => _SearchSongsState();
}

class _SearchSongsState extends State<SearchSongs> {
  TextEditingController _searchController = TextEditingController();
  List<dynamic> searchResults = [];
  SongApi _songApi = SongApi();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Songs'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Enter search term',
                labelStyle: TextStyle(color: Colors.white),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search, color: Colors.white),
                  onPressed: () {
                    _searchSongs();
                  },
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: _buildSearchResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (searchResults.isEmpty) {
      return Center(
        child: Text(
          'No results to display',
          style: TextStyle(color: Colors.white),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          var song = searchResults[index];
          SongModel songModel = SongModel.fromJson(song);

          return SongItemCard(
            userId: FirebaseAuth.instance.currentUser!.uid,
            playlistId: '', // Pass an empty string or any placeholder value
            playlistName: '',
            song: songModel,
            onOptionsPressed: () {
              // Handle options for SearchSongs
              // e.g., show add to playlist and add to liked songs
              _showOptionsDialog(songModel);
            },
          );
        },
      );
    }
  }

  void _showOptionsDialog(SongModel songModel) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Options'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.playlist_add),
                title: Text('Add to Playlist'),
                onTap: () {
                  Navigator.pop(context); // Close the dialog
                  _addToPlaylist(songModel);
                },
              ),
              ListTile(
                leading: Icon(Icons.favorite),
                title: Text('Add to Liked Songs'),
                onTap: () {
                  Navigator.pop(context); // Close the dialog
                  _addToLikedSongs(songModel);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _addToPlaylist(SongModel songModel) async {
    // Fetch and store the current user ID
    User user = FirebaseAuth.instance.currentUser!;
    String userId = user.uid;

    // Fetch existing playlists using the stream
    List<Map<String, String>> playlists =
        await FirebaseDb().getPlaylistsStream(userId).first;

    // Show a dialog to choose or create a playlist
    String? chosenPlaylistId = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add to Playlist'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Choose a playlist or create a new one:'),
              SizedBox(height: 16.0),
              ...playlists.map((playlist) {
                return ListTile(
                  title: Text(playlist['name'] ?? ''),
                  onTap: () {
                    Navigator.pop(
                        context, playlist['id']); // Return chosen playlist ID
                  },
                );
              }).toList(),
              SizedBox(height: 16.0),
              ListTile(
                title: Text('Create New Playlist'),
                onTap: () {
                  Navigator.pop(
                      context, ''); // Return an empty string for a new playlist
                },
              ),
            ],
          ),
        );
      },
    );

    if (chosenPlaylistId != null && chosenPlaylistId.isNotEmpty) {
      // Add to the chosen playlist
      FirebaseDb().addToPlaylist(userId, chosenPlaylistId, songModel);
      _showSnackbar(
          'Added to playlist: ${playlists.firstWhere((p) => p['id'] == chosenPlaylistId)['name']}');
    } else {
      // Handle creating a new playlist (prompt the user for a new playlist name)
      String? newPlaylistName = await _showCreatePlaylistDialog();
      if (newPlaylistName != null && newPlaylistName.isNotEmpty) {
        String newPlaylistId =
            await FirebaseDb().createPlaylist(userId, newPlaylistName);
        FirebaseDb().addToPlaylist(userId, newPlaylistId, songModel);
        _showSnackbar('Added to new playlist: $newPlaylistName');
      }
    }
  }

  Future<String?> _showCreatePlaylistDialog() async {
    TextEditingController playlistNameController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Create New Playlist'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Enter the name for the new playlist:'),
              SizedBox(height: 8.0),
              TextField(
                controller: playlistNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Playlist Name',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pop(context, playlistNameController.text),
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _addToLikedSongs(SongModel songModel) {
    // Fetch and store the current user ID
    User user = FirebaseAuth.instance.currentUser!;
    String userId = user.uid;

    // Implement logic to add to liked songs here
    // You can use the songModel and the user's ID to update Firestore
    // ...
    FirebaseDb().addOrUpdateLikedSong(userId, songModel);
  }

  Future<void> _searchSongs() async {
    String searchTerm = _searchController.text.trim();
    if (searchTerm.isNotEmpty) {
      try {
        List<dynamic> results = await _songApi.fetchSearchResults(searchTerm);
        setState(() {
          searchResults = results;
        });

        // Fetch and store the current user ID
        User user = FirebaseAuth.instance.currentUser!;
        String userId = user.uid;

        // Now you can use userId for performing database operations.
        // For example, you can pass userId to methods like _addToPlaylist and _addToLikedSongs.
      } catch (e) {
        print('Error fetching search results: $e');
        setState(() {
          searchResults = [];
        });
      }
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
