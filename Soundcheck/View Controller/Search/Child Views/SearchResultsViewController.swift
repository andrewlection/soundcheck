//
//  SearchResultsViewController.swift
//  Soundcheck
//
//  Created by Andrew Lection on 3/31/19.
//  Copyright © 2019 Andrew Lection. All rights reserved.
//

import UIKit

protocol SearchResultsDelegate: class {
    func didSelectSearchResult(_ setlist: Setlist)
    func didSelectNewSearch()
}

final class SearchResultsViewController: UIViewController {

    weak var delegate: SearchResultsDelegate?

    @IBOutlet weak private var tableView: UITableView!
    
    private let setlists: [Setlist]
    
    init(setlists: [Setlist]) {
        self.setlists = setlists
        super.init(nibName: "SearchResultsViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }
    
    // MARK: - UITableView
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.TableViewCell.searchResultCell)
    }
    
    // MARK: - Actions
    @IBAction func didSelectNewSearch(_ sender: Any) {
        delegate?.didSelectNewSearch()
    }
}

extension SearchResultsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let setlist = setlists[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCell.searchResultCell, for: indexPath)
        cell.textLabel?.text = "\(setlist.venue.name), \(setlist.eventDate)"
        return cell
    }
}

extension SearchResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectSearchResult(setlists[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}
