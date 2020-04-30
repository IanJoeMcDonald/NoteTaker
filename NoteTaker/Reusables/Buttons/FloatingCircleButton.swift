//
//  FloatingCircleButton.swift
//  NoteTaker
//
//  Created by Ian McDonald on 30/04/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import UIKit

class FloatingCircleButton: UIButton {

    private var shadowLayer: CAShapeLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            setupShadowLayer()
        } else {
            shadowLayer.removeFromSuperlayer()
            shadowLayer = nil
            setupShadowLayer()
        }
    }
    
    private func configure() {
        layer.cornerRadius = bounds.height / 2
        backgroundColor = .clear
        setTitleColor(.white, for: .normal)
    }
    
    private func setupShadowLayer() {
        shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: bounds,
                                        cornerRadius: frame.height/2).cgPath
        
        shadowLayer.fillColor = UIColor.systemBlue.cgColor
        shadowLayer.shadowColor = UIColor.darkGray.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 3, height: 3)
        shadowLayer.shadowOpacity = 0.7
        shadowLayer.shadowRadius = 4
        layer.insertSublayer(shadowLayer, at: 0)
    }

}
