//
//  GroceryListView.swift
//  PrepPal
//
//  Created for PrepPal App
//

import SwiftUI

// MARK: - GroceryItem Model
struct GroceryItem: Identifiable, Hashable {
    let id: UUID
    var name: String
    var quantity: String
    var category: String
    var checked: Bool
    
    init(id: UUID = UUID(), name: String, quantity: String, category: String, checked: Bool = false) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.category = category
        self.checked = checked
    }
}

// MARK: - GroceryListView
struct GroceryListView: View {
    // State for grocery items
    @State private var groceryItems: [GroceryItem] = [
        // Sample items for each category
        GroceryItem(name: "Spinach", quantity: "1 bunch", category: "Produce"),
        GroceryItem(name: "Broccoli", quantity: "2 heads", category: "Produce"),
        GroceryItem(name: "Carrots", quantity: "1 lb", category: "Produce"),
        GroceryItem(name: "Apples", quantity: "6 pieces", category: "Produce", checked: true),
        GroceryItem(name: "Avocados", quantity: "3 pieces", category: "Produce"),
        GroceryItem(name: "Almond Milk", quantity: "1 carton", category: "Dairy Alternatives"),
        GroceryItem(name: "Tofu", quantity: "1 block", category: "Protein"),
        GroceryItem(name: "Chickpeas", quantity: "2 cans", category: "Canned Goods")
    ]
    
    // State for the "Add Item" sheet
    @State private var showAddItemSheet = false
    
    // State for new item form
    @State private var newItemName = ""
    @State private var newItemQuantity = ""
    @State private var newItemCategory = "Produce"
    
    // List of available categories
    let categories = ["Produce", "Dairy Alternatives", "Protein", "Canned Goods", "Grains", "Snacks", "Beverages", "Other"]
    
    // Computed property for items remaining count
    private var remainingCount: Int {
        groceryItems.filter { !$0.checked }.count
    }
    
    // Computed property for items grouped by category
    private var groupedItems: [String: [GroceryItem]] {
        Dictionary(grouping: groceryItems) { $0.category }
    }
    
    var body: some View {
        // Main layout
        ZStack(alignment: .bottomTrailing) {
            // Grocery list content
            VStack(spacing: 0) {
                // Items remaining count
                HStack {
                    Text("\(remainingCount) items remaining")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 8)
                .padding(.bottom, 8)
                .background(Color(.systemBackground))
                
                // Scrollable list of items by category
                ScrollView {
                    VStack(spacing: 24) {
                        ForEach(groupedItems.keys.sorted(), id: \.self) { category in
                            if let items = groupedItems[category] {
                                CategorySection(
                                    category: category,
                                    items: items,
                                    onToggleChecked: toggleItemChecked,
                                    onDeleteItem: deleteItem
                                )
                            }
                        }
                        
                        // Extra space at bottom for floating button
                        Spacer()
                            .frame(height: 80)
                    }
                    .padding(.horizontal)
                    .padding(.top, 16)
                }
            }
            
            // Floating "Add Item" button
            Button(action: {
                showAddItemSheet = true
            }) {
                Image(systemName: "plus")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 56, height: 56)
                    .background(Color.prepPalGreen)
                    .clipShape(Circle())
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
            }
            .padding(.trailing, 16)
            .padding(.bottom, 16)
        }
        .navigationTitle("Grocery List")
        .navigationBarTitleDisplayMode(.inline)
        // "Add Item" sheet
        .sheet(isPresented: $showAddItemSheet) {
            AddItemSheet(
                isPresented: $showAddItemSheet,
                name: $newItemName,
                quantity: $newItemQuantity,
                category: $newItemCategory,
                categories: categories,
                onAdd: addItem
            )
        }
    }
    
    // MARK: - Functions
    
    // Toggle item checked state
    private func toggleItemChecked(item: GroceryItem) {
        if let index = groceryItems.firstIndex(where: { $0.id == item.id }) {
            groceryItems[index].checked.toggle()
        }
    }
    
    // Delete an item
    private func deleteItem(item: GroceryItem) {
        groceryItems.removeAll(where: { $0.id == item.id })
    }
    
    // Add a new item
    private func addItem() {
        let newItem = GroceryItem(
            name: newItemName,
            quantity: newItemQuantity,
            category: newItemCategory
        )
        
        groceryItems.append(newItem)
        
        // Reset form
        newItemName = ""
        newItemQuantity = ""
        showAddItemSheet = false
    }
}

// MARK: - Category Section
struct CategorySection: View {
    let category: String
    let items: [GroceryItem]
    let onToggleChecked: (GroceryItem) -> Void
    let onDeleteItem: (GroceryItem) -> Void
    
    var body: some View {
        // Corresponds to React category section
        VStack(alignment: .leading, spacing: 8) {
            // Category title
            Text(category)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(Color.prepPalGreen)
                .padding(.leading, 4)
            
            // Category items card
            VStack(spacing: 0) {
                ForEach(items) { item in
                    GroceryItemRow(
                        item: item,
                        onToggleChecked: onToggleChecked,
                        onDeleteItem: onDeleteItem
                    )
                    
                    if item.id != items.last?.id {
                        Divider()
                            .padding(.leading, 48)
                    }
                }
            }
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.03), radius: 2, x: 0, y: 1)
        }
    }
}

// MARK: - Grocery Item Row
struct GroceryItemRow: View {
    let item: GroceryItem
    let onToggleChecked: (GroceryItem) -> Void
    let onDeleteItem: (GroceryItem) -> Void
    
    var body: some View {
        // Corresponds to React item row
        HStack(spacing: 16) {
            // Checkbox
            Button(action: {
                onToggleChecked(item)
            }) {
                ZStack {
                    Circle()
                        .stroke(item.checked ? Color.prepPalGreen : Color.gray.opacity(0.3), lineWidth: 1.5)
                        .frame(width: 24, height: 24)
                    
                    if item.checked {
                        Circle()
                            .fill(Color.prepPalGreen)
                            .frame(width: 24, height: 24)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            // Item name and quantity
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.body)
                    .foregroundColor(item.checked ? .gray : .primary)
                    .strikethrough(item.checked)
                
                Text(item.quantity)
                    .font(.caption)
                    .foregroundColor(item.checked ? .gray : .secondary)
                    .strikethrough(item.checked)
            }
            
            Spacer()
            
            // Delete button
            Button(action: {
                onDeleteItem(item)
            }) {
                Image(systemName: "trash")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .padding(8)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .contentShape(Rectangle())
    }
}

// MARK: - Add Item Sheet
struct AddItemSheet: View {
    @Binding var isPresented: Bool
    @Binding var name: String
    @Binding var quantity: String
    @Binding var category: String
    let categories: [String]
    let onAdd: () -> Void
    
    var body: some View {
        // Corresponds to React modal form
        NavigationView {
            Form {
                Section(header: Text("Item Details")) {
                    TextField("Item Name", text: $name)
                    TextField("Quantity", text: $quantity)
                    
                    Picker("Category", selection: $category) {
                        ForEach(categories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                }
                
                Section {
                    Button(action: {
                        // Only add if name and quantity are not empty
                        if !name.isEmpty && !quantity.isEmpty {
                            onAdd()
                        }
                    }) {
                        HStack {
                            Spacer()
                            Text("Add to List")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    .disabled(name.isEmpty || quantity.isEmpty)
                }
            }
            .navigationTitle("Add Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        isPresented = false
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
}

// MARK: - Preview
struct GroceryListView_Previews: PreviewProvider {
    static var previews: some View {
        GroceryListView()
    }
} 