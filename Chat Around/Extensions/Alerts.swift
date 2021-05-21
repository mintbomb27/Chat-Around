//
//  Alerts.swift
//  Chat Around
//
//  Created by Alok N on 20/05/21.
//

import UIKit

extension UIViewController {
    func alertPrompt(message: String, title: String, prompt: String) -> () {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: prompt, style: UIAlertAction.Style.default))
        self.present(alert, animated: true)
    }
}
