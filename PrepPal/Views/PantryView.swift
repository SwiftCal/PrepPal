//
//  PantryView.swift
//  PrepPal
//
//  Created for PrepPal App
//

import SwiftUI




// MARK: - PantryView
struct PantryView: View {
    @StateObject private var pantryViewModel = PantryViewModel()

    
    // State
    @State private var searchQuery = ""
    @State private var sortBy: SortOption = .expiration
    @State private var showAddDialog = false
    
    
    // New item state
    @State private var newItem = PantryItem(
        id: "", name: "", quantity: "", unit: "units",
        expirationDate: Date()
    )
    
    // Computed property for filtered and sorted items
    var filteredItems: [PantryItem] {
        let filtered = pantryViewModel.pantryItems.filter {
            searchQuery.isEmpty || $0.name.localizedCaseInsensitiveContains(searchQuery)
        }

        switch sortBy {
        case .expiration:
            return filtered.sorted { $0.daysUntilExpiration < $1.daysUntilExpiration }
        case .name:
            return filtered.sorted { $0.name.localizedCompare($1.name) == .orderedAscending }
        }
    }

    
    var body: some View {
        VStack(spacing: 16) {
            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search pantry items...", text: $searchQuery)
                    .font(.body)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal)
            
            // Sort control
            HStack {
                Text("Sort by:")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Picker("Sort by", selection: $sortBy) {
                    ForEach(SortOption.allCases) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                
                Spacer()
            }
            .padding(.horizontal)
            
            // Pantry items list
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(filteredItems) { item in
                        PantryItemRow(item: item) {
                            handleDeleteItem(item.id ?? UUID().uuidString)
                        }
                    }
                    
                    // Extra space at bottom
                    Spacer().frame(height: 50)
                }
                .padding()
            }
        }
        .navigationTitle("Pantry")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showAddDialog.toggle()
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(Color.prepPalGreen)
                }
            }
        }
        .sheet(isPresented: $showAddDialog) {
            AddPantryItemSheet(
                isPresented: $showAddDialog,
                newItem: $newItem,
                onAdd: handleAddItem
            )
        }.onAppear{

        pantryViewModel.fetchPantryItems()

        }
    }
    
    // MARK: - Functions
    private func handleAddItem() {
    var itemToAdd = newItem
    itemToAdd.id = nil
    pantryViewModel.addPantryItem(itemToAdd)

    // Reset the form
        newItem = PantryItem(name: "", quantity: "", unit: "units", expirationDate: Date())
}

    
    // Delete item from pantry
    private func handleDeleteItem(_ id: String) {
        pantryViewModel.deletePantryItem(id)
    }

}

// MARK: - Helper Functions
func expirationStyle(for days: Int) -> (bg: Color, fg: Color) {
    switch days {
    case ..<0:
        return (bg: Color.red.opacity(0.2), fg: Color.red)
    case 0...3:
        return (bg: Color.orange.opacity(0.2), fg: Color.orange)
    default:
        return (bg: Color.prepPalGreen.opacity(0.2), fg: Color.prepPalGreen)
    }
}

func expirationText(_ days: Int) -> String {
    switch days {
    case ..<0:
        return "Expired"
    case 0:
        return "Expires today"
    case 1:
        return "Expires tomorrow"
    default:
        return "Expires in \(days) days"
    }
}

// MARK: - Pantry Item Row
struct PantryItemRow: View {
    let item: PantryItem
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // Expiration indicator
            Circle()
                .fill(expirationStyle(for: item.daysUntilExpiration).bg)
                .frame(width: 8, height: 8)
            
            // Item details
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)
                
                HStack(spacing: 4) {
                    Text("\(item.quantity) \(item.unit)")
                    
                    Text("·")
                    
                    Text(expirationText(item.daysUntilExpiration))
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(expirationStyle(for: item.daysUntilExpiration).bg)
                        .foregroundColor(expirationStyle(for: item.daysUntilExpiration).fg)
                        .cornerRadius(8)
                }
                .foregroundColor(.gray)
                .font(.subheadline)
            }
            
            Spacer()
            
            // Delete button
            Button {
                onDelete()
            } label: {
                Image(systemName: "trash")
                    .foregroundColor(.gray)
            }
            .buttonStyle(PlainButtonStyle())
            
            // Detail arrow
            NavigationLink(destination: Text("Item Details Coming Soon")) {
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4)
    }
}

// MARK: - Add Pantry Item Sheet
struct AddPantryItemSheet: View {
    @Binding var isPresented: Bool
    @Binding var newItem: PantryItem
    let onAdd: () -> Void
    
    let units = ["units", "lbs", "oz", "cups", "cans", "bunch", "loaf", "carton"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Form {
                    Section(header: Text("Item Details")) {
                        TextField("Item Name", text: $newItem.name)
                        
                        HStack {
                            TextField("Quantity", text: $newItem.quantity)
                                .keyboardType(.decimalPad)
                            
                            Picker("Unit", selection: $newItem.unit) {
                                ForEach(units, id: \.self) { unit in
                                    Text(unit.capitalized).tag(unit)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                        }
                    }
                    
                    Section(header: Text("Expiration")) {
                        DatePicker("Expiration Date", selection: $newItem.expirationDate, displayedComponents: .date)
                    }
                    
                    Section {
                        Button("Add Item") {
                            onAdd()
                            isPresented = false
                        }
                        .disabled(newItem.name.isEmpty || newItem.quantity.isEmpty)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(newItem.name.isEmpty || newItem.quantity.isEmpty ? .gray : .white)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(newItem.name.isEmpty || newItem.quantity.isEmpty ? Color.gray.opacity(0.3) : Color.prepPalGreen)
                        )
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .navigationTitle("Add Pantry Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isPresented = false
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
}

// MARK: - Preview
struct PantryView_Previews: PreviewProvider {
    static var previews: some View {
        PantryView()
    }
} 

