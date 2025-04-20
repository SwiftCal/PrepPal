//
//  PantryViewModel.swift
//  PrepPal
//
//  Created by Abdulmujeeb Lawal on 4/20/25.
//

import FirebaseFirestore
import FirebaseAuth
import SwiftUI


//basically the same as auth and Ingredients model, would help us interface with firebase for the items in the pantry
@MainActor
class PantryViewModel: ObservableObject {
    @Published var pantryItems: [PantryItem] = []
    private let db = Firestore.firestore()
    private func userPantryCollection() throws -> CollectionReference {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }
        return db.collection("users").document(uid).collection("pantry")
    }


    func fetchPantryItems() {
        Task {
            do {
                let snapshot = try await userPantryCollection().getDocuments()
                let items = try snapshot.documents.compactMap { try $0.data(as: PantryItem.self) }
                pantryItems = items
            } catch {
                print(" Error fetching pantry items:", error)
            }
        }
    }


    func addPantryItem(_ item: PantryItem) {
        Task {
            do {
                _ = try userPantryCollection().addDocument(from: item)
                fetchPantryItems()
            } catch {
                print(" Error adding pantry item:", error)
            }
        }
    }

    func deletePantryItem(_ id: String) {
        Task {
            do {
                try await userPantryCollection().document(id).delete()
                fetchPantryItems()
            } catch {
                print(" Error deleting pantry item:", error)
            }
        }
    }
}
