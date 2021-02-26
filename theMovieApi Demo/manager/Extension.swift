//
//  Extension.swift
//  theMovieApi Demo
//
//  Created by Mustafa MEDENi on 26.02.2021.
//

import Foundation
import UIKit


extension Optional where Wrapped == String {
  var def: String {
    return self ?? ""
  }
}

extension UIViewController{
    /// Present
    ///
    /// - Parameters:
    ///   - title: Title string of alert controller
    ///   - message: Message string of alert controller
    ///   - cancelTitle: Cancel button title string
    ///   - defaultTitle: Default button title string
    ///   - defaultAction: Default action
    ///   - style: alert or sheet
    func presentSingleActionAlert(title: String? = "", message: String, defaultActionTitle: String? = "OK") {
        let alertAction: UIAlertController = UIAlertController(title: title,
                                                               message: message,
                                                               preferredStyle: .alert)
        let defaultAction = UIAlertAction.init(title: defaultActionTitle, style: .default) { _ in
            alertAction.dismiss(animated: true, completion: nil)
        }
        alertAction.addAction(defaultAction)
        self.present(alertAction, animated: true, completion: nil)
    }
}
