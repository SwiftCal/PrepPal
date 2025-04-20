//
//  MealService.swift
//  PrepPal
//
//  Created by Abdulmujeeb Lawal on 4/20/25.
//

import FirebaseFirestore
import FirebaseAuth

class MealService {
    private let db = Firestore.firestore()

    // Helper to get user-specific collection path
    private func userMealsCollection() throws -> CollectionReference {
        guard let userID = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "No user ID found", code: 401)
        }
        return db.collection("users").document(userID).collection("meals")
    }

    func fetchMeals() async throws -> [MealPageItem] {
        let snapshot = try await userMealsCollection().getDocuments()
        return try snapshot.documents.compactMap { try $0.data(as: MealPageItem.self) }
    }

    func addMeal(_ meal: MealPageItem) async throws {
        _ = try userMealsCollection().addDocument(from: meal)
    }

    func addRandomMeal() async throws -> MealPageItem {
        let imagePool = [
            "https://www.summahealth.org/-/media/project/summahealth/website/page-content/flourish/2_18a_fl_fastfood_400x400.webp?la=en&h=400&w=400&hash=145DC0CF6234A159261389F18A36742A",
            "https://www.usatoday.com/gcdn/authoring/authoring-images/2024/08/17/USAT/74841114007-red-robin-gourmet-cheeseburger-social-23.jpg?crop=1198,674,x0,y317&width=660&height=371&format=pjpg&auto=webp",
            "https://food.fnr.sndimg.com/content/dam/images/food/fullset/2014/4/11/0/FNM_050114-French-Macaroons-Recipe_s4x3.jpg.rend.hgtvcom.1280.960.suffix/1396993185599.webp",
            "https://images.immediate.co.uk/production/volatile/sites/30/2020/08/chorizo-mozarella-gnocchi-bake-cropped-9ab73a3.jpg?quality=90&resize=556,505",
            "https://www.precisionorthomd.com/wp-content/uploads/2023/10/percision-blog-header-junk-food-102323.jpg",
            "https://hungrybynature.com/wp-content/uploads/2017/09/pinch-of-yum-workshop-19.jpg",
            "https://eatatfig.com/wp-content/uploads/2024/02/Food_Black-Bass-6-LHS-768x512.jpg",
            "https://neat-food.com/cdn/shop/files/neat_emmapharaoh_19march24_12.jpg?v=1712845654&width=4498"
        ]

        let newMeal = MealPageItem(
            id: UUID().uuidString,
            name: "Random Bowl \(Int.random(in: 1...100))",
            subtitle: "A surprise dish to spice up your week",
            type: "Vegetarian",
            imageUrl: imagePool.randomElement()!,
            prepTime: Int.random(in: 5...15),
            cookTime: Int.random(in: 10...25),
            chefTips: "Customize with your favorite toppings!",
            sections: [
                MealSection(title: "Bowl Base", ingredients: [
                    NewIngredientItem(name: "Quinoa", quantity: "1 Cup", category: "Grains"),
                    NewIngredientItem(name: "Chickpeas", quantity: "1 Cup", category: "Protein")
                ]),
                MealSection(title: "Toppings", ingredients: [
                    NewIngredientItem(name: "Avocado", quantity: "1/2", category: "Fruit"),
                    NewIngredientItem(name: "Spinach", quantity: "1 Cup", category: "Greens")
                ])
            ],
            instructions: [
                "Cook quinoa and chickpeas.",
                "Add to a bowl with toppings.",
                "Drizzle dressing and enjoy."
            ]
        )

        try await addMeal(newMeal)
        return newMeal
    }
}



