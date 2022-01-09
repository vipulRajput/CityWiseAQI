//
//  CityListVC.swift
//  CityWiseAQI
//
//  Created by Vipul on 07/01/22.
//

import UIKit

class CityListVC: BaseViewController {

    @IBOutlet weak var cityTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initialSetup()
    }
    
    override func initializeVM() {
        
        let contentProvider = CityListContentProvider.init(tableDataModel: TableViewModel.init())
        self.cityTableView.dataSource = contentProvider
        self.cityTableView.delegate = contentProvider
        self.viewModel = CityListViewModel.init(contentProvider: contentProvider)
        contentProvider.viewModel = viewModel as? CityListViewModel
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension CityListVC {
    
    private func initialSetup() {
        
        self.title = "All Cities"
        self.cityTableView.register(CityAqiTableCell.self)
        self.cityTableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        self.setupVM()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc private func handleNotification(notification: Notification) {
        
        if notification.name == UIApplication.didEnterBackgroundNotification {
            (self.viewModel as? CityListViewModel)?.disconnectFromWebsocket()
        } else {
            (self.viewModel as? CityListViewModel)?.connectToWebsocket()
        }
    }
    
    private func setupVM() {
        
        guard let vm = self.viewModel as? CityListViewModel else { return }
        vm.dataSourceUpdated = { [weak self] in
            self?.cityTableView.reloadData()
        }
        vm.userTappedOnCity = { [weak self] selectedCity in
            guard let detailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CityAqiDetailsVC") as? CityAqiDetailsVC else {
                return
            }
            detailsVC.viewModel = CityAqiDetailsViewModel.init(city: selectedCity)
            vm.cityAqiDetailsDelegate = detailsVC.viewModel as? CityAqiDetailsDelegate
            self?.navigationController?.pushViewController(detailsVC, animated: true)
        }
        vm.handleError = { [weak self] errorMsg in
            self?.presentRetryAlert(with: "", message: errorMsg, onRetryTapped: {
                vm.connectToWebsocket()
            })
        }
        vm.websocketSetup()
    }
}
