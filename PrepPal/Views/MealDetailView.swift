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
    let mealpageitem: MealPageItem
    @EnvironmentObject var ingredientsModel: IngredientViewModel

    // MARK: - Sample Data
        var meal: MealDetail {
            MealDetail(
                id: mealpageitem.id ?? UUID().uuidString,
                name: mealpageitem.name,
                description: mealpageitem.subtitle,
                prepTime: mealpageitem.prepTime,
                cookTime: mealpageitem.cookTime,
                totalTime: mealpageitem.prepTime + mealpageitem.cookTime,
                dietType: mealpageitem.type,
                ingredients: mealpageitem.sections.map {
                    IngredientSection(
                        title: $0.title,
                        items: $0.ingredients.map { "\($0.quantity) \($0.name)" }
                    )
                },
                instructions: mealpageitem.instructions,
                chefTips: mealpageitem.chefTips ?? ""
            )
        }

    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
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
                    
                    // // Similar recipes section
                    // similarRecipesSection
                    //     .padding(.top, 16)
                    
                    // Extra space for bottom buttons
                    Spacer()
                        .frame(height: 100)
                }
            }
            
            // Bottom action buttons
            bottomActionButtons
        }
        .background(Color(.systemBackground))
        .navigationTitle("Meal Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Meal Image Section
// MARK: - Meal Image Section
private var mealImageSection: some View {
    ZStack(alignment: .bottomLeading) {
        // Image container with fixed aspect ratio
        AsyncImage(url: URL(string: mealpageitem.imageUrl)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .overlay(
                    Image(systemName: "photo")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                )
        }
        .frame(
            width: UIScreen.main.bounds.width,
            height: 280
        )
        .clipped()
        .cornerRadius(8)

        
        // Semi-transparent gradient overlay to ensure badges are visible
        LinearGradient(
            gradient: Gradient(colors: [Color.black.opacity(0.0), Color.black.opacity(0.3)]),
            startPoint: .top,
            endPoint: .bottom
        )
        .cornerRadius(8)
        
        // Badges at bottom left
        HStack(spacing: 8) {
            // Vegan badge
            Text(meal.dietType)
                .font(.caption)
                .fontWeight(.semibold)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.prepPalGreen)
                .foregroundColor(.white)
                .cornerRadius(16)
            
            // Time badge
            HStack(spacing: 4) {
                Image(systemName: "clock")
                    .font(.caption)
                Text("\(meal.totalTime) min")
                    .font(.caption)
                    .fontWeight(.semibold)
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
    .frame(maxWidth: .infinity)
    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
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
                let allIngredients: [NewIngredientItem] = mealpageitem.sections.flatMap { $0.ingredients }
                ingredientsModel.addMultipleIngredients(allIngredients)
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
    
    // // MARK: - Similar Recipes Section
    // private var similarRecipesSection: some View {
    //     VStack(alignment: .leading, spacing: 16) {
    //         // Header
    //         HStack {
    //             Text("Similar Recipes")
    //                 .font(.headline)
    //                 .fontWeight(.bold)
                
    //             Spacer()
                
    //             Button(action: {
    //                 // View all similar recipes
    //             }) {
    //                 Text("View all")
    //                     .font(.subheadline)
    //                     .foregroundColor(Color.prepPalGreen)
    //             }
    //         }
    //         .padding(.horizontal)
            
    //         // Recipe cards
    //         ScrollView(.horizontal, showsIndicators: false) {
    //             HStack(spacing: 16) {
    //                 ForEach(meal.similarRecipes) { recipe in
    //                     similarRecipeCard(recipe)
    //                 }
    //             }
    //             .padding(.horizontal)
    //             .padding(.bottom, 8)
    //         }
    //     }
    // }
    
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
                let allIngredients: [NewIngredientItem] = mealpageitem.sections.flatMap { $0.ingredients }
                ingredientsModel.addMultipleIngredients(allIngredients)
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
}

// MARK: - Model Structures
struct MealDetail: Identifiable {
    let id: String
    let name: String
    let description: String
    let prepTime: Int
    let cookTime: Int
    let totalTime: Int
    let dietType: String
    let ingredients: [IngredientSection]
    let instructions: [String]
    let chefTips: String
//    let nutritionalInfo: NutritionalInfo
    // let similarRecipes: [SimilarRecipe]
}

struct IngredientSection: Identifiable {
    let id = UUID()
    let title: String
    let items: [String]
}

//struct NutritionalInfo {
//    let calories: Int
//    let protein: Int
//    let carbs: Int
//    let fat: Int
//}

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

struct MealDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        MealDetailView(mealpageitem: sampleMealPageItem)
    }

    static var sampleMealPageItem: MealPageItem {
        MealPageItem(
            id: UUID().uuidString,
            name: "Vegan Buddha Bowl",
            subtitle: "A nutritious and colorful plant‑based meal",
            type: "Vegan",
            imageUrl: "https://www.noracooks.com/wp-content/uploads/2019/07/IMG_6602.jpg",
            prepTime: 10,
            cookTime: 5,
            chefTips: "Put the fries in the bag lil bro",
            sections: [
                MealSection(title: "Salad", ingredients: [
                    NewIngredientItem(name: "Mixed greens", quantity: "4 Cups", category: "Protein"),
                    NewIngredientItem(name: "Cherry tomatoes", quantity: "1 Cups", category: "Vegetable")
                ]),
                MealSection(title: "Dressing", ingredients: [
                    NewIngredientItem(name: "Tahini", quantity: "2 Oz", category: "Fat"),
                    NewIngredientItem(name: "Lemon juice", quantity: "1 Cups", category: "Liquid"),
                    NewIngredientItem(name: "Maple syrup", quantity: "1 Oz", category: "Sweetener")
                ])
            ],
            instructions: [
                "Preheat oven to 400°F...",
                "Cook quinoa...",
                "Whisk tahini with lemon juice...",
                "Assemble the bowl...",
                "Add toppings...",
                "Drizzle dressing."
            ]
        )
    }
}
