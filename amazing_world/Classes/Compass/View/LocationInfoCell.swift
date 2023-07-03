//
//  LocationInfoCell.swift
//  amazing_world
//
//  Created by 冯天宇 on 2023/6/28.
//

import UIKit

enum LocationInfoType: String {
    case altitude = "altitude"
    case location = "location"
    case lat = "lat"
}

class LocationInfoCell: UIView {
    
    struct LocationInfoModel {
        let iconName: String
        let name: String
        let key: String
    }
    
    // MARK: - Output Properties
    
    // MARK: - Input Properties
    var model: LocationInfoModel
    
    // MARK: - Private Properties
    private let line = UIView()
    private let icon = UIImageView()
    private let nameLabel = UILabel()
    private let valueLabel = UILabel()
    
    // MARK: - Init Method
    
    init(model: LocationInfoModel) {
        self.model = model
        super.init(frame: .zero)
        loadSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Method
    private func loadSubviews() {
        line.backgroundColor = UIConfig.lineColor
        addSubview(line)
        
        icon.image = UIImage(named: model.iconName)
        addSubview(icon)
        
        nameLabel.text = model.name
        nameLabel.font = .systemFont(ofSize: 12.0)
        nameLabel.textColor = UIConfig.textColor
        addSubview(nameLabel)
        
        valueLabel.font = .boldSystemFont(ofSize: 12.0)
        valueLabel.textColor = UIConfig.textColor
        addSubview(valueLabel)
    }
    
    private func makeConstraints() {
        
        let padding: CGFloat = 16.0
        let nameLabelSpacing = 8.0
        
        line.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
            make.left.equalToSuperview()
        }
        icon.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.left.equalToSuperview().offset(padding)
            make.centerY.equalToSuperview()
        }
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(icon.snp.right).offset(nameLabelSpacing)
            make.centerY.equalToSuperview()
        }
        valueLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-padding)
            make.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Public Method
    
    func setValue(value: String) {
        self.valueLabel.text = value
    }
}
