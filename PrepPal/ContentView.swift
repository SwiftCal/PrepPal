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
    
    // Authentication model
    @EnvironmentObject var authModel: AuthModel
    
    // Selected tab for navigation
    @State private var selectedTab: Tab = .home
    
    // Enum for tracking tab selection
    enum Tab {
        case home, grocery, scan, meals, profile
    }
    
    var body: some View {
        // Check if user is authenticated
        if authModel.user != nil {
            // Main tab navigation
            TabView(selection: $selectedTab) {
                // Home tab
                NavigationView {
                    DashboardView()
                }
                .tag(Tab.home)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                
                // Grocery tab
                NavigationView {
                    GroceryListView()
                }
                .tag(Tab.grocery)
                .tabItem {
                    Label("Grocery", systemImage: "cart.fill")
                }
                
                // Scan tab (placeholder)
                NavigationView {
                    Text("Scan View Coming Soon")
                        .font(.title)
                        .foregroundColor(.gray)
                }
                .tag(Tab.scan)
                .tabItem {
                    Label("Scan", systemImage: "qrcode.viewfinder")
                }
                
                // Meals tab (placeholder)
                NavigationView {
                    Text("Meals View Coming Soon")
                        .font(.title)
                        .foregroundColor(.gray)
                }
                .tag(Tab.meals)
                .tabItem {
                    Label("Meals", systemImage: "calendar")
                }
                
                // Profile tab
                NavigationView {
                    ProfileSettingsView()
                }
                .tag(Tab.profile)
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
            }
            .accentColor(Color.prepPalGreen)
        } else {
            // Authentication view
            AuthView()
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
        .modelContainer(for: [Item.self, User.self, Meal.self, Ingredient.self], inMemory: true)
        .environmentObject(AuthModel())
}
