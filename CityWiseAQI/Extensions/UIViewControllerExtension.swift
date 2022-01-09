//
//  UIViewControllerExtension.swift
//  CityWiseAQI
//
//  Created by Vipul on 09/01/22.
//

import Foundation
import UIKit

extension UIViewController {
    
    func presentRetryAlert(with title: String, message: String, onRetryTapped: (()-> Void)?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let retryAction = UIAlertAction(title: "Retry", style: .default) { action in
            onRetryTapped?()
        }
        alertController.addAction(retryAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
