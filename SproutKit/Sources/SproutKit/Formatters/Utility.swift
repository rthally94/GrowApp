//
//  Utility.swift
//  Sprout
//
//  Created by Ryan Thally on 4/9/21.
//

import Foundation

enum Utility {
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        return formatter
    }

    static var dateComponentsFormatter: DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.month, .weekOfMonth, .day]
        formatter.maximumUnitCount = 1
        formatter.formattingContext = .beginningOfSentence
        formatter.unitsStyle = .full
        return formatter
    }

    static var relativeDateFormatter: RelativeDateFormatter {
        let formatter = RelativeDateFormatter()
        return formatter
    }

    static var ordinalNumberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        formatter.formattingContext = .middleOfSentence
        return formatter
    }

    static var careScheduleFormatter: CareScheduleFormatter {
        let formatter = CareScheduleFormatter()
        formatter.valuesStyle = .short
        formatter.formattingContext = .standalone
        return formatter
    }

    static var ISODateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:SS ZZZ"
        return formatter
    }
}