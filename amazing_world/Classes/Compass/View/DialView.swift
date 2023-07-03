//
//  DialView.swift
//  amazing_world
//
//  Created by 冯天宇 on 2023/6/16.
//

import UIKit

class DialView: UIView {

    let detailLayer = CAReplicatorLayer()
    let highlightLayer = CAReplicatorLayer()
    
    let northLabel = UILabel()
    let southLabel = UILabel()
    let eastLabel = UILabel()
    let westLabel = UILabel()
    

    override var bounds: CGRect {
        didSet {
            loadSubviews()
        }
    }
    
    // MARK: - Init Method
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Method
    
    private func loadSubviews() {

        detailLayer.removeFromSuperlayer()
        highlightLayer.removeFromSuperlayer()
            
        let itemLayer = CALayer()
        
        let itemWidth: CGFloat = 4.0
        let itemHeight: CGFloat = 20.0
        
        itemLayer.bounds = CGRect(x: 0, y: 0, width: itemWidth, height: itemHeight)
        itemLayer.anchorPoint = CGPoint(x: 0.5, y: 0)
        itemLayer.position = CGPoint(x: frame.width / 2.0, y: 0)
        itemLayer.cornerRadius = itemWidth / 2.0
        itemLayer.backgroundColor = UIColor(red: 226.0/255.0, green: 226.0/255.0, blue: 226.0/255.0, alpha: 1).cgColor
        
        detailLayer.addSublayer(itemLayer)
        
        let itemCount = 24
        detailLayer.instanceCount = itemCount
        let angle = CGFloat(2 * Double.pi) / CGFloat(itemCount)
        detailLayer.instanceTransform = CATransform3DMakeRotation(angle, 0, 0, 1)
        
        detailLayer.bounds = bounds
        detailLayer.position =  CGPoint(x: frame.width/2.0, y: frame.height/2.0)
        layer.addSublayer(detailLayer)
        
        
        
        let highlightItemLayer = CALayer()
        
        highlightItemLayer.bounds = CGRect(x: 0, y: 0, width: itemWidth, height: itemHeight)
        highlightItemLayer.anchorPoint = CGPoint(x: 0.5, y: 0)
        highlightItemLayer.position = CGPoint(x: frame.width / 2.0, y: 0)
        highlightItemLayer.cornerRadius = itemWidth / 2.0
        highlightItemLayer.backgroundColor = UIColor.black.cgColor
        
        highlightLayer.addSublayer(highlightItemLayer)
        
        let instaceCount = 8
        highlightLayer.instanceCount = instaceCount
        let highlightLayerAngle = CGFloat(2 * Double.pi) / CGFloat(instaceCount)
        highlightLayer.instanceTransform = CATransform3DMakeRotation(highlightLayerAngle, 0, 0, 1)
        
        highlightLayer.bounds = bounds
        highlightLayer.position =  CGPoint(x: frame.width/2.0, y: frame.height/2.0)
        layer.addSublayer(highlightLayer)
        
        addSubview(northLabel)
        addSubview(southLabel)
        addSubview(eastLabel)
        addSubview(westLabel)
        
        northLabel.text = "N"
        southLabel.text = "S"
        westLabel.text = "W"
        eastLabel.text = "E"
        
        let labelList = [northLabel, southLabel, westLabel, eastLabel]
        labelList.forEach { label in
            label.textColor = .black
            label.font = .systemFont(ofSize: 20.0)
            label.sizeToFit()
        }
                
        let center = CGPoint(x: frame.width / 2.0, y: frame.height / 2.0)
        let labelSpacing = 20.0
        northLabel.layer.position = CGPoint(x: center.x, y: itemHeight + labelSpacing)
        southLabel.layer.position = CGPoint(x: center.x, y: frame.height - itemHeight - labelSpacing)
        westLabel.layer.position = CGPoint(x: itemHeight + labelSpacing, y: center.y)
        eastLabel.layer.position = CGPoint(x: frame.width - itemHeight - labelSpacing, y: center.y)
        
        
        
    }
    
}
