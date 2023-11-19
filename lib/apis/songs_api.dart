import 'dart:convert';
import 'package:http/http.dart' as http;

class SongApi {
  List<dynamic> musicData = [];

  Future<List<dynamic>> fetchSearchResults(String searchString) async {
    String api_url = 'http://192.168.165.35:5000/get_music';
    final response = await http.post(
      Uri.parse(api_url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'search_term': searchString}),
    );

    if (response.statusCode == 200) {
      // If the server returns an OK response, parse the data
      musicData = json.decode(response.body);
      // print(musicData);
      return musicData;
    } else {
      // If the server did not return a 200 OK response, throw an exception
      throw Exception('Failed to load data');
    }
  }

  // for albums
  Future<List<dynamic>> fetchAlbumResults(String searchString) async {
    String api_url = 'http://192.168.165.35:5000/get_albums';
    final response = await http.post(
      Uri.parse(api_url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'search_term': searchString}),
    );

    if (response.statusCode == 200) {
      // If the server returns an OK response, parse the data
      musicData = json.decode(response.body);
      // print(musicData);
      return musicData;
    } else {
      // If the server did not return a 200 OK response, throw an exception
      throw Exception('Failed to load data');
    }
  }

  // get songs from album

  /*
  backend funtion :
  # get songs in an album
@app.route('/get_songs_from_album', methods=['POST'])
def get_songs_from_album():
    data = request.get_json()
    browse_id = data['browse_id']
    data = yt.get_album(browse_id)
    print(data)
    return jsonify(data)
  */

  /*
  // api response format recieved  from get_songs_from_album()
  {
  "title": "The Marshall Mathers LP",
  "type": "Album",
  "thumbnails": [
    {
      "url": "https://lh3.googleusercontent.com/O-SeXg61tYo15uWSBzWPVoUlBx2mQAioidlHq3y-AurmaQZI2Vso7BJoGeDNAm2g6HquAq1z4g-1EBI=w60-h60-l90-rj",
      "width": 60,
      "height": 60
    },
    {
      "url": "https://lh3.googleusercontent.com/O-SeXg61tYo15uWSBzWPVoUlBx2mQAioidlHq3y-AurmaQZI2Vso7BJoGeDNAm2g6HquAq1z4g-1EBI=w120-h120-l90-rj",
      "width": 120,
      "height": 120
    },
    {
      "url": "https://lh3.googleusercontent.com/O-SeXg61tYo15uWSBzWPVoUlBx2mQAioidlHq3y-AurmaQZI2Vso7BJoGeDNAm2g6HquAq1z4g-1EBI=w226-h226-l90-rj",
      "width": 226,
      "height": 226
    },
    {
      "url": "https://lh3.googleusercontent.com/O-SeXg61tYo15uWSBzWPVoUlBx2mQAioidlHq3y-AurmaQZI2Vso7BJoGeDNAm2g6HquAq1z4g-1EBI=w544-h544-l90-rj",
      "width": 544,
      "height": 544
    }
  ],
  "description": "The Marshall Mathers LP is the third studio album by American rapper Eminem, released on May 23, 2000, by Aftermath Entertainment and Interscope Records. The album was produced mostly by Dr. Dre and Eminem, along with the 45 King, the Bass Brothers, and Mel-Man. Recorded over a two-month period in several studios around Detroit, the album features more introspective lyricism, including Eminem's thoughts on his rise from rags to riches, the criticism of his music, and his estrangement from his family and wife. A transgressive work, it incorporates horrorcore and hardcore hip hop, while also featuring satirical songs. The album includes samples or appearances by Dido, RBX, Sticky Fingaz, Bizarre, Snoop Dogg, Xzibit, Nate Dogg, and D12.\nLike its predecessor, The Marshall Mathers LP was surrounded by significant controversy upon its release, while also propelling Eminem to the forefront of American pop culture. Criticism centered on lyrics that were considered violent, homophobic, and misogynistic, as well as a reference to the Columbine High School massacre.\n\nFrom Wikipedia (https://en.wikipedia.org/wiki/The_Marshall_Mathers_LP) under Creative Commons Attribution CC-BY-SA 3.0 (https://creativecommons.org/licenses/by-sa/3.0/legalcode)",
  "artists": [
    {
      "name": "Eminem",
      "id": "UCedvOgsKFzcK3hA5taf3KoQ"
    }
  ],
  "year": "2000",
  "trackCount": 18,
  "duration": "1 hour, 12 minutes",
  "audioPlaylistId": "OLAK5uy_lD5szk37WYrgQwlKKDQt6FfYgP9T_bgEg",
  "tracks": [
    {
      "videoId": "0NmsogZClfM",
      "title": "Public Service Announcement 2000",
      "artists": [
        {
          "name": "Eminem",
          "id": "UCedvOgsKFzcK3hA5taf3KoQ"
        }
      ],
      "album": "The Marshall Mathers LP",
      "likeStatus": "INDIFFERENT",
      "inLibrary": false,
      "thumbnails": null,
      "isAvailable": true,
      "isExplicit": true,
      "videoType": "MUSIC_VIDEO_TYPE_ATV",
      "duration": "0:28",
      "duration_seconds": 28,
      "feedbackTokens": {
        "add": "AB9zfpL5I2BxhsP8L7GGlmaZnGr1WDh3xcoZJQ-ffSR3C2pC6iapg55gjeoKkofQycdMj6jOFTP67TbDM59ccssrBzWDBFTDVw",
        "remove": "AB9zfpIXAbqkRwtLKF03LyEMGq6zEIyu392bKQuqJp6RbrQ4OM45D1FpKfjWda1tsNiNB3cTCgO2jNtf0ZowM5sNYarOHlIaYw"
      }
    },
    // ... (repeat for other tracks)
  ],
  "other_versions": [
    {
      "title": "The Marshall Mathers",
      "year": "Eminem",
      "browseId": "MPREb_oEb8m0Q0dMp",
      "thumbnails": [
        {
          "url": "https://lh3.googleusercontent.com/6pcEou_MeEaXQaTBpENV1a-_va7DjxquZW4ZtNVvxvtgr3GkfjhBskFTb6-eCotYN2rPiQSu1726f_Yc=w226-h226-s-l90-rj",
          "width": 226,
          "height": 226
        },
        {
          "url": "https://lh3.googleusercontent.com/6pcEou_MeEaXQaTBpENV1a-_va7DjxquZW4ZtNVvxvtgr3GkfjhBskFTb6-eCotYN2rPiQSu1726f_Yc=w544-h544-s-l90-rj",
          "width": 544,
          "height": 544
        }
      ],
      "isExplicit": false
    }
  ],
  "duration_seconds": 4345
}


  */

  // chatgpt write me a function for getting songs from album
  // get songs from album
  Future<Map<String, dynamic>> fetchAlbumData(String browseId) async {
    String api_url = 'http://192.168.165.35:5000/get_songs_from_album';
    final response = await http.post(
      Uri.parse(api_url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'browse_id': browseId}),
    );

    if (response.statusCode == 200) {
      // If the server returns an OK response, parse the data
      Map<String, dynamic> albumData = json.decode(response.body);
      // List<dynamic> songs = albumData['tracks'] ?? [];
      print('\naaaaaaaaaaaaaaallllllllllllllll\n');
      print(albumData);
      return albumData;
    } else {
      // If the server did not return a 200 OK response, throw an exception
      throw Exception('Failed to load data');
    }
  }
}
