//
//  DateUtils.swift
//  iosApp
//
//  Created by Akashaka on 04/07/23.
//  Copyright © 2023 orgName. All rights reserved.
//

import Foundation
import shared
extension Date {
    var asFormattedTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
}

func formatCurrency(_ value: Int32) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.currencySymbol = "Rp."
    formatter.maximumFractionDigits = 0
    formatter.groupingSeparator = "."

    return formatter.string(from: NSNumber(value: value)) ?? ""
}
