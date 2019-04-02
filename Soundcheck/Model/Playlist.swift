//
//  Playlist.swift
//  Soundcheck
//
//  Created by Andrew Lection on 3/31/19.
//  Copyright © 2019 Andrew Lection. All rights reserved.
//

import Foundation

class Playlist {
    private(set) var songs = [PlaylistSong]()
    
    func addSongs(_ songs: [PlaylistSong]) {
        self.songs += songs
    }
    
    var songsWithAudioUrls: [PlaylistSong] {
        return songs.filter { song in
            guard let audioUrlString = song.audioUrl,
                  let _ = URL(string: audioUrlString) else {
                return false
            }
            return true
        }
    }
}
