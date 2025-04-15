//
//  DashboardView.swift
//  PrepPal
//
//  Created for PrepPal App
//

import SwiftUI
import SwiftData

struct DashboardView: View {
    // Access to the model context for database operations
    @Environment(\.modelContext) private var modelContext
    

    
    // Query for fetching user data
    @Query private var users: [User]
    
    // Query for fetching meal data
    @Query private var meals: [Meal]
    
    // Query for fetching ingredients
    @Query private var ingredients: [Ingredient]
    
    // State variables
    @State private var userName: String = "Alex"
    @State private var mealsPlanned: Int = 3
    @State private var totalMealsNeeded: Int = 5
    @State private var showLogoutAlert: Bool = false
    
    // Computed property for suggested meals
    private var suggestedMeals: [Meal] {
        // For now, return all meals, but in the future, this could include custom logic
        return meals.isEmpty ? Meal.sampleMeals : meals
    }
    
    // Computed property for expiring ingredients
    private var expiringIngredients: [Ingredient] {
        return ingredients.filter { $0.isExpiringSoon }
    }
    
    // Initialize user and sample data if needed
    private func initializeDataIfNeeded() {
        // Set user name if a user exists
        if let firstUser = users.first {
            userName = firstUser.fullName
        }
        
        // Add sample meals if needed
        if meals.isEmpty {
            for meal in Meal.sampleMeals {
                modelContext.insert(meal)
            }
        }
        
        // Add sample ingredients if needed
        if ingredients.isEmpty {
            let today = Date()
            let threeDaysFromNow = Calendar.current.date(byAdding: .day, value: 3, to: today)!
            
            let broccoli = Ingredient(name: "Broccoli", quantity: 1, unit: "cup", category: "Produce")
            broccoli.expirationDate = threeDaysFromNow
            broccoli.isInPantry = true
            
            let spinach = Ingredient(name: "Spinach", quantity: 2, unit: "cups", category: "Produce")
            spinach.expirationDate = Calendar.current.date(byAdding: .day, value: 2, to: today)!
            spinach.isInPantry = true
            
            modelContext.insert(broccoli)
            modelContext.insert(spinach)
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                // Main content
                ScrollView {
                    VStack(spacing: 20) {
                        // App Header
                        AppHeader(onLogout: {
                            showLogoutAlert = true
                        })
                        
                        // Welcome Banner
                        WelcomeBanner(userName: userName)
                        
                        // This Week's Plan Card
                        WeekPlanCard(
                            mealsPlanned: mealsPlanned,
                            totalMealsNeeded: totalMealsNeeded
                        )
                        
                        // Suggested Meals
                        SuggestedMealsSection(suggestedMeals: suggestedMeals)
                        
                        // Expiring Ingredients Alert - show only if there are expiring ingredients
                        if !expiringIngredients.isEmpty {
                            ExpiringIngredientsAlert(ingredients: expiringIngredients)
                        }
                        
                        // Generate Plan Button
                        GeneratePlanButton()
                        
                        // Additional space at bottom for the tab bar
                        Spacer()
                            .frame(height: 70)
                    }
                    .padding(.horizontal)
                }
                .background(Color(.systemBackground))
                
                // Bottom Navigation
                BottomTabBar(selectedTab: .home)
            }
            .edgesIgnoringSafeArea(.bottom)
            .onAppear {
                initializeDataIfNeeded()
            }
            // Logout confirmation alert
            .alert("Logout", isPresented: $showLogoutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Logout", role: .destructive) {
                    // We'll handle this later
                }
            } message: {
                Text("Are you sure you want to logout?")
            }
        }
    }
}

// MARK: - App Header Component
struct AppHeader: View {
//    also added the authentication model here
    @EnvironmentObject var authenthicationModel: AuthModel
    // added this to make logout show the
    @State var showLogoutConfirmation = false
    var onLogout: (() -> Void)?
    
    var body: some View {
        HStack {
            // App Logo and Title
            HStack(spacing: 8) {
                // Logo placeholder
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.primaryColor)
                    .frame(width: 32, height: 32)
                
                // App Name
                Text("PrepPal")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            // Notification and Profile Menu
            HStack(spacing: 12) {
                // Notification Bell
                Button(action: {
                    // Handle notification button tap
                }) {
                    Image(systemName: "bell")
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .clipShape(Circle())
                }
                
                // Profile / Logout Menu
                Button(action: {
                    showLogoutConfirmation = true
                }) {
                    Image(systemName: "person.circle")
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .clipShape(Circle())
                }
                .alert("Are you sure you want to log out?", isPresented: $showLogoutConfirmation) {
                    Button("Log Out", role: .destructive) {
                        authenthicationModel.signOut()
                    }
                    Button("Cancel", role: .cancel) { }
                }

            }
        }
        .padding(.top, 10)
    }
}

// MARK: - Welcome Banner Component
struct WelcomeBanner: View {
    let userName: String
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.primaryColor,
                    Color(red: 64/255, green: 185/255, blue: 169/255) // Teal-like color
                ]),
                startPoint: .leading,
                endPoint: .trailing
            )
            .cornerRadius(16)
            
            // Content
            VStack(alignment: .leading, spacing: 8) {
                // Greeting
                Text("Hey \(userName)! 👋")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                // Tagline
                Text("Ready to plan your delicious week?")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
                
                Spacer().frame(height: 12)
                
                // Badges
                HStack(spacing: 12) {
                    // Vegan Badge
                    HStack(spacing: 4) {
                        Image(systemName: "leaf.fill")
                            .font(.system(size: 12))
                        Text("Vegan")
                            .font(.caption)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(50)
                    .foregroundColor(.white)
                    
                    // Time Badge
                    HStack(spacing: 4) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 12))
                        Text("15-min")
                            .font(.caption)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(50)
                    .foregroundColor(.white)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: 140)
    }
}

// MARK: - Week Plan Card Component
struct WeekPlanCard: View {
    let mealsPlanned: Int
    let totalMealsNeeded: Int
    
    var body: some View {
        VStack(spacing: 16) {
            // Header row
            HStack {
                Text("This Week's Plan")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                // Progress badge
                Text("\(mealsPlanned)/\(totalMealsNeeded) meals")
                    .font(.caption)
                    .fontWeight(.medium)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.primaryColor.opacity(0.15))
                    .foregroundColor(Color.primaryColor)
                    .cornerRadius(50)
            }
            
            // Progress bar
            ZStack(alignment: .leading) {
                // Background track
                Rectangle()
                    .fill(Color(.systemGray5))
                    .frame(height: 4)
                    .cornerRadius(2)
                
                // Filled portion
                let progressWidth = CGFloat(mealsPlanned) / CGFloat(totalMealsNeeded)
                Rectangle()
                    .fill(Color.primaryColor)
                    .frame(width: UIScreen.main.bounds.width * 0.85 * progressWidth, height: 4)
                    .cornerRadius(2)
            }
            
            // Action buttons
            HStack(spacing: 12) {
                // Grocery list button
                Button(action: {
                    // Handle grocery list button tap
                }) {
                    HStack {
                        Image(systemName: "cart.fill")
                            .font(.system(size: 16))
                        Text("Grocery List")
                            .fontWeight(.medium)
                    }
                    .foregroundColor(Color.primaryColor)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.primaryColor, lineWidth: 1)
                    )
                }
                
                // Add meal button
                Button(action: {
                    // Handle add meal button tap
                }) {
                    HStack {
                        Image(systemName: "fork.knife")
                            .font(.system(size: 16))
                        Text("Add Meal")
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.primaryColor)
                    .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

// MARK: - Suggested Meals Section Component
struct SuggestedMealsSection: View {
    let suggestedMeals: [Meal]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header row
            HStack {
                // Section title with fire icon
                HStack(spacing: 6) {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                    
                    Text("Suggested Meals")
                        .font(.headline)
                        .fontWeight(.bold)
                }
                
                Spacer()
                
                // View all button
                Button(action: {
                    // Handle view all button tap
                }) {
                    Text("View all")
                        .font(.subheadline)
                        .foregroundColor(Color.primaryColor)
                }
            }
            
            // Horizontal scroll of meal cards
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    // Meal cards
                    ForEach(suggestedMeals) { meal in
                        MealCard(meal: meal)
                    }
                }
                .padding(.bottom, 8) // Space for shadow
            }
        }
    }
}

// MARK: - Meal Card Component
struct MealCard: View {
    let meal: Meal
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Meal image with prep time badge
            ZStack(alignment: .topTrailing) {
                // Placeholder image
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .aspectRatio(1.5, contentMode: .fit)
                    .cornerRadius(8)
                    .frame(width: 180)
                
                // Prep time badge
                Text("\(meal.prepTimeMinutes) min")
                    .font(.caption)
                    .fontWeight(.medium)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(4)
                    .padding(8)
            }
            
            // Meal name and description
            VStack(alignment: .leading, spacing: 2) {
                // Meal name
                Text(meal.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                
                // Optional: Add description tooltip on hover/long press
                // Text(meal.mealDescription)
                //     .font(.caption)
                //     .foregroundColor(.secondary)
                //     .lineLimit(1)
            }
            
            // Meal type badge
            if let dietaryType = meal.dietaryType {
                Text(dietaryType)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.gray.opacity(0.1))
                    .foregroundColor(Color.primary.opacity(0.8))
                    .cornerRadius(4)
            } else {
                Text(meal.mealType)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.gray.opacity(0.1))
                    .foregroundColor(Color.primary.opacity(0.8))
                    .cornerRadius(4)
            }
        }
        .frame(width: 180)
        .padding(.bottom, 8)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Expiring Ingredients Alert Component
struct ExpiringIngredientsAlert: View {
    let ingredients: [Ingredient]
    
    var ingredientNames: String {
        if ingredients.count == 1 {
            return ingredients[0].name
        } else if ingredients.count == 2 {
            return "\(ingredients[0].name) and \(ingredients[1].name)"
        } else {
            // More than 2 ingredients - list first two and add "+ more"
            return "\(ingredients[0].name), \(ingredients[1].name), and \(ingredients.count - 2) more"
        }
    }
    
    var body: some View {
        Button(action: {
            // Handle tap to show recipe ideas for these ingredients
        }) {
            HStack(alignment: .center, spacing: 16) {
                // Warning icon
                ZStack {
                    Circle()
                        .fill(Color.orange.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)
                        .font(.system(size: 16))
                }
                
                // Alert text
                VStack(alignment: .leading, spacing: 4) {
                    Text("Ingredients Expiring Soon")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text("Your \(ingredientNames) are about to expire! Tap for recipe ideas.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
            }
            .padding()
            .background(Color.orange.opacity(0.1))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.orange.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Generate Plan Button Component
struct GeneratePlanButton: View {
    var body: some View {
        Button(action: {
            // Handle generate plan button tap
        }) {
            Text("Generate This Week's Plan")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.primaryColor)
                .cornerRadius(12)
                .shadow(color: Color.primaryColor.opacity(0.3), radius: 5, x: 0, y: 3)
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Bottom Tab Bar Component
struct BottomTabBar: View {
    // Enum for tracking active tab
    enum Tab {
        case home, grocery, scan, meals, profile
    }
    
    // Currently selected tab
    let selectedTab: Tab
    
    var body: some View {
        HStack {
            // Home tab
            TabBarButton(
                iconName: "house.fill",
                label: "Home",
                isSelected: selectedTab == .home
            )
            
            // Grocery tab
            TabBarButton(
                iconName: "cart.fill",
                label: "Grocery",
                isSelected: selectedTab == .grocery
            )
            
            // Scan tab
            TabBarButton(
                iconName: "qrcode.viewfinder",
                label: "Scan",
                isSelected: selectedTab == .scan
            )
            
            // Meals tab
            TabBarButton(
                iconName: "calendar",
                label: "Meals",
                isSelected: selectedTab == .meals
            )
            
            // Profile tab
            TabBarButton(
                iconName: "person.fill",
                label: "Profile",
                isSelected: selectedTab == .profile
            )
        }
        .padding(.vertical, 8)
        .padding(.horizontal)
        .background(
            Rectangle()
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 10, y: -5)
        )
    }
}

// MARK: - Tab Bar Button Component
struct TabBarButton: View {
    let iconName: String
    let label: String
    let isSelected: Bool
    
    var body: some View {
        Button(action: {
            // Handle tab selection - would be handled by parent view
        }) {
            VStack(spacing: 4) {
                Image(systemName: iconName)
                    .font(.system(size: 22))
                Text(label)
                    .font(.caption2)
            }
            .foregroundColor(isSelected ? Color.primaryColor : Color.gray)
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    DashboardView()
        .modelContainer(for: [User.self, Meal.self, Ingredient.self], inMemory: true)
} 
