//
//  Extensions.swift
//  Scoreboard Countdown
//
//  Created by Chris on 06/11/2015.
//  Copyright © 2015 Tyler Behnken. All rights reserved.
//

import Foundation
import UIKit

extension NSDate {
    
    /**
     This function parses an NSDate into the American short format
     
     - parameter format: The Date Format that we should parse to with a default.
     
     - returns: The date we parsed in string form
     */
    func parseDateShortFormat(format: String = "MM/dd/yyyy") -> String{
        let formatter = NSDateFormatter()
        formatter.dateFormat = format
        return formatter.stringFromDate(self)
    }

    /**
     This parses an NSDate into calendar components
     
     - returns: The calendar components we need
     */
    func parseToCalendarComponents() -> NSDateComponents {
        let calendar = NSCalendar.currentCalendar()
        return calendar.components([.Day, .Hour, .Minute, .Second], fromDate: NSDate(), toDate: self, options: [])
    }
}
