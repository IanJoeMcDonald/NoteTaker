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
    private var imageView: UIImageView!
    private var rectangleView: UIView!
    private var markerSquare: UIView!
    private var colorSelected: UIColor = UIColor(named: "Grayscale11")!
    private var colorLocation: [Int] = [0,11]
    
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
        rectangleView.layer.borderColor = UIColor.systemGray2.cgColor
        rectangleView.clipsToBounds = true
        addSubview(rectangleView)
        
        let horizontalWidthAnchor = rectangleView.widthAnchor.constraint(equalToConstant: 342)
        horizontalWidthAnchor.priority = UILayoutPriority(500.0)
        
        NSLayoutConstraint.activate([
            rectangleView.heightAnchor.constraint(equalToConstant: 295),
            rectangleView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                                  constant: 0),
            rectangleView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,
                                                    constant: -10),
            rectangleView.leadingAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.leadingAnchor,
                                                   constant: 10),
            horizontalWidthAnchor
        ])
        
    }
    
    private func configureImageView() {
        imageView = UIImageView()
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
    
    private func configureMarkerSquare() {
        markerSquare = UIView()
        markerSquare.translatesAutoresizingMaskIntoConstraints = false
        markerSquare.layer.borderWidth = 2
        markerSquare.layer.borderColor = UIColor.systemGray2.cgColor
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
        let location = CGRect(x: CGFloat(colorLocation[1]) * boxWidth,
                              y: CGFloat(colorLocation[0]) * boxHeight,
                              width: boxWidth, height: boxHeight)
        
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
            print("touch inside")
            touchInsideColorImage(at: touchLocation)
        } else {
            print("touch outside")
            touchOutsideColorImage()
        }
        
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        moveSquareToColor()
    }
    
    private func touchInsideColorImage(at location: CGPoint) {
        let touchBoxX = Int(location.x/boxWidth)
        let touchBoxY = Int(location.y/boxHeight)
        if touchBoxY == 0 {
            let position = isDarkMode ? 11 - touchBoxX : touchBoxX
            let colorName = "Grayscale\(position)"
            guard let color = UIColor(named: colorName) else {
                fatalError("Attempted to create invalid color")
            }
            colorLocation = [0, touchBoxX]
            colorSelected = color
        } else {
            let position = isDarkMode ? 9 - touchBoxY : touchBoxY - 1
            let colorName = "\(ColorConstants.array[touchBoxX])\(position)"
            guard let color = UIColor(named: colorName) else {
                fatalError("Attempted to create invalid color")
            }
            colorLocation = [touchBoxY, touchBoxX]
            colorSelected = color
        }
        moveSquareToColor()
        delegate?.colorPickerDidPickColor(colorSelected)
    }
    
    private func touchOutsideColorImage() {
        delegate?.colorPickerDidPickColor(colorSelected)
        removeFromSuperview()
    }
    
}
