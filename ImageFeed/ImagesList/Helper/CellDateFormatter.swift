//
//  CellDateFormatter.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 01.06.2023.
//

import Foundation

final class CellDateFormatter {
    private let dateFormatterToPresent: DateFormatter = {
        let formatter = DateFormatter()

        formatter.dateFormat = "dd MMMM yyyy"

        return formatter
    }()
    private let isoDateFormatter = ISO8601DateFormatter()

    func getFormattedDate(from date: String?) -> String {
        var cellDate = String()
        if let stringDate = date,
           let date = isoDateFormatter.date(from: stringDate) {
            cellDate = dateFormatterToPresent.string(from: date)
        }
        return cellDate
    }
}
