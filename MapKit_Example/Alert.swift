//
//  Alert.swift
//  MapKit_Example
//
//  Created by Ayaan Ruhi on 9/29/18.
//  Copyright © 2018 parth. All rights reserved.
//

import Foundation
import UIKit

struct Alert {
    static func showAlert(on vc: UIViewController,with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true)
    }
}
