//
//  UserViewModel.swift
//  PrepPal
//
//  Created by Abdulmujeeb Lawal on 4/20/25.
//


import FirebaseFirestore
import FirebaseAuth

//also a view model, this only gets the username for us now, we could maybe add email to the profile page later though 
class UserViewModel: ObservableObject {
    private let db = Firestore.firestore()

    func fetchUserName(completion: @escaping (String?) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }

        db.collection("users").document(userID).getDocument { snapshot, error in
            if let error = error {
                print(" Error fetching user name: \(error)")
                completion(nil)
                return
            }

            if let data = snapshot?.data(), let name = data["fullname"] as? String {
                completion(name)
            } else {
                completion(nil)
            }
        }
    }
}
