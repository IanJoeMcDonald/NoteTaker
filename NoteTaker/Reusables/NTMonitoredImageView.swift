//
//  NTMonitoredImageView.swift
//  NoteTaker
//
//  Created by Ian McDonald on 09/04/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import UIKit

class NTMonitoredImageView: UIImageView {
    
    var delegate: NTMonitoredImageViewDelegate?
    
    override var frame: CGRect {
      willSet {
        delegate?.willSetFrame?(frame, newValue: newValue)
      }
      didSet {
        delegate?.didSetFrame?(frame, oldValue: oldValue)
      }
    }

    override var bounds: CGRect {
        willSet {
            delegate?.willSetBounds?(bounds, newValue: newValue)
      }
      didSet {
        delegate?.didSetBounds?(bounds, oldValue: oldValue)
      }
    }
}

@objc protocol NTMonitoredImageViewDelegate: AnyObject {
    @objc optional func willSetFrame(_ frame: CGRect, newValue: CGRect)
    @objc optional func didSetFrame(_ frame: CGRect, oldValue: CGRect)
    @objc optional func willSetBounds(_ bounds: CGRect, newValue: CGRect)
    @objc optional func didSetBounds(_ bounds: CGRect, oldValue: CGRect)
}
