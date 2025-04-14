//
//  Ingredient.swift
//  PrepPal
//
//  Created for PrepPal App
//

import Foundation
import SwiftData

@Model
final class Ingredient {
    // Core properties
    var id: UUID
    var name: String
    var quantity: Double
    var unit: String // e.g., cups, tablespoons, grams
    
    // Additional properties
    var category: String? // e.g., Dairy, Produce, Grains
    var isInPantry: Bool
    var expirationDate: Date?
    
    // Relationship with parent meal
    @Relationship(inverse: \Meal.ingredients)
    var meal: Meal?
    
    init(name: String, quantity: Double, unit: String, category: String? = nil) {
        self.id = UUID()
        self.name = name
        self.quantity = quantity
        self.unit = unit
        self.category = category
        self.isInPantry = false
    }
}

// Extension for utility functions
extension Ingredient {
    static var sampleIngredients: [Ingredient] {
        [
            Ingredient(name: "Broccoli", quantity: 1, unit: "cup", category: "Produce"),
            Ingredient(name: "Spinach", quantity: 2, unit: "cups", category: "Produce"),
            Ingredient(name: "Quinoa", quantity: 0.5, unit: "cup", category: "Grains"),
            Ingredient(name: "Avocado", quantity: 1, unit: "whole", category: "Produce"),
            Ingredient(name: "Whole grain bread", quantity: 2, unit: "slices", category: "Bakery"),
        ]
    }
    
    // Check if ingredient is expiring soon (within 3 days)
    var isExpiringSoon: Bool {
        guard let expirationDate = expirationDate else { return false }
        let threeDaysFromNow = Calendar.current.date(byAdding: .day, value: 3, to: Date()) ?? Date()
        return expirationDate <= threeDaysFromNow
    }
} 