//
//  NTColorPickerView.swift
//  NoteTaker
//
//  Created by Ian McDonald on 06/04/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import UIKit

/// This class provides a color picker which is similar in style to the color picker in iOS13s screenshot markup menu. 
class NTColorPickerView: UIView {
    
    // MARK: Public Variables
    var delegate: NTColorPickerDelegate?
    
    // MARK: Private Set Variables
    private(set) var colorSelected: UIColor = UIColor(named: "Grayscale11")!
    
    //MARK: Private Variables
    private var imageView: NTMonitoredImageView!
    private var rectangleView: UIView!
    private var markerSquare: UIView!
    private var markerTopAnchor: NSLayoutConstraint!
    private var markerLeadingAnchor: NSLayoutConstraint!
    private var markerHeightAnchor: NSLayoutConstraint!
    private var markerWidthAnchor: NSLayoutConstraint!
    
    //MARK: Calculated Varables
    private var isDarkMode: Bool {
        return traitCollection.userInterfaceStyle == .dark
    }
    
    private var colorSquareHeight: CGFloat {
        if imageView.bounds.height != 0 {
            return imageView.bounds.height / 10
        }
        
        return 10
    }
    
    private var colodSquareWidth: CGFloat {
        if imageView.bounds.width != 0 {
            return imageView.bounds.width / 12
        }
        
        return 10
    }
    
    // MARK: Initializers
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
    
    // MARK: Override Functions
    override func didMoveToSuperview() {
        /// When the view moves to a superview set the constraints and configure the constraints and configure the MarkerSquare
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        let touchLocation = touch.location(in: imageView)
        
        /// Check if touch is inside or outside of the imageView bounds to determin the correct course of action
        if imageView.bounds.contains(touchLocation) {
            touchInsideColorImage(at: touchLocation)
        } else {
            touchOutsideColorImage()
        }
        
    }
    
    // MARK: Private functions
    private func configure() {
        /// Set a transparent background
        backgroundColor = .clear
        isOpaque = false
        
        ///Configure the views
        configureRectangleView()
        configureImageView()
    }
    
    // MARK: RectangleView Functions
    private func configureRectangleView() {
        /// Create UIView as background
        rectangleView = UIView()
        rectangleView.translatesAutoresizingMaskIntoConstraints = false
        rectangleView.layer.cornerRadius = 10
        rectangleView.layer.borderWidth = 5
        rectangleView.layer.borderColor = UIColor.systemGray5.withAlphaComponent(0.8).cgColor
        rectangleView.clipsToBounds = true
        addSubview(rectangleView)
        
        /// Width and Height constraints have a lower priority than normal constraints, they need to be created separetely
        let horizontalWidthAnchor = rectangleView.widthAnchor.constraint(equalToConstant: 342)
        horizontalWidthAnchor.priority = UILayoutPriority(500.0)
        
        let verticalHeightAnchor = rectangleView.heightAnchor.constraint(equalToConstant: 295)
        verticalHeightAnchor.priority = UILayoutPriority(500.0)
        
        /// Activate comnstraints
        NSLayoutConstraint.activate([
            rectangleView.topAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.topAnchor,
                                               constant: 10),
            rectangleView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                                  constant: -10),
            rectangleView.leadingAnchor.constraint(greaterThanOrEqualTo:
                safeAreaLayoutGuide.leadingAnchor, constant: 10),
            rectangleView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,
                                                    constant: -10),
            horizontalWidthAnchor,
            verticalHeightAnchor
        ])
    }
    
    // MARK: ImageView Functions
    private func configureImageView() {
        /// Create the imageview
        imageView = NTMonitoredImageView()
        imageView.delegate = self
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        rectangleView.addSubview(imageView)
        
        /// Create the image
        imageView.image = createColorImage()
        
        /// Activate the constraints
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
    
    private func createColorImage() -> UIImage {
        /// Draw an image with a square of each color available (120 in total) The image appears the same in DarkMode and
        /// LightMode however to achieve this the colors must be reversed in dark mode.
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
        
        return img
        
    }
    
    // MARK: MarkerSquare functions
    private func configureMarkerSquare() {
        /// The marker square is used to mark which color is selected. Its constraints are stored as parameters as they are changed
        /// each time the bounds of the image view change.
        markerSquare = UIView()
        markerSquare.translatesAutoresizingMaskIntoConstraints = false
        markerSquare.layer.borderWidth = 2
        markerSquare.layer.borderColor = UIColor.systemGray6.cgColor
        imageView.addSubview(markerSquare)
        
        markerLeadingAnchor = markerSquare.leadingAnchor.constraint(equalTo:
            imageView.leadingAnchor, constant: 110)
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
        
        moveMarkerSquareToColor()
    }
    
    private func moveMarkerSquareToColor() {
        /// This calculates the location where the marker square should appear.
        let location: CGRect
        if let name = colorSelected.name {
            /// Color selected is in the list of 120
            if name.hasPrefix(ColorConstants.grayscale) {
                /// The color is a grayscale color. The number could be from 0 - 11. If the last digit is a 0 or 1  check if its a single
                /// digit number or a 2 digit number. The index is always 0 because grayscale is the top row
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
                
                /// Adjust the position depending on if its dark mode or light mode
                let position = isDarkMode ? 11 - number : number
                location = CGRect(x: CGFloat(position) * colodSquareWidth,
                                  y: CGFloat(0) * colorSquareHeight,
                                  width: colodSquareWidth, height: colorSquareHeight)
            } else {
                /// The color is not grayscale so it is a color name followed by a number from 0 - 8.
                /// Remove the last digit to get the name
                let colorName = String(name.dropLast())
                
                /// Get the last number
                guard let numberCharacter = name.last else {
                    fatalError("Unable to find last character")
                }
                guard let colorNumber = Int(String(numberCharacter)) else {
                    fatalError("Character at the end of selectedColor.name is not a number")
                }
                
                /// Adjust the position depending on if its dark mode or light mode
                let position = isDarkMode ? 9 - colorNumber : colorNumber + 1
                
                /// Get its index in the array of colors
                guard let index = ColorConstants.array.firstIndex(of: colorName) else {
                    fatalError("Color named: \(colorName) not found in color array")
                }
                
                location = CGRect(x: CGFloat(index) * colodSquareWidth,
                                  y: CGFloat(position) * colorSquareHeight,
                                  width: colodSquareWidth, height: colorSquareHeight)
            }
        } else {
            /// Color selected is not in the list of 120 use the default position
            location = CGRect(x: CGFloat(11) * colodSquareWidth,
                              y: CGFloat(0) * colorSquareHeight,
                              width: colodSquareWidth, height: colorSquareHeight)
        }
        
        /// Call the function to move the square to the actual location
        moveMarkerSquareTo(location)
    }
    
    private func moveMarkerSquareTo(_ location: CGRect) {
        /// Adjust the anchor constants to put the square in the right location
        markerLeadingAnchor.constant = location.minX
        markerTopAnchor.constant = location.minY
        markerWidthAnchor.constant = location.width
        markerHeightAnchor.constant = location.height
    }
    
    // MARK: Touch Location Functions
    private func touchInsideColorImage(at location: CGPoint) {
        /// Determine the color that was touched
        let touchBoxX = Int(location.x/colodSquareWidth)
        let touchBoxY = Int(location.y/colorSquareHeight)
        if touchBoxY == 0 {
            let position = isDarkMode ? 11 - touchBoxX : touchBoxX
            colorSelected = UIColor(forName: ColorConstants.grayscale, shade: position)
        } else {
            let position = isDarkMode ? 9 - touchBoxY : touchBoxY - 1
            colorSelected = UIColor(forName: ColorConstants.array[touchBoxX], shade: position)
        }
        
        /// Move the marker to the square and advise the delegate that the color was selected
        moveMarkerSquareToColor()
        delegate?.colorPickerDidPickColor(colorSelected)
    }
    
    private func touchOutsideColorImage() {
        /// Remove the view and advise the delegate of the color selected
        delegate?.colorPickerDidPickColor(colorSelected)
        removeFromSuperview()
    }
    
}

// MARK: Extension Monitored ImageView Delegate
extension NTColorPickerView: NTMonitoredImageViewDelegate {
    /// Whenever the imageViews bounds change reset the position of the marker square
    func didSetBounds(_ bounds: CGRect, oldValue: CGRect) {
        moveMarkerSquareToColor()
    }
}
