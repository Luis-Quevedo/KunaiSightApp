//
//  OCRParser.swift
//  BioPago
//
//  Created by Ulises Atonatiuh Gonzalez Hernandez  on 30/06/25.
//

import Foundation

struct OCRParser {
    static func parse(from lines: [String]) -> OCRResultModel {
        var merchant: String?
        var amount: String?
        var date: String?

        for line in lines {
            if amount == nil,
               let match = line.range(of: #"(\$?\d{1,3}(,\d{3})*(\.\d{2})?)"#, options: .regularExpression) {
                amount = String(line[match])
            }

            if date == nil,
               let match = line.range(of: #"\d{2}/\d{2}/\d{4}"#, options: .regularExpression) {
                date = String(line[match])
            }

            if merchant == nil, line.count > 3, line.range(of: #"[a-zA-Z]"#, options: .regularExpression) != nil {
                merchant = line.trimmingCharacters(in: .whitespacesAndNewlines)
            }

            if merchant != nil && amount != nil && date != nil {
                break
            }
        }

        return OCRResultModel(merchant: merchant, amount: amount, date: date, rawText: lines)
    }
}
