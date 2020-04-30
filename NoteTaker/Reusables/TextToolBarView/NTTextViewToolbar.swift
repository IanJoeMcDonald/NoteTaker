//
//  NTTextViewToolbar.swift
//  NoteTaker
//
//  Created by Ian McDonald on 11/04/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import UIKit

class NTTextViewToolbar: UIToolbar {
    
    var toolbarDelegate: NTTextViewTolbarDelegate?
    
    var selectedColor: UIColor! {
        didSet {
            updateColorImage(with: selectedColor)
        }
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
        selectedColor = color
        configure()
    }
    
    private func configure() {
        
        frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        barStyle = .default
        let image = selectedColor.circleWithBorder(CGSize(width: 30, height: 30)).withRenderingMode(.alwaysOriginal)
        items = [
            UIBarButtonItem(title: "Font", style: .plain, target: self,
                            action: #selector(fontTapped)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .play, target: self,
                            action: #selector(playTapped)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(image: image, style: .plain, target: self,
                            action: #selector(colorTapped)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .done, target: self,
                            action: #selector(doneTapped))
        ]
        sizeToFit()
    }
        
    @objc private func fontTapped() {
        print("Font Tapped")
        toolbarDelegate?.resignFirstResponder()
        
        // Instantiate view
        let fpController = UIFontPickerViewController()
        fpController.delegate = self
        toolbarDelegate?.presentVC(fpController, animated: true)
    }
    
    @objc private func playTapped() {
        print("Play Tapped")
        toolbarDelegate?.playTextToSpeech()
    }
    
    @objc private func colorTapped() {
        print("Color Tapped")
        toolbarDelegate?.resignFirstResponder()
        
        // Instantiate view
        let cpView = NTColorPickerView(color: selectedColor)
        cpView.translatesAutoresizingMaskIntoConstraints = false
        cpView.delegate = self
        
        // Add view
        superview?.superview?.addSubview(cpView)
    }
    
    @objc private func doneTapped() {
        print ("Done Tapped")
        toolbarDelegate?.resignFirstResponder()
        
    }
    
    private func updateColorImage(with color: UIColor) {
        let image = color.circleWithBorder(CGSize(width: 30, height: 30)).withRenderingMode(.alwaysOriginal)
        
        let barItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(colorTapped))
        items?.remove(at: 2)
        items?.insert(barItem, at: 2)
    }
}

extension NTTextViewToolbar: NTColorPickerDelegate {
    func colorPickerDidPickColor(_ color: UIColor) {
        selectedColor = color
        toolbarDelegate?.colorPickerDidPickColor(color)
    }
    
    func colorPickerDidDisappear(_ color: UIColor) {
        selectedColor = color
        toolbarDelegate?.colorPickerDidPickColor(color)
        toolbarDelegate?.showKeyboard()
    }
}

extension NTTextViewToolbar: UIFontPickerViewControllerDelegate {
    func fontPickerViewControllerDidPickFont(_ viewController: UIFontPickerViewController) {
        // attempt to read the selected font descriptor, but exit quietly if that fails
        guard let descriptor = viewController.selectedFontDescriptor else { return }

        let font = UIFont(descriptor: descriptor, size: 14)
        toolbarDelegate? .fontPickerDidPickFont(font)
    }
}
