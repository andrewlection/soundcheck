//
//  SearchViewController.swift
//  Soundcheck
//
//  Created by Andrew Lection on 3/30/19.
//  Copyright © 2019 Andrew Lection. All rights reserved.
//

import UIKit

protocol SearchQueryDelegate: class {
    func didEnterSearchText(_ searchText: String)
}

final class SearchQueryViewController: UIViewController {

    weak var delegate: SearchQueryDelegate?

    // Views
    @IBOutlet private weak var instructionLabel: UILabel!
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var instructionLabelYConstraint: NSLayoutConstraint!
    
    private var didAnimateInTextField = false
    
    // Data
    private let setlistFM = SetlistFM()
    private let placeholderTexts = [
        "Free Bird!",
        "Hello, Cleveland!",
        "We Will Rock You",
    ]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !didAnimateInTextField {
            animateInTextField()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        clearSearchText()
    }
    
    // MARK: - Initial Setup
    private func initialSetup() {
        instructionLabel.alpha = 0.0
        searchTextField.alpha = 0.0
        searchTextField.delegate = self
        searchTextField.placeholder = placeholderText
    }
    
    private func clearSearchText() {
        searchTextField.text = nil
    }
    
    // MARK: - Animations
    private func animateInTextField() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            let yDelta = self.searchTextField.frame.origin.y - self.instructionLabel.frame.origin.y
            self.instructionLabelYConstraint.constant += yDelta
            self.instructionLabel.alpha = 1.0
            self.searchTextField.alpha = 1.0
            self.view.layoutIfNeeded()
        }, completion: { completed in self.didAnimateInTextField = true })
    }
    
    // MARK: - Helpers
    private var placeholderText: String {
        return placeholderTexts[Int.random(in: 0..<placeholderTexts.count)]
    }
}

extension SearchQueryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let queryText = textField.text {
            delegate?.didEnterSearchText(queryText)
        }
        return true
    }
}

