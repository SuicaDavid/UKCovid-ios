//
//  DateExtension.swift
//  UKCovid-ios
//
//  Created by Suica on 11/12/2020.
//

import Foundation

extension Date {
    func isNewDay() -> Bool {
        let currentDate = Date()
        let formerDay = Calendar.current.component(.day, from: self)
        let newDay = Calendar.current.component(.day, from: currentDate)
        let interval = self.timeIntervalSince(Date())
        if abs(interval) > 86400 {
            return true
        } else if abs(newDay - formerDay) > 1 {
            return true
        } else {
            return false
        }
    }
}
