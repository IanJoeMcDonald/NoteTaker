//
//  NTColorPickerView.swift
//  NoteTaker
//
//  Created by Ian McDonald on 06/04/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import UIKit

class NTColorPickerView: UIView {
    
    var delegate: NTColorPickerDelegate?
    var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 10
        layer.borderWidth = 5
        layer.borderColor = UIColor.systemGray2.cgColor
        clipsToBounds = true
        
        backgroundColor = .clear
        isOpaque = false
        
        configureImageView()
    }
    
    private func configureImageView() {
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        createColorImage()
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leftAnchor.constraint(equalTo: leftAnchor),
            imageView.rightAnchor.constraint(equalTo: rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func createColorImage() {
        let isDarkMode = traitCollection.userInterfaceStyle == .dark
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 120, height: 100))
        let img = renderer.image { ctx in
            for row in 0 ..< 10 {
                for column in 0 ..< 12 {
                    let color: UIColor
                    if row == 0 {
                        let position = isDarkMode ? 11 - column : column
                        guard let localColor = UIColor(named: "Grayscale\(position)") else {
                            fatalError("Attempted to create invalid color")
                        }
                        color = localColor
                    } else {
                        let position = isDarkMode ? 9 - row : row - 1
                        let colorConstant = ColorConstants.array[column]
                        guard let localColor = UIColor(named: colorConstant + String(position))
                            else { fatalError("Attempted to create invalid color") }
                        color = localColor
                    }
                    ctx.cgContext.setFillColor(color.cgColor)
                    ctx.cgContext.fill(CGRect(x: column * 10, y: row * 10,
                                              width: 10, height: 10))
                }
            }
        }
        
        imageView.image = img
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let isDarkMode = traitCollection.userInterfaceStyle == .dark
        let touch = touches.first! as UITouch
        let boxHeight = imageView.bounds.height / 10
        let boxWidth = imageView.bounds.width / 12
        let touchLocation = touch.location(in: imageView)
        
        let touchBoxX = Int(touchLocation.x/boxWidth)
        let touchBoxY = Int(touchLocation.y/boxHeight)
        let colorSelected: UIColor
        if touchBoxY == 0 {
            let position = isDarkMode ? 11 - touchBoxX : touchBoxX
            let colorName = "Grayscale\(position)"
            colorSelected = UIColor(named: colorName)!
        } else {
            let position = isDarkMode ? 9 - touchBoxY : touchBoxY - 1
            let colorName = "\(ColorConstants.array[touchBoxX])\(position)"
            colorSelected = UIColor(named: colorName)!
        }
        delegate?.colorPickerDidPickColor(colorSelected)
        delegate?.dismiss(self)
    }
}
