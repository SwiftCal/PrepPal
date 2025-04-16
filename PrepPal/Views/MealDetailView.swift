//
//  MealDetailView.swift
//  PrepPal
//
//  Created for PrepPal App
//

import SwiftUI
import SwiftData

struct MealDetailView: View {
    // MARK: - Properties
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab = 0
    @State private var isFavorite = false
    
    // MARK: - Sample Data
    let meal = MealDetail(
        id: UUID(),
        name: "Vegan Buddha Bowl",
        description: "A nutritious and colorful plant-based meal",
        prepTime: 10,
        cookTime: 5,
        totalTime: 15,
        dietType: "Vegan",
        ingredients: [
            IngredientSection(
                title: "For the Bowl",
                items: [
                    "1 cup cooked quinoa",
                    "1 cup chickpeas, rinsed and drained",
                    "1 medium sweet potato, cubed and roasted",
                    "1 cup fresh spinach",
                    "1/2 avocado, sliced",
                    "1/4 cup shredded red cabbage",
                    "1/4 cup shredded carrots",
                    "2 tbsp pumpkin seeds"
                ]
            ),
            IngredientSection(
                title: "For the Dressing",
                items: [
                    "2 tbsp tahini",
                    "1 tbsp lemon juice",
                    "1 tbsp maple syrup",
                    "2 tbsp water",
                    "1/4 tsp garlic powder",
                    "Salt and pepper to taste"
                ]
            )
        ],
        instructions: [
            "Preheat oven to 400°F (200°C). Toss cubed sweet potatoes with olive oil, salt, and pepper. Roast for 20-25 minutes until tender.",
            "Cook quinoa according to package instructions. Let cool slightly.",
            "Prepare the dressing by whisking together tahini, lemon juice, maple syrup, water, garlic powder, salt, and pepper until smooth.",
            "In a large bowl, arrange quinoa as the base. Add sections of roasted sweet potatoes, chickpeas, spinach, red cabbage, and carrots.",
            "Top with sliced avocado and pumpkin seeds.",
            "Drizzle with tahini dressing just before serving."
        ],
        chefTips: "For meal prep, keep the dressing separate and add it just before eating. This bowl can be customized with seasonal vegetables based on what you have available.",
        nutritionalInfo: NutritionalInfo(calories: 450, protein: 15, carbs: 65, fat: 18),
        similarRecipes: [
            SimilarRecipe(name: "Quinoa Salad Bowl", prepTime: 10, dietType: "Vegetarian"),
            SimilarRecipe(name: "Mediterranean Bowl", prepTime: 15, dietType: "Vegan"),
            SimilarRecipe(name: "Roasted Veggie Bowl", prepTime: 20, dietType: "Gluten-Free")
        ]
    )
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .bottom) {
            // Main content
            VStack(spacing: 0) {
                // Custom navigation header
                customNavigationHeader
                
                // Scrollable content
                ScrollView {
                    VStack(spacing: 24) {
                        // Meal image with badges
                        mealImageSection
                        
                        // Meal details
                        mealDetailsSection
                            .padding(.horizontal)
                        
                        // Nutritional information button
                        nutritionalInfoButton
                            .padding(.horizontal)
                        
                        // Tabs for Ingredients and Instructions
                        tabSection
                            .padding(.top, 8)
                        
                        // Similar recipes section
                        similarRecipesSection
                            .padding(.top, 16)
                        
                        // Extra space for bottom buttons
                        Spacer()
                            .frame(height: 100)
                    }
                }
                
                // Bottom action buttons
                bottomActionButtons
                
                // Bottom tab bar
                bottomTabBar
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(Color(.systemBackground))
    }
    
    // MARK: - Custom Navigation Header
    private var customNavigationHeader: some View {
        VStack(spacing: 0) {
            // Top row with app name and notification
            HStack {
                Text("PrepPal")
                    .font(.headline)
                    .foregroundColor(Color.prepPalGreen)
                
                Spacer()
                
                Button(action: {
                    // Handle notification action
                }) {
                    Image(systemName: "bell")
                        .foregroundColor(.gray)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
            .padding(.bottom, 4)
            
            // Divider
            Rectangle()
                .fill(Color(.systemGray5))
                .frame(height: 1)
            
            // Back button and title
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                        
                        Text("Meal Detail")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .foregroundColor(.primary)
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
        }
    }
    
    // MARK: - Meal Image Section
    private var mealImageSection: some View {
        ZStack(alignment: .bottomLeading) {
            // Placeholder image
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .aspectRatio(1.5, contentMode: .fit)
                .overlay(
                    Image(systemName: "photo")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                )
            
            // Badges at bottom left
            HStack(spacing: 8) {
                // Vegan badge
                Text(meal.dietType)
                    .font(.caption)
                    .fontWeight(.medium)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.prepPalGreen)
                    .foregroundColor(.white)
                    .cornerRadius(16)
                
                // Time badge
                HStack(spacing: 4) {
                    Text("\(meal.totalTime) min")
                        .font(.caption)
                        .fontWeight(.medium)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
            }
            .padding(16)
        }
    }
    
    // MARK: - Meal Details Section
    private var mealDetailsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Title
            Text(meal.name)
                .font(.title2)
                .fontWeight(.bold)
            
            // Description
            Text(meal.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            
            // Cooking times
            HStack(spacing: 16) {
                cookingTimeItem(title: "Prep", time: meal.prepTime)
                cookingTimeItem(title: "Cook", time: meal.cookTime)
                cookingTimeItem(title: "Total", time: meal.totalTime)
            }
        }
    }
    
    // MARK: - Cooking Time Item
    private func cookingTimeItem(title: String, time: Int) -> some View {
        HStack(spacing: 4) {
            Image(systemName: "clock")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("\(time) min")
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
        }
    }
    
    // MARK: - Nutritional Info Button
    private var nutritionalInfoButton: some View {
        Button(action: {
            // Show nutritional information
        }) {
            HStack {
                Image(systemName: "info.circle")
                    .foregroundColor(Color.prepPalGreen)
                
                Text("View Nutritional Information")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(Color.prepPalGreen)
                
                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.prepPalGreen.opacity(0.5), lineWidth: 1)
                    .background(Color.prepPalGreen.opacity(0.05))
            )
        }
    }
    
    // MARK: - Tab Section
    private var tabSection: some View {
        VStack(spacing: 0) {
            // Custom tab picker
            HStack {
                ForEach(0..<2) { index in
                    Button(action: {
                        withAnimation {
                            selectedTab = index
                        }
                    }) {
                        VStack(spacing: 8) {
                            Text(index == 0 ? "Ingredients" : "Instructions")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(selectedTab == index ? .primary : .secondary)
                                .padding(.vertical, 8)
                            
                            Rectangle()
                                .fill(selectedTab == index ? Color.prepPalGreen : Color.clear)
                                .frame(height: 2)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal)
            
            // Divider
            Rectangle()
                .fill(Color(.systemGray5))
                .frame(height: 1)
            
            // Tab content
            if selectedTab == 0 {
                ingredientsContent
                    .padding(.horizontal)
                    .padding(.top, 16)
            } else {
                instructionsContent
                    .padding(.horizontal)
                    .padding(.top, 16)
            }
        }
    }
    
    // MARK: - Ingredients Content
    private var ingredientsContent: some View {
        VStack(alignment: .leading, spacing: 24) {
            ForEach(meal.ingredients) { section in
                VStack(alignment: .leading, spacing: 12) {
                    // Section title
                    Text(section.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    // Ingredients list
                    ForEach(section.items, id: \.self) { ingredient in
                        HStack(alignment: .top, spacing: 12) {
                            // Bullet point
                            Circle()
                                .fill(Color.prepPalGreen)
                                .frame(width: 8, height: 8)
                                .padding(.top, 6)
                            
                            Text(ingredient)
                                .font(.subheadline)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }
            
            // Add All to Grocery List button
            Button(action: {
                // Add all ingredients to grocery list
            }) {
                HStack {
                    Image(systemName: "cart")
                        .font(.system(size: 14))
                    
                    Text("Add All to Grocery List")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                .foregroundColor(Color.prepPalGreen)
                .padding()
                .frame(maxWidth: .infinity)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.prepPalGreen, lineWidth: 1)
                )
            }
            .padding(.top, 8)
        }
    }
    
    // MARK: - Instructions Content
    private var instructionsContent: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Steps
            ForEach(Array(meal.instructions.enumerated()), id: \.element) { index, instruction in
                HStack(alignment: .top, spacing: 16) {
                    // Step number
                    ZStack {
                        Circle()
                            .fill(Color.prepPalGreen)
                            .frame(width: 28, height: 28)
                        
                        Text("\(index + 1)")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    
                    Text(instruction)
                        .font(.subheadline)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.trailing, 8)
                }
            }
            
            // Chef's Tips
            VStack(alignment: .leading, spacing: 12) {
                Text("Chef's Tips")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text(meal.chefTips)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
        }
    }
    
    // MARK: - Similar Recipes Section
    private var similarRecipesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                Text("Similar Recipes")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(action: {
                    // View all similar recipes
                }) {
                    Text("View all")
                        .font(.subheadline)
                        .foregroundColor(Color.prepPalGreen)
                }
            }
            .padding(.horizontal)
            
            // Recipe cards
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(meal.similarRecipes) { recipe in
                        similarRecipeCard(recipe)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
            }
        }
    }
    
    // MARK: - Similar Recipe Card
    private func similarRecipeCard(_ recipe: SimilarRecipe) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            // Recipe image
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 160, height: 120)
                .cornerRadius(8)
                .overlay(
                    Image(systemName: "photo")
                        .font(.system(size: 24))
                        .foregroundColor(.gray)
                )
            
            // Recipe name
            Text(recipe.name)
                .font(.subheadline)
                .fontWeight(.medium)
                .lineLimit(1)
            
            // Badges
            HStack(spacing: 8) {
                // Time badge
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.system(size: 10))
                    
                    Text("\(recipe.prepTime) min")
                        .font(.caption2)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // Diet type badge
                Text(recipe.dietType)
                    .font(.caption2)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
            }
        }
        .frame(width: 160)
    }
    
    // MARK: - Bottom Action Buttons
    private var bottomActionButtons: some View {
        HStack(spacing: 12) {
            // Add to Grocery List button
            Button(action: {
                // Add to grocery list
            }) {
                HStack {
                    Image(systemName: "cart")
                    Text("Add to Grocery List")
                        .fontWeight(.medium)
                }
                .foregroundColor(Color.prepPalGreen)
                .padding()
                .frame(maxWidth: .infinity)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.prepPalGreen, lineWidth: 1)
                )
            }
            
            // Add to Meal Plan button
            Button(action: {
                // Add to meal plan
            }) {
                HStack {
                    Image(systemName: "fork.knife")
                    Text("Add to Meal Plan")
                        .fontWeight(.medium)
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.prepPalGreen)
                .cornerRadius(8)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 16)
        .background(
            Rectangle()
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 4, y: -2)
        )
    }
    
    // MARK: - Bottom Tab Bar
    private var bottomTabBar: some View {
        HStack {
            tabBarButton(icon: "house", label: "Home", isSelected: false)
            tabBarButton(icon: "cart", label: "Grocery", isSelected: false)
            tabBarButton(icon: "qrcode.viewfinder", label: "Scan", isSelected: false)
            tabBarButton(icon: "fork.knife", label: "Meals", isSelected: true)
            tabBarButton(icon: "person", label: "Profile", isSelected: false)
        }
        .padding(.top, 8)
        .padding(.bottom, 16)
        .background(Color.white)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color(.systemGray5))
                .padding(.bottom, 45),
            alignment: .top
        )
    }
    
    // MARK: - Tab Bar Button
    private func tabBarButton(icon: String, label: String, isSelected: Bool) -> some View {
        Button(action: {
            // Handle tab button action
        }) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                
                Text(label)
                    .font(.caption2)
            }
            .foregroundColor(isSelected ? Color.prepPalGreen : Color.gray)
            .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - Model Structures
struct MealDetail: Identifiable {
    let id: UUID
    let name: String
    let description: String
    let prepTime: Int
    let cookTime: Int
    let totalTime: Int
    let dietType: String
    let ingredients: [IngredientSection]
    let instructions: [String]
    let chefTips: String
    let nutritionalInfo: NutritionalInfo
    let similarRecipes: [SimilarRecipe]
}

struct IngredientSection: Identifiable {
    let id = UUID()
    let title: String
    let items: [String]
}

struct NutritionalInfo {
    let calories: Int
    let protein: Int
    let carbs: Int
    let fat: Int
}

struct SimilarRecipe: Identifiable {
    let id = UUID()
    let name: String
    let prepTime: Int
    let dietType: String
}

// MARK: - Color Extension
extension Color {
    static let prepPalGreen = Color(red: 52/255, green: 168/255, blue: 83/255) // #34A853
}

// MARK: - Preview
struct MealDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MealDetailView()
    }
} 