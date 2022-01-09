//
//  CityListViewModel.swift
//  CityWiseAQI
//
//  Created by Vipul on 07/01/22.
//

import Foundation
import Starscream
import UIKit

protocol CityAqiDetailsDelegate: AnyObject {
    func updateCity(with aqi: AQI)
}

class CityListViewModel: BaseViewModel {
    
    var contentProvider: TableContentProvider
    var userTappedOnCity: ((City)-> Void)?
    var handleError: ((String)-> Void)?
    var isSocketConnected = false
    private var socket: WebSocket!
    var allCities = [City]()
    var selectedCity: City?
    var cityAqiDetailsDelegate: CityAqiDetailsDelegate?
    private let internalQueue = DispatchQueue(label: "com.cityListViewModelInternal.queue",
                                              qos: .default, attributes: .concurrent)
    
    init(contentProvider: TableContentProvider) {
        
        self.contentProvider = contentProvider
        super.init()
    }
    
    override func buildTableViewModels() {
        
        self.contentProvider.tableDataModel.removeAll()
        
        let sectionModel = SectionModel.init()
        for city in allCities {
            sectionModel.cellModels.append(CityAqiTableCellViewModel.init(city: city))
        }
        self.contentProvider.tableDataModel.add(sectionModel: sectionModel)
    }
    
    private func updateTableViewModels(with updatedAirQualityInfo: [AirQualityInfo]) {
        
        internalQueue.async(flags: .barrier) {
                    
            for airQualityInfo in updatedAirQualityInfo {
                            
                if let index = self.allCities.firstIndex(where: {$0.name == airQualityInfo.cityName}) {
                    
                    var currentCity = self.allCities[index]
                    if currentCity.past30SecAqiRecords.count > 25 { currentCity.past30SecAqiRecords.removeFirst() }
                    currentCity.updateCity(info: airQualityInfo)
                    
                    let differenceInSeconds = currentCity.past30SecAqiRecords.count <= 1 ? 30 :  Int(Date().timeIntervalSince(currentCity.past30SecAqiRecords.last!.recordTime))
                    if differenceInSeconds >= 30 {
                        currentCity.past30SecAqiRecords.append(AQI(info: airQualityInfo))
                    }
                    self.allCities[index] = currentCity
                } else {
                    var cityModel = City(info: airQualityInfo)
                    cityModel.past30SecAqiRecords.append(AQI(info: airQualityInfo))
                    self.allCities.append(cityModel)
                }
            }
            self.allCities.sort { $0.name < $1.name }
            
            DispatchQueue.main.async {
                    
                self.buildTableViewModels()
                self.dataSourceUpdated?()
                
                if let selectedCity = self.selectedCity,
                   let detailsDelegate = self.cityAqiDetailsDelegate,
                   let index = updatedAirQualityInfo.firstIndex(where: {$0.cityName == selectedCity.name}) {
                    
                    detailsDelegate.updateCity(with: AQI(info: updatedAirQualityInfo[index]))
                }
            }
        }
    }
    
    func didSelectRowAt(indexPath: IndexPath) {
        
        self.selectedCity = self.allCities[indexPath.row]
        self.userTappedOnCity?(self.allCities[indexPath.row])
    }
}

extension CityListViewModel {
    
    func websocketSetup() {
        
        let request = URLRequest(url: URL(string: Constants.serverURL)!)
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
    }
    
    func connectToWebsocket() {
        
        if !self.isSocketConnected {
            self.socket.connect()
        }
    }
    
    func disconnectFromWebsocket() {
        
        if self.isSocketConnected {
            self.socket.disconnect()
        }
    }
    
    private func handleReceived(dataStr: String) {
        
        guard let dataFromString = dataStr.data(using: String.Encoding.utf8, allowLossyConversion: false) else {
            return
        }
        
        do {
            let updatedAirQualityInfo = try JSONDecoder().decode([AirQualityInfo].self, from: dataFromString)
            self.updateTableViewModels(with: updatedAirQualityInfo)
        } catch let err {
            print("Error JSON: \(err.localizedDescription)")
        }
    }
}

extension CityListViewModel: WebSocketDelegate {
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        
        switch event {
        
        case .connected(let headers):
            isSocketConnected = true
            print("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            isSocketConnected = false
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            self.handleReceived(dataStr: string)
        case .cancelled:
            isSocketConnected = false
        case .error(let error):
            print(error.debugDescription)
            isSocketConnected = false
            self.handleError?("Error: \((error as? WSError)?.message ?? Constants.commonErrorMsg) :(")
        default:
            break
        }
    }
}

class CityListContentProvider: TableContentProvider {
    
    var viewModel: CityListViewModel?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel?.didSelectRowAt(indexPath: indexPath)
    }
}
