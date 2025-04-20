//
//  GroceryItem.swift
//  PrepPal
//
//  Created by Abdulmujeeb Lawal on 4/20/25.
//


//grocery item model 
struct GroceryItem: Identifiable, Hashable {
    let id: String
    var name: String
    var quantity: String
    var category: String
    var checked: Bool
    
    init(id: String, name: String, quantity: String, category: String, checked: Bool = false) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.category = category
        self.checked = checked
    }
}
