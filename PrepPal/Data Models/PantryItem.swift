//
//  PantryItem.swift
//  PrepPal
//
//  Created by Abdulmujeeb Lawal on 4/20/25.
//


import Foundation
import FirebaseFirestore
// MARK: - PantryItem Model
struct PantryItem: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    var name: String
    var quantity: String
    var unit: String
    var expirationDate: Date

    var daysUntilExpiration: Int {
        Calendar.current.dateComponents([.day], from: Date(), to: expirationDate).day ?? 0
    }
}

// MARK: - Sort Options Enum
enum SortOption: String, CaseIterable, Identifiable {
    case expiration = "Expiration Date"
    case name = "Name"
    var id: Self { self }
}



