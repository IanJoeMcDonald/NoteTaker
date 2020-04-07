//
//  NTColorPickerView.swift
//  NoteTaker
//
//  Created by Ian McDonald on 06/04/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import UIKit

class NTColorPickerView: UIView {

    let colorArray = ["Teal", "Blue", "Indigo", "Purple", "Magenta", "Red",
                      "Orange", "Brown", "Tan", "Yellow", "Lime", "Green"]
    
    var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 600),
            imageView.leftAnchor.constraint(equalTo: leftAnchor),
            imageView.rightAnchor.constraint(equalTo: rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        createColorImage()
    }
    
    private func createColorImage() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 120, height: 100))
        let img = renderer.image { ctx in
            if traitCollection.userInterfaceStyle == .dark {
                for row in 0 ..< 10 {
                    for column in 0 ..< 12 {
                        if row == 0 {
                            ctx.cgContext.setFillColor(UIColor(named: "Grayscale\(11 - column)")!.cgColor)
                            ctx.cgContext.fill(CGRect(x: column * 10, y: row * 10, width: 10, height: 10))
                        } else {
                            ctx.cgContext.setFillColor(UIColor(named: "\(colorArray[column])\(9 - row)")!.cgColor)
                            ctx.cgContext.fill(CGRect(x: column * 10, y: row * 10, width: 10, height: 10))
                        }
                    }
                }
            } else {
                for row in 0 ..< 10 {
                    for column in 0 ..< 12 {
                        if row == 0 {
                            ctx.cgContext.setFillColor(UIColor(named: "Grayscale\(column)")!.cgColor)
                            ctx.cgContext.fill(CGRect(x: column * 10, y: row * 10, width: 10, height: 10))
                        } else {
                            ctx.cgContext.setFillColor(UIColor(named: "\(colorArray[column])\(row-1)")!.cgColor)
                            ctx.cgContext.fill(CGRect(x: column * 10, y: row * 10, width: 10, height: 10))
                        }
                    }
                }
            }
        }
        
        imageView.image = img
        
    }
    
}
