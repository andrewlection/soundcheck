//
//  SearchParentViewController.swift
//  Soundcheck
//
//  Created by Andrew Lection on 3/30/19.
//  Copyright © 2019 Andrew Lection. All rights reserved.
//

import UIKit

final class SearchParentViewController: UIPageViewController {

    // MARK: - Properties
    private let setlistApi = SetlistFM()

    private lazy var searchQueryViewController: SearchQueryViewController = {
        let viewController = SearchQueryViewController()
        viewController.delegate = self
        return viewController
    }()
    
    private lazy var searchLoadingViewController: SearchLoadingViewController = {
        return SearchLoadingViewController()
    }()
    
    // MARK: - Initialization
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: options)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        navigateToViewController(searchQueryViewController)
    }
    
    // MARK: - Setup
    private func setupNavigationBar() {
        title = "Soundcheck"
    }
    
    // MARK: - UIPageViewController
    private func navigateToViewController(_ viewController: UIViewController) {
        setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
    }
    
    private func showQueryView() {
        navigateToViewController(searchQueryViewController)
    }
    
    private func showLoadingView() {
        navigateToViewController(searchLoadingViewController)
    }
    
    private func showResults(_ setlists: [Setlist]) {
        let searchResultsViewController = SearchResultsViewController(setlists: setlists)
        searchResultsViewController.delegate = self
        navigateToViewController(searchResultsViewController)
    }
    
    // MARK: - Helper
    private func playlistFrom(_ setlist: Setlist) -> Playlist {
        let playlist = Playlist()
        setlist.sets.sets.forEach { set in
            let playlistSongs = set.song.filter { !$0.isCover && !$0.isTape }.map { PlaylistSong(artistName: setlist.artist.name, name: $0.name) }
            playlist.addSongs(playlistSongs)
        }
        return playlist
    }
    
    private func headerTitle(_ setlist: Setlist) -> String {
        return "\(setlist.venue.name)\n\(setlist.venue.city.name)\n\(setlist.eventDate)"
    }
}

extension SearchParentViewController: SearchQueryDelegate {
    func didEnterSearchText(_ searchText: String) {
        searchSetlistsForArtist(searchText)
        navigateToViewController(searchLoadingViewController)
    }
    
    // MARK: - setlistFM - (this method could be abstracted in some way so the Search Results flow can be reused)
    private func searchSetlistsForArtist(_ artist: String) {
        setlistApi.setlistsFor(artistName: artist) { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presentRetryAlert(withTitle: NSLocalizedString("Error", comment: "Title for error alert."), message: error.localizedDescription, completion: { shouldRetry in
                        if shouldRetry {
                            self.searchSetlistsForArtist(artist)
                        }
                    })
                }
            case .success(let setlists):
                DispatchQueue.main.async {
                    self.showResults(setlists)
                }
            }
        }
    }
}

extension SearchParentViewController: SearchResultsDelegate {
    func didSelectSearchResult(_ setlist: Setlist) {
        DispatchQueue.main.async {
            self.playPlaylistFrom(setlist)
        }
    }
    
    func didSelectNewSearch() {
        DispatchQueue.main.async {
            self.showQueryView()
        }
    }
    
    private func playPlaylistFrom(_ setlist: Setlist) {
        let playlist = playlistFrom(setlist)
        
        // If playlist is empty
        guard playlist.songs.count > 0 else {
            presentSimpleAlert(withTitle: "This setlist is empty!", message: "Please select a different setlist.")
            return
        }
        
        // Present player view
        let playlistManager = PlaylistManager(playlist: playlist)
        playlistManager.fetchPreviewUrls {
            // Start player
            DispatchQueue.main.async {
                let player = PlayerViewController(playlist: playlistManager.playlist, headerTitle: self.headerTitle(setlist))
                self.present(player, animated: true, completion: nil)
            }
        }
    }
}
