//
//  DateManager.swift
//  projectstickers
//
//  Created by William Robinson on 05/11/2016.
//  Copyright © 2016 William Robinson. All rights reserved.
//

import Foundation

enum Month {
    
    case january
    case february
    case march
    case april
    case may
    case june
    case july
    case august
    case september
    case october
    case november
    case december
    case unknown
}

class DateManager {
    
    func detectMonth() -> Month {
        
        let date = Date()
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        
        switch month {
        case 1:
            return Month.january
        case 2:
            return Month.february
        case 3:
            return Month.march
        case 4:
            return Month.april
        case 5:
            return Month.may
        case 6:
            return Month.june
        case 7:
            return Month.july
        case 8:
            return Month.august
        case 9:
            return Month.september
        case 10:
            return Month.october
        case 11:
            return Month.december
        case 12:
            return Month.december
        default:
            return Month.unknown
        }
    }
}
