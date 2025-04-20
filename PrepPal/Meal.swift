//
//  Meal.swift
//  PrepPal
//
//  Created for PrepPal App
//

import Foundation
import SwiftData

@Model
final class Meal {
    // Core properties
    var id: UUID
    var name: String
    var mealDescription: String
    var prepTimeMinutes: Int
    var mealType: String  // Breakfast, Lunch, Dinner, Snack
    var dietaryType: String? // Vegan, Vegetarian, etc.
    var imageURL: String?
    var isFavorite: Bool
    var dateAdded: Date
    
    // Recipe details
    var ingredients: [Ingredient]? // Relationships would be managed by SwiftData
    var instructions: String?
    var servings: Int
    
    // Nutritional information
    var calories: Int?
    var protein: Double?
    var carbs: Double?
    var fat: Double?
    
    // Planning details
    var plannedDate: Date?
    
    init(name: String, mealDescription: String, prepTimeMinutes: Int, mealType: String, dietaryType: String? = nil, servings: Int = 1) {
        self.id = UUID()
        self.name = name
        self.mealDescription = mealDescription
        self.prepTimeMinutes = prepTimeMinutes
        self.mealType = mealType
        self.dietaryType = dietaryType
        self.isFavorite = false
        self.dateAdded = Date()
        self.servings = servings
        self.ingredients = []
    }
}

// Extension for utility functions
extension Meal {
    static var sampleMeals: [Meal] {
        [
            Meal(name: "Vegan Buddha Bowl", 
                 mealDescription: "A hearty bowl with quinoa, roasted vegetables, and tahini dressing.",
                 prepTimeMinutes: 15,
                 mealType: "Lunch",
                 dietaryType: "Vegan",
                 servings: 1),
            
            Meal(name: "Quick Avocado Toast", 
                 mealDescription: "Simple and nutritious breakfast with avocado on whole grain toast.",
                 prepTimeMinutes: 5,
                 mealType: "Breakfast",
                 servings: 1),
            
            Meal(name: "Spinach Salad",
                 mealDescription: "Fresh spinach salad with strawberries, nuts, and balsamic vinaigrette.",
                 prepTimeMinutes: 10,
                 mealType: "Lunch",
                 dietaryType: "Vegetarian",
                 servings: 2)
        ]
    }
} 