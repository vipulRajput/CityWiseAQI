//
//  BaseViewController.swift
//  CityWiseAQI
//
//  Created by Vipul on 08/01/22.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    var viewModel: BaseViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13, *) {
            overrideUserInterfaceStyle = .light
        }
        
        initializeVM()
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    func initializeVM() {

    }
}

