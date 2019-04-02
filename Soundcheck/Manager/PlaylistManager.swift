//
//  PlaylistManager.swift
//  Soundcheck
//
//  Created by Andrew Lection on 3/31/19.
//  Copyright © 2019 Andrew Lection. All rights reserved.
//

import Foundation

// Initialized with a Playlist object and loads additional media per a playlist song
class PlaylistManager {
    typealias VoidCompletionBlock = () -> ()

    // MARK: - Properties
    let playlist: Playlist
    private lazy var itunesApi: iTunesClient = {
        return iTunesClient()
    }()
    
    private let itunesDispatchGroup = DispatchGroup()
    
    // MARK: - Initialization
    init(playlist: Playlist) {
        self.playlist = playlist
    }
    
    // MARK: - Public
    func fetchPreviewUrls(completion: @escaping () -> ()) {
        playlist.songs.forEach({ song in
            itunesDispatchGroup.enter()
            fetchPreviewUrl(song: song) {
                self.itunesDispatchGroup.leave()
            }
        })
        
        itunesDispatchGroup.notify(queue: .main, execute: completion)
    }
    
    func songAt(index: Int) -> PlaylistSong? {
        return playlist.songs[index]
    }
    
    // MARK: - Private
    private func fetchPreviewUrl(song: PlaylistSong, completion: VoidCompletionBlock? = nil) {
        let searchText = searchTextFor(song)
        itunesApi.searchMusicFor(searchText) { result in
            switch result {
            case .failure(let error):
                debugPrint(error)
                completion?()
            case .success(let songs):
                if let itunesSong = songs.first {
                    song.audioUrl = itunesSong.previewUrl
                }
                completion?()
            }
        }
    }
    
    private func searchTextFor(_ song: PlaylistSong) -> String {
        return "\(song.artistName) \(song.name)"
    }
}
