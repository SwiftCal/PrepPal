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
    @StateObject private var userViewModel = UserViewModel()
    @State private var userName: String = ""

    // Query for fetching user data
//    @Query private var users: [User]
    @Query private var ingredients: [Ingredient]
    
    // State variables
    @State private var mealsPlanned: Int = 3
    @State private var totalMealsNeeded: Int = 5
    @State private var showLogoutAlert: Bool = false
    @State private var meals: [MealPageItem] = []
    
    // Ireplaced suggested meals with the new onse from firebase
    private var suggestedMeals: [MealPageItem] {
        meals
    }

    // Computed property for expiring ingredients
    private var expiringIngredients: [Ingredient] {
        return ingredients.filter { $0.isExpiringSoon }
    }
    
    private func loadMealsFromFirestore() {
    Task {
        do {
            let fetchedMeals = try await MealService().fetchMeals()
            meals = fetchedMeals
        } catch {
            print(" Failed to fetch meals: \(error)")
        }
    }
}

    
    var body: some View {
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
                GeneratePlanButton {
                    Task {
                        do {
                            let randomMeal = try await MealService().addRandomMeal()
                            meals.append(randomMeal)
                        } catch {
                            print(" Failed to generate meal: \(error)")
                        }
                    }
                }

            }
            .padding(.horizontal)
        }
        .background(Color(.systemBackground))
        .onAppear {
            loadMealsFromFirestore()
            userViewModel.fetchUserName { name in
                if let name = name {
                    userName = name
                }
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

                NavigationLink(destination: ProfileSettingsView()) {
                    Image(systemName: "person.circle")
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .clipShape(Circle())
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

                NavigationLink(destination: GroceryListView()) {
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
    let suggestedMeals: [MealPageItem]
    
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
                    ForEach(suggestedMeals.reversed()) { item in
                        MealCard(meal: item)
                    }
                }
                .padding(.bottom, 8) // Space for shadow
            }
        }
    }
}

// MARK: - Meal Card Component
struct MealCard: View {
//    let meal: Meal
    @StateObject var ingredientsModel = IngredientViewModel()
    let meal: MealPageItem
    
    var body: some View {
        NavigationLink(destination: MealDetailView(mealpageitem: meal).environmentObject(ingredientsModel)) {
            VStack(alignment: .leading, spacing: 8) {
                // Meal image with prep time badge
                ZStack(alignment: .topTrailing) {
                    // Placeholder image
                    AsyncImage(url: URL(string: meal.imageUrl)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                    }
                    .aspectRatio(1.5, contentMode: .fit)
                    .frame(width: 180, height: 120)
                    .clipped()
                    .cornerRadius(8)

                    
                    // Prep time badge
                    Text("\(meal.prepTime + meal.cookTime) min")
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
                        .foregroundColor(.primary)
                    
                    // Optional: Add description tooltip on hover/long press
                    // Text(meal.mealDescription)
                    //     .font(.caption)
                    //     .foregroundColor(.secondary)
                    //     .lineLimit(1)
                }
                
                // Meal type badge

                Text(meal.type)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.gray.opacity(0.1))
                        .foregroundColor(Color.primary.opacity(0.8))
                        .cornerRadius(4)

            }
        }
        .buttonStyle(PlainButtonStyle())
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
    var onGenerate: () -> Void

    var body: some View {
        Button(action: {
            onGenerate()
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


#Preview {
    DashboardView()
        .modelContainer(for: [User.self, Meal.self, Ingredient.self], inMemory: true)
} 
