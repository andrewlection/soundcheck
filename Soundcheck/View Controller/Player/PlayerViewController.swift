//
//  PlayerViewController.swift
//  Soundcheck
//
//  Created by Andrew Lection on 4/1/19.
//  Copyright © 2019 Andrew Lection. All rights reserved.
//

import AVFoundation
import UIKit

/// A audio player view that can play a list of remote or local audio URLs.
class PlayerViewController: UIViewController {

    @IBOutlet weak private var headerLabel: UILabel!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var detailLabel: UILabel!
    @IBOutlet weak private var progressView: UIProgressView!
    @IBOutlet weak private var playButton: UIButton!
    @IBOutlet weak private var closeButton: UIButton!
    
    private let playlist: Playlist
    private let playListSongs: [PlaylistSong]
    private var queuePlayer: PlaylistAudioPlayer!
    
    private let headerTitle: String?
    
    private var currentIndex: Int = 0
    
    // MARK: - Initialization
    init(playlist: Playlist, headerTitle: String? = nil) {
        self.playlist = playlist
        self.playListSongs = playlist.songsWithAudioUrls
        self.headerTitle = headerTitle
        super.init(nibName: Constants.ViewController.playerViewController, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(aDecoder:) not implemented")
    }

    // MARK: - Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
        setupAudioPlayer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let currentSong = playListSongs[currentIndex]
        animateInText(song: currentSong)
    }
    
    // MARK: - Setup
    private func initialSetup() {
        headerLabel.text = headerTitle
        titleLabel.alpha = 0.0
        progressView.progress = 0.0
    }
    
    private func animateInText(song: PlaylistSong) {
        UIView.animate(withDuration: 0.3, animations: {
            self.titleLabel.alpha = 0.0
            self.detailLabel.alpha = 0.0
        }) { completed in
            UIView.animate(withDuration: 1.0, animations: {
                self.titleLabel.text = song.name
                self.titleLabel.alpha = 1.0
                self.detailLabel.text = song.artistName
                self.detailLabel.alpha = 1.0
            })
       }
    }
    
    private func setupAudioPlayer() {
        queuePlayer = PlaylistAudioPlayer(songs: playListSongs)
        queuePlayer.delegate = self
    }
    
    // MARK: - Actions
    @IBAction private func didSelectPlayButton(_ sender: Any) {
        if (queuePlayer.isPlaying) {
            queuePlayer.pause()
            playButton.setImage(UIImage(named: Constants.Icon.play), for: .normal)
        } else {
            queuePlayer.play()
            playButton.setImage(UIImage(named: Constants.Icon.pause), for: .normal)
        }
    }
    
    @IBAction func didSelectCloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension PlayerViewController: QueueAudioPlayerDelegate {
    func progressChanged(value: Float) {
        progressView.progress = value
    }
    
    func didStartSongAtIndex(index: Int) {
        currentIndex = index
        animateInText(song: playListSongs[currentIndex])
    }
}
