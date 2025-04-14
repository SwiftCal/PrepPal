//
//  ContentView.swift
//  PrepPal
//
//  Created by Ifeoluwakiitan Ayandosu on 4/8/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    // State to track if user is authenticated
    @State private var isAuthenticated = false
    
    var body: some View {
        if !isAuthenticated {
            // Show the authentication view if not authenticated
            AuthView(onAuthenticated: {
                // Set authenticated to true when the callback is triggered
                isAuthenticated = true
            })
        } else {
            // Show the main app content once authenticated
            NavigationSplitView {
                List {
                    ForEach(items) { item in
                        NavigationLink {
                            Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                        } label: {
                            Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    ToolbarItem {
                        Button(action: addItem) {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                    
                    // Add logout button
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            // Log out
                            isAuthenticated = false
                        }) {
                            Text("Logout")
                        }
                    }
                }
                .navigationTitle("PrepPal")
            } detail: {
                Text("Select an item")
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Item.self, User.self], inMemory: true)
}
