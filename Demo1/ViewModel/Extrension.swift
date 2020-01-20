//
//  Extrension.swift
//  Venkat Reddy
//
//  Created by ojas on 18/12/19.
//  Copyright © 2019 ojas. All rights reserved.
//

import Foundation


extension Date
{
    func formatDateString(dateString : String) -> String
    {
        let dateComponents = dateString.components(separatedBy: "T")
        if dateComponents.count > 0
        {
            let formatedDateStr = dateComponents[0]
            
            let sysFormat = DateFormatter()
            sysFormat.dateFormat = "yyyy-MM-dd"
            let newDate = sysFormat.date(from: formatedDateStr)
            
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "yyyy-MMM-dd"
            let newStringDate =  dateFormatterPrint.string(from: newDate!)
            return newStringDate
        }
        return ""
    }
}
