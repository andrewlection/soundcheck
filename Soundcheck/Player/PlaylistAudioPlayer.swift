//
//  PlaylistAudioPlayer.swift
//  Soundcheck
//
//  Created by Andrew Lection on 4/1/19.
//  Copyright © 2019 Andrew Lection. All rights reserved.
//

import AVFoundation
import Foundation

protocol QueueAudioPlayerDelegate: class {
    func progressChanged(value: Float)
    func didStartSongAtIndex(index: Int)
}

private struct PlayerCurrentItem {
    var firstPlayerCurrentIndex: Int = 0
    var secondPlayerCurrentIndex: Int = 1
}

private enum CurrentAudioPlayer {
    case first, second
}

/// A audio player class that plays through a list of PlayListSong sequentially and crossfades between song transitions.
class PlaylistAudioPlayer {
    weak var delegate: QueueAudioPlayerDelegate?
    
    private(set) var isPlaying: Bool = false

    // MARK: - Songs
    private let songs: [PlaylistSong]
    private var currentItemState = PlayerCurrentItem()
    
    // MARK: - First Audio Player
    private var firstAudioPlayer: AVPlayer?
    private var firstAudioPlayerItem: AVPlayerItem?
    private var firstAudioPlayerBoundaryObserver: Any?
    private var firstAudioPlayerPeriodicTimeObserver: Any?
    
    // MARK: - Second Audio Player
    private var secondAudioPlayer: AVPlayer?
    private var secondAudioPlayerItem: AVPlayerItem?
    private var secondAudioPlayerBoundaryObserver: Any?
    private var secondAudioPlayerPeriodicTimeObserver: Any?
    
    private var audioPlayerStatusObserver: NSKeyValueObservation?
    
    private let boundaryToFade: Double = 0.90
    private var currentAudioPlayer: CurrentAudioPlayer = .first
    private var needToSetupFirstAudioPlayer = false
    private var needToSetupSecondAudioPlayer = false
    
    
    // MARK: - Initialization
    init(songs: [PlaylistSong]) {
        self.songs = songs
    }
    
    // MARK: - Public
    func play() {
        if firstAudioPlayer == nil {
            setupAudioPlayers()
        }
        
        firstAudioPlayer?.play()
        isPlaying = true
    }
    
    func pause() {
        switch currentAudioPlayer {
        case .first:
            firstAudioPlayer?.pause()
        case .second:
            secondAudioPlayer?.pause()
        }
        isPlaying = false
    }
    
    func previous() {
        // Update current item state
    }
    
    func next() {
        // Update current item state
    }
    
    // MARK: - Audio Players
    private func setupAudioPlayers() {
        setupFirstAudioPlayer()
        setupSecondAudioPlayer()
    }
    
    private func setupFirstAudioPlayer() {
        guard let audioUrlString = songs[currentItemState.firstPlayerCurrentIndex].audioUrl,
              let audioUrl = URL(string: audioUrlString) else {
            return
        }
        
        firstAudioPlayerItem = AVPlayerItem(url: audioUrl)
        addStatusObserver(item: firstAudioPlayerItem!)
        firstAudioPlayer = AVPlayer(playerItem: firstAudioPlayerItem)
    }
    
    private func setupSecondAudioPlayer() {
        guard let audioUrlString = songs[currentItemState.secondPlayerCurrentIndex].audioUrl,
              let audioUrl = URL(string: audioUrlString) else {
            return
        }
        
        secondAudioPlayerItem = AVPlayerItem(url: audioUrl)
        addStatusObserver(item: secondAudioPlayerItem!)
        secondAudioPlayer = AVPlayer(playerItem: secondAudioPlayerItem)
    }
    
    private func startNextSong() {
        switch currentAudioPlayer {
        case .first:
            currentAudioPlayer = .second
            secondAudioPlayer?.play()
            delegate?.didStartSongAtIndex(index: currentItemState.secondPlayerCurrentIndex)
            
            let nextSongIndex = currentItemState.secondPlayerCurrentIndex + 1
            if nextSongIndex < songs.count {
                currentItemState.firstPlayerCurrentIndex = nextSongIndex
                needToSetupFirstAudioPlayer = true
            }
        case .second:
            currentAudioPlayer = .first
            firstAudioPlayer?.play()
            delegate?.didStartSongAtIndex(index: currentItemState.firstPlayerCurrentIndex)
            
            let nextSongIndex = currentItemState.firstPlayerCurrentIndex + 1
            if nextSongIndex < songs.count {
                currentItemState.secondPlayerCurrentIndex = nextSongIndex
                needToSetupSecondAudioPlayer = true
            }
        }
    }
    
    // MARK: - Observers
    private func addStatusObserver(item: AVPlayerItem) {
        audioPlayerStatusObserver = item.observe(\.status, options: [.new]) { [weak self] (playerItem, change) in
            guard let self = self else {
                return
            }
            switch playerItem.status {
            case .readyToPlay:
                self.addBoundaryTimeObserver()
                self.addPeriodicTimeObserver()
                self.addFadesFor(playerItem: self.firstAudioPlayerItem!)
                self.addFadesFor(playerItem: self.secondAudioPlayerItem!)
            case .failed:
                debugPrint("Failed")
            case .unknown:
                debugPrint("Unknown error")
            }
        }
    }
    
    private func addBoundaryTimeObserver() {
        guard let time = firstAudioPlayerItem?.duration else {
            return
        }
        
        let boundaryTime = CMTimeMultiplyByFloat64(time, multiplier: boundaryToFade)
        firstAudioPlayerBoundaryObserver = firstAudioPlayer?.addBoundaryTimeObserver(forTimes: [NSValue(time: boundaryTime)], queue: nil, using: { [weak self] in
            guard let self = self else {
                return
            }
            
            if self.currentAudioPlayer == .first {
                self.startNextSong()
            }
        })
        
        secondAudioPlayerBoundaryObserver = secondAudioPlayer?.addBoundaryTimeObserver(forTimes: [NSValue(time: boundaryTime)], queue: nil, using: { [weak self] in
            guard let self = self else {
                return
            }
            
            if self.currentAudioPlayer == .second {
                self.startNextSong()
            }
        })
    }
    
    private func addPeriodicTimeObserver() {
        let interval = CMTimeMakeWithSeconds(1/30.0, preferredTimescale: Int32(NSEC_PER_SEC))
        firstAudioPlayerPeriodicTimeObserver = firstAudioPlayer?.addPeriodicTimeObserver(forInterval: interval, queue: nil, using: { [weak self] time in
            guard let self = self,
                  let firstAudioPlayerItem = self.firstAudioPlayerItem else {
                return
            }
            
            if self.currentAudioPlayer == .first {
                let duration = CMTimeGetSeconds(firstAudioPlayerItem.duration)
                let currentTime = CMTimeGetSeconds(time)
                let progress = Float(currentTime/duration)
                if progress >= 0.5 && self.needToSetupSecondAudioPlayer {
                    self.needToSetupSecondAudioPlayer = false
                    self.setupSecondAudioPlayer()
                }
                self.delegate?.progressChanged(value: progress)
            }
        })
        
        secondAudioPlayerPeriodicTimeObserver = secondAudioPlayer?.addPeriodicTimeObserver(forInterval: interval, queue: nil, using: { [weak self] time in
            guard let self = self,
                  let secondAudioPlayerItem = self.secondAudioPlayerItem else {
                return
            }
            
            if self.currentAudioPlayer == .second {
                let duration = CMTimeGetSeconds(secondAudioPlayerItem.duration)
                let currentTime = CMTimeGetSeconds(time)
                let progress = Float(currentTime/duration)
                if progress >= 0.5 && self.needToSetupFirstAudioPlayer {
                    self.needToSetupFirstAudioPlayer = false
                    self.setupFirstAudioPlayer()
                }
                self.delegate?.progressChanged(value: progress)
            }
        })
    }
    
    // MARK: - Audio Fade
    private func addFadesFor(playerItem: AVPlayerItem) {
        var allAudioInputParams = [AVMutableAudioMixInputParameters]()
        let tracks = playerItem.asset.tracks(withMediaType: .audio)
        tracks.forEach({ track in
            let audioInputParms = AVMutableAudioMixInputParameters(track: track)
            let fadeInStartTime = CMTimeMakeWithSeconds(0.0, preferredTimescale: 1)
            let fadeDuration = CMTimeMakeWithSeconds(5.0, preferredTimescale: 1)
            let fadeOutStartTime = CMTimeMakeWithSeconds((CMTimeGetSeconds(playerItem.duration) * 0.85), preferredTimescale: 1)
            audioInputParms.setVolumeRamp(fromStartVolume: 0.0, toEndVolume: 1.0, timeRange: CMTimeRangeMake(start: fadeInStartTime, duration: fadeDuration))
            audioInputParms.setVolumeRamp(fromStartVolume: 1.0, toEndVolume: 0.0, timeRange: CMTimeRangeMake(start: fadeOutStartTime, duration: fadeDuration))
            allAudioInputParams.append(audioInputParms)
        })
    
        let audioMix = AVMutableAudioMix()
        audioMix.inputParameters = allAudioInputParams
        playerItem.audioMix = audioMix
    }
}
