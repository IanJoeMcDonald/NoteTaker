//
//  FileManagerExtension.swift
//  NoteTaker
//
//  Created by Ian McDonald on 05/05/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import Foundation

extension FileManager {
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.self.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
