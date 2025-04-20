//
//  IngredientModel.swift
//  PrepPal
//
//  Created by Abdulmujeeb Lawal on 4/20/25.
//



import Foundation
import FirebaseAuth
import FirebaseFirestore

//This view model helps manage the Ingredients from the generated meals and adding them to the grocery list
class IngredientViewModel: ObservableObject {
    @Published var groceryItems: [GroceryItem] = []
    
    private let db = Firestore.firestore()
    private func userIngredientsCollection() throws -> CollectionReference {
        guard let userID = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "No user ID found", code: 401)
        }
        return db.collection("users").document(userID).collection("ingredients")
    }

    init() {
        listenToIngredients()
    }

    func listenToIngredients() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print(" No user authenticated")
            return
        }

        db.collection("users").document(userID).collection("ingredients")
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print(" Error listening: \(error)")
                    return
                }

                guard let documents = snapshot?.documents else { return }

                self.groceryItems = documents.compactMap { doc in
                    guard let ingredient = try? doc.data(as: NewIngredientItem.self) else { return nil }
                    return GroceryItem(
                        id: doc.documentID,
                        name: ingredient.name,
                        quantity: ingredient.quantity,
                        category: ingredient.category
                    )
                }
            }
    }



    func addIngredient(_ ingredient: NewIngredientItem) {
        Task {
            do {
                let collection = try userIngredientsCollection()
                _ = try collection.addDocument(from: ingredient)
            } catch {
                print("Add error: \(error)")
            }
        }
    }
    
    func addMultipleIngredients(_ ingredients: [NewIngredientItem]) {
        Task {
            do {
                let collection = try userIngredientsCollection()
                for item in ingredients {
                    _ = try collection.addDocument(from: item)
                }
                listenToIngredients()
            } catch {
                print(" Error adding multiple ingredients: \(error)")
            }
        }
    }

    
    func deleteIngredient(id: String) {
        Task {
            do {
                try await userIngredientsCollection().document(id).delete()
            } catch {
                print(" Delete failed: \(error.localizedDescription)")
            }
        }
    }
}
