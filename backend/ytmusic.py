from flask import Flask, jsonify
from flask_cors import CORS
from flask import Flask, request, jsonify

from ytmusicapi import YTMusic

app = Flask(__name__)
CORS(app)  # Enable CORS for all routes
yt = YTMusic('backend/oauth.json')

@app.route('/get_music', methods=['POST'])
def get_music():
    data = request.get_json()
    search_term = data['search_term']
    data = yt.search(search_term, filter="songs")
    print(data)
    return jsonify(data)

@app.route('/get_albums', methods=['POST'])
def get_albums():
    data = request.get_json()
    search_term = data['search_term']
    print('search_term')
    print(search_term)
    data = yt.search(search_term, filter="albums")
    print(data)
    return jsonify(data)

# get songs in an album
@app.route('/get_songs_from_album', methods=['POST'])
def get_songs_from_album():
    data = request.get_json()
    browse_id = data['browse_id']
    data = yt.get_album(browse_id)
    print(data)
    return jsonify(data)

# Add more endpoints as needed

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
