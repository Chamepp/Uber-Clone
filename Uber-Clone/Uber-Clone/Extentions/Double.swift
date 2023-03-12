//
//  Double.swift
//  Uber-Clone
//
//  Created by Ashkan Ebtekari on 3/12/23.
//

import Foundation

extension Double {
    private var currency_formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    func to_currency() -> String {
        return currency_formatter.string(for: self) ?? ""
    }
}
