//
//  DateExtension.swift
//  NoteTaker
//
//  Created by Ian McDonald on 26/04/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import Foundation

extension Date {
    func formatStringTodayYesterday(format: String?, otherTime otherFormat: String) -> String {
        let formatter = DateFormatter()
        if Calendar.current.isDateInToday(self) {
            guard let format = format else { return "Today" }
            formatter.dateFormat = format
            return "Today at " + formatter.string(from: self)
        } else if Calendar.current.isDateInYesterday(self) {
            guard let format = format else { return "Yesterday" }
            formatter.dateFormat = format
            return "Yesterday at " + formatter.string(from: self)
        } else {
            formatter.dateFormat = otherFormat
            return formatter.string(from: self)
        }
    }
}
