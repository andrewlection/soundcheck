//
//  UIViewControllerExtension.swift
//  Soundcheck
//
//  Created by Andrew Lection on 3/31/19.
//  Copyright © 2019 Andrew Lection. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentRetryAlert(withTitle title: String, message: String, completion: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Retry?", comment: "Title for retry option"), style: .default, handler: { _ in
            completion(true)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Title for cancel option"), style: .cancel, handler: { _ in
            completion(false)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentSimpleAlert(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Title for retry option"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
