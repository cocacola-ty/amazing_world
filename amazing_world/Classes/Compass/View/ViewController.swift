//
//  ViewController.swift
//  amazing_world
//
//  Created by 冯天宇 on 2023/6/16.
//

import UIKit
import CoreLocation
import SnapKit
import RxRelay
import RxSwift

class ViewController: UIViewController {
    
    // MARK: - Private Properties
    private let dialView = DialView()
    private let centerInfoView = UIView()
    private let infoLabel = UILabel()
    private let indicatorView = UIImageView(image: UIImage(named: "indicator"))
    private var listView: LocationInfoListView?

    private var viewModle = LocationInfoViewModel()
    private let bag = DisposeBag()
    
    private struct LayoutConfiguration {
        static let leftMarggin = 44.0
        static let centerCircleLenght = 120.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSubviews()
        viewModle.startRequest()
        addObservers()
    }
    
    fileprivate func loadSubviews() {
        let centerOffset = 80.0
        
        dialView.center = CGPoint(x: view.center.x, y: view.center.y - centerOffset)
        let dialViewLength = UIScreen.main.bounds.width - LayoutConfiguration.leftMarggin - LayoutConfiguration.leftMarggin
        dialView.bounds = CGRect(x: 0, y: 0, width: dialViewLength, height: dialViewLength)
        view.addSubview(dialView)
        
        centerInfoView.layer.cornerRadius = LayoutConfiguration.centerCircleLenght / 2.0
        centerInfoView.layer.shadowColor = UIColor.gray.cgColor
        centerInfoView.layer.shadowOffset = CGSize(width: 2, height: 2)
        centerInfoView.layer.shadowOpacity = 0.6
        centerInfoView.backgroundColor = .white
        view.addSubview(centerInfoView)
        
        centerInfoView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-centerOffset)
            make.height.width.equalTo(LayoutConfiguration.centerCircleLenght)
        }
        
        infoLabel.text = "0°"
        infoLabel.font = .boldSystemFont(ofSize: 24.0)
        view.addSubview(infoLabel)
        infoLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-centerOffset)
        }
        
        view.addSubview(indicatorView)
        indicatorView.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(centerInfoView.snp.top).offset(-6)
        }
     
        loadListView()
    }
    
    private func loadListView() {
        let bottomPadding = 128.0
        
        let altitudeCell = LocationInfoCell.LocationInfoModel(iconName: "altitude_icon", name: "海拔", key: LocationInfoType.altitude.rawValue)
        let locationCell = LocationInfoCell.LocationInfoModel(iconName: "location_icon", name: "位置", key: LocationInfoType.location.rawValue)
        let latCell = LocationInfoCell.LocationInfoModel(iconName: "earth_icon", name: "经纬度", key: LocationInfoType.lat.rawValue)
        let modelList = [altitudeCell, locationCell, latCell]
        let listView = LocationInfoListView(cellModels: modelList)
        let listViewHeight = LocationInfoListView.cellHeight * CGFloat(modelList.count)
        
        listView.frame = CGRect(x: LocationInfoListView.margin, y: view.bounds.height - listViewHeight - bottomPadding, width: LocationInfoListView.listViewWidth, height: listViewHeight)
        listView.layer.borderColor = UIConfig.lineColor.cgColor
        listView.layer.borderWidth = 0.5
        listView.layer.cornerRadius = 8.0
        listView.layer.masksToBounds = true
        self.listView = listView
        view.addSubview(listView)
    }

    private func addObservers() {
        viewModle.angleChangedRelay.subscribe { [weak self] value in
            self?.rotateDialView(angle: value)
            self?.updateContent(angle: value)
        }.disposed(by: bag)
        
        viewModle.altitudeRelay.subscribe { [weak self] value in
            self?.refreshAltitude(altitude: value)
        }.disposed(by: bag)
        
        viewModle.coordinateRelay.subscribe { [weak self] value in
            self?.refreshCoordinate(value: value)
        }.disposed(by: bag)
        
        viewModle.addressRelay.subscribe { [weak self] address in
            self?.refreshAddress(value: address)
        }.disposed(by: bag)
    }
    
    private func rotateDialView(angle: Double) {
        let rotationAngle = (angle / 360.0) * (CGFloat.pi * 2)
        UIView.animate(withDuration: 0.1) {
            self.dialView.layer.transform = CATransform3DMakeRotation(rotationAngle, 0, 0, -1)
        }
    }
    
    private func updateContent(angle: Double) {
        infoLabel.text = "\(Int(angle))°"
    }
    
    private func refreshAltitude(altitude: Double) {
        guard let altitudeView = self.listView?.subviews.first(where: { ($0 as? LocationInfoCell)?.model.key == LocationInfoType.altitude.rawValue }) as? LocationInfoCell else {
            return
        }
        
        let altitudeValue = "\(Int(altitude))m"
        altitudeView.setValue(value: altitudeValue)
    }
    
    private func refreshCoordinate(value: (String, String)) {
        guard let altitudeView = self.listView?.subviews.first(where: { ($0 as? LocationInfoCell)?.model.key == LocationInfoType.lat.rawValue }) as? LocationInfoCell else {
            return
        }
        
        let content = "\(value.0), \(value.1)"
        altitudeView.setValue(value: content)
    }
    
    private func refreshAddress(value: String) {
        guard let altitudeView = self.listView?.subviews.first(where: { ($0 as? LocationInfoCell)?.model.key == LocationInfoType.location.rawValue }) as? LocationInfoCell else {
            return
        }
        
        altitudeView.setValue(value: value)
    }
}

