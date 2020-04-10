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
    var colorSelected: UIColor = UIColor(named: "Grayscale11")!
    private var imageView: NTMonitoredImageView!
    private var rectangleView: UIView!
    private var markerSquare: UIView!
    
    private var markerTopAnchor: NSLayoutConstraint!
    private var markerLeadingAnchor: NSLayoutConstraint!
    private var markerHeightAnchor: NSLayoutConstraint!
    private var markerWidthAnchor: NSLayoutConstraint!
    
    private var isDarkMode: Bool {
        return traitCollection.userInterfaceStyle == .dark
    }
    
    private var boxHeight: CGFloat {
        if imageView.bounds.height != 0 {
            return imageView.bounds.height / 10
        }
        
        return 10
    }
    
    private var boxWidth: CGFloat {
        if imageView.bounds.width != 0 {
            return imageView.bounds.width / 12
        }
        
        return 10
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(color: UIColor) {
        super.init(frame: .zero)
        colorSelected = color
        configure()
    }
    
    override func didMoveToSuperview() {
        if let superview = superview {
            NSLayoutConstraint.activate([
                topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor),
                bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor),
                leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor),
                trailingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.trailingAnchor)
            ])
        }
        
        configureMarkerSquare()
    }
    
    private func configure() {
        backgroundColor = .clear
        isOpaque = false
        
        configureRectangleView()
        configureImageView()
    }
    
    private func configureRectangleView() {
        rectangleView = UIView()
        rectangleView.translatesAutoresizingMaskIntoConstraints = false
        rectangleView.layer.cornerRadius = 10
        rectangleView.layer.borderWidth = 5
        rectangleView.layer.borderColor = UIColor.systemGray5.withAlphaComponent(0.8).cgColor
        rectangleView.clipsToBounds = true
        addSubview(rectangleView)
        
        let horizontalWidthAnchor = rectangleView.widthAnchor.constraint(equalToConstant: 342)
        horizontalWidthAnchor.priority = UILayoutPriority(500.0)
        
        let verticalHeightAnchor = rectangleView.heightAnchor.constraint(equalToConstant: 295)
        verticalHeightAnchor.priority = UILayoutPriority(500.0)
        
        NSLayoutConstraint.activate([
            rectangleView.topAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.topAnchor,
                                               constant: 10),
            rectangleView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                                  constant: -10),
            rectangleView.leadingAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.leadingAnchor,
                                                   constant: 10),
            rectangleView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,
                                                    constant: -10),
            horizontalWidthAnchor,
            verticalHeightAnchor
        ])
    }
    
    private func configureImageView() {
        imageView = NTMonitoredImageView()
        imageView.delegate = self
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        rectangleView.addSubview(imageView)
        
        createColorImage()
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: rectangleView.topAnchor, constant: 5),
            imageView.bottomAnchor.constraint(equalTo: rectangleView.bottomAnchor,
                                           constant: -5),
            imageView.trailingAnchor.constraint(equalTo: rectangleView.trailingAnchor,
                                             constant: -5),
            imageView.leadingAnchor.constraint(equalTo: rectangleView.leadingAnchor,
                                               constant: 5),
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
                        color = UIColor(forName: ColorConstants.grayscale, shade: position)
                    } else {
                        let position = isDarkMode ? 9 - row : row - 1
                        let colorConstant = ColorConstants.array[column]
                        color = UIColor(forName: colorConstant, shade: position)
                    }
                    ctx.cgContext.setFillColor(color.cgColor)
                    ctx.cgContext.fill(CGRect(x: column * 10, y: row * 10,
                                              width: 10, height: 10))
                }
            }
        }
        
        imageView.image = img
        
    }
    
    private func configureMarkerSquare() {
        markerSquare = UIView()
        markerSquare.translatesAutoresizingMaskIntoConstraints = false
        markerSquare.layer.borderWidth = 2
        markerSquare.layer.borderColor = UIColor.systemGray6.cgColor
        imageView.addSubview(markerSquare)
        
        markerLeadingAnchor = markerSquare.leadingAnchor.constraint(equalTo: imageView.leadingAnchor,
                                                                    constant: 110)
        markerTopAnchor = markerSquare.topAnchor.constraint(equalTo: imageView.topAnchor,
                                                            constant: 0)
        markerWidthAnchor = markerSquare.widthAnchor.constraint(equalToConstant: 10)
        markerHeightAnchor = markerSquare.heightAnchor.constraint(equalToConstant: 10)
        
        NSLayoutConstraint.activate([
            markerLeadingAnchor,
            markerTopAnchor,
            markerWidthAnchor,
            markerHeightAnchor
        ])
        
        moveSquareToColor()
    }
    
    private func moveSquareToColor() {
        let location: CGRect
        if let name = colorSelected.name {
            if name.hasPrefix(ColorConstants.grayscale) {
                guard let numberCharacter = name.last else {
                    fatalError("Unable to find last character")
                }
                guard var number = Int(String(numberCharacter)) else {
                    fatalError("Character at the end of selectedColor.name is not a number")
                }
                if number == 0 || number == 1 {
                    let nameWithoutLastCharacter = String(name.dropLast())
                    if let lastCharacter = nameWithoutLastCharacter.last {
                        if let _ = Int(String(lastCharacter)) {
                            number += 10
                        }
                    }
                }
                
                let position = isDarkMode ? 11 - number : number
                location = CGRect(x: CGFloat(position) * boxWidth, y: CGFloat(0) * boxHeight,
                                  width: boxWidth, height: boxHeight)
            } else {
                let colorName = String(name.dropLast())
                guard let numberCharacter = name.last else {
                    fatalError("Unable to find last character")
                }
                guard let colorNumber = Int(String(numberCharacter)) else {
                    fatalError("Character at the end of selectedColor.name is not a number")
                }
                let position = isDarkMode ? 10 - colorNumber : colorNumber + 1
                guard let index = ColorConstants.array.firstIndex(of: colorName) else {
                    fatalError("Color named: \(colorName) not found in color array")
                }
                
                location = CGRect(x: CGFloat(index) * boxWidth, y: CGFloat(position) * boxHeight,
                                  width: boxWidth, height: boxHeight)
            }
        } else {
            location = CGRect(x: CGFloat(11) * boxWidth, y: CGFloat(0) * boxHeight,
                              width: boxWidth, height: boxHeight)
        }
        
        moveSquareTo(location)
    }
    
    private func moveSquareTo(_ location: CGRect) {
        markerLeadingAnchor.constant = location.minX
        markerTopAnchor.constant = location.minY
        markerWidthAnchor.constant = location.width
        markerHeightAnchor.constant = location.height
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        let touchLocation = touch.location(in: imageView)
        
        if imageView.bounds.contains(touchLocation) {
            touchInsideColorImage(at: touchLocation)
        } else {
            touchOutsideColorImage()
        }
        
    }
    
    private func touchInsideColorImage(at location: CGPoint) {
        let touchBoxX = Int(location.x/boxWidth)
        let touchBoxY = Int(location.y/boxHeight)
        if touchBoxY == 0 {
            let position = isDarkMode ? 11 - touchBoxX : touchBoxX
            colorSelected = UIColor(forName: ColorConstants.grayscale, shade: position)
        } else {
            let position = isDarkMode ? 9 - touchBoxY : touchBoxY - 1
            colorSelected = UIColor(forName: ColorConstants.array[touchBoxX], shade: position)
        }
        moveSquareToColor()
        delegate?.colorPickerDidPickColor(colorSelected)
    }
    
    private func touchOutsideColorImage() {
        delegate?.colorPickerDidPickColor(colorSelected)
        removeFromSuperview()
    }
    
}

extension NTColorPickerView: NTMonitoredImageViewDelegate {
    func didSetBounds(_ bounds: CGRect, oldValue: CGRect) {
        moveSquareToColor()
    }
}
