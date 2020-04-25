//
//  NoteViewController.swift
//  NoteTaker
//
//  Created by Ian McDonald on 01/04/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import UIKit

class WrittenNoteViewController: UIViewController, Storyboarded {
    
    
    @IBOutlet weak var textView: UITextView!
    var coordinator: WrittenCoordinator?
    var selectedColor: UIColor!
    var note: WrittenNote!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        addNotifications()
        addToolbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        textView.attributedText = note.text
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        note.text = textView.attributedText
        coordinator?.reloadData()
    }
    
    private func configure() {
        /// Text View
        textView.font = UIFont(name: "Symbol", size: 14)
        textView.delegate = self
        
        /// Color
        selectedColor = UIColor(forName: ColorConstants.grayscale, shade: 11)
    }
    
    private func addNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard),
                                       name: UIResponder.keyboardWillHideNotification,
                                       object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard),
                                       name: UIResponder.keyboardWillChangeFrameNotification,
                                       object: nil)
    }
    
    private func addToolbar() {
        let toolbar = NTTextViewToolbar(color: selectedColor)
        textView.inputAccessoryView = toolbar
        toolbar.toolbarDelegate = self
    }
    
    private func setColor(_ color: UIColor) {
        let string = NSMutableAttributedString(attributedString: textView.attributedText)
        let selectedRange = textView.selectedRange
        string.setColor(color, for: selectedRange)
        textView.attributedText = string
        textView.selectedRange = selectedRange
    }
    
    private func setFont(_ font: UIFont) {
        let string = NSMutableAttributedString(attributedString: textView.attributedText)
        let selectedRange = textView.selectedRange
        string.setFont(font, for: selectedRange)
        textView.attributedText = string
        textView.becomeFirstResponder()
        textView.selectedRange = selectedRange
    }
    
    @objc private func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
            as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = .zero
        } else {
            textView.contentInset = UIEdgeInsets(top: 0, left: 0,
                                                 bottom: keyboardViewEndFrame.height -
                                                    view.safeAreaInsets.bottom,
                                                 right: 0)
        }

        textView.scrollIndicatorInsets = textView.contentInset

        let selectedRange = textView.selectedRange
        textView.scrollRangeToVisible(selectedRange)
    }
}
extension WrittenNoteViewController: NTColorPickerDelegate {
    func colorPickerDidPickColor(_ color: UIColor) {
        setColor(color)
    }
}

extension WrittenNoteViewController: NTTextViewTolbarDelegate {
    func fontPickerDidPickFont(_ font: UIFont) {
        setFont(font)
    }
    
    func presentVC(_ controller: UIViewController, animated: Bool) {
        self.present(controller, animated: animated)
    }
    
    func resignFirstResponder() {
        textView.resignFirstResponder()
        note.text = textView.attributedText
    }
    
    func showKeyboard() {
        textView.becomeFirstResponder()
    }
}

extension WrittenNoteViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        note.text = textView.attributedText
        coordinator?.reloadData()
        PersistanceService.saveContext()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let oldStart = note.text?.string.prefix(50)
        let newStart = textView.text.prefix(50)
        note.text = textView.attributedText
        
        if oldStart != newStart {
            coordinator?.reloadData()
        }
    }
}
