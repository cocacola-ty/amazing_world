//
//  LocationInfoListView.swift
//  amazing_world
//
//  Created by 冯天宇 on 2023/6/28.
//

import UIKit

class LocationInfoListView: UIView {
    
    // MARK: - Output Properties
    static let cellHeight = 44.0
    static let margin = 38.0
    static let listViewWidth = UIScreen.main.bounds.width - margin * 2
    
    // MARK: - Input Properties
    
    // MARK: - Private Properties
    private var cellModels: [LocationInfoCell.LocationInfoModel]
    
    // MARK: - Init Method
    
    init(cellModels: [LocationInfoCell.LocationInfoModel]) {
        self.cellModels = cellModels
        super.init(frame: .zero)
        loadSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Method
    private func loadSubviews() {

        var index = 0.0
        
        cellModels.forEach { infoModle in
            let cell = LocationInfoCell(model: infoModle)
            let cellY = LocationInfoListView.cellHeight * index
            cell.frame = CGRect(x: 0, y: cellY, width: LocationInfoListView.listViewWidth, height: LocationInfoListView.cellHeight)
            addSubview(cell)
            
            index += 1
        }
    }
    
    // MARK: - Public Method
    
}
