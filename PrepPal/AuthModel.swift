
import FirebaseAuth
import FirebaseFirestore
import Foundation
import SwiftUI

//The idea of this is that we'd be able to import it anywhere and refer to the fucntions defined here
class AuthModel: ObservableObject {
    
    @Published var user: FirebaseAuth.User? // published basically means other files would react if there's a change
    private var db = Firestore.firestore()

    
    init() {
        self.user = Auth.auth().currentUser
        _ = Auth.auth().addStateDidChangeListener { _, user in
            self.user = user
        }
    }

    
    func signUp(email: String, password: String, dietaryPrefs: [String] = []) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Signup error: \(error.localizedDescription)")
                return
            }
            guard let user = result?.user else { return }

            // this would store the user items in a collection in firebase
            self.db.collection("users").document(user.uid).setData([
                "id": user.uid,
                "email": email,
                "dietaryPrefs": dietaryPrefs
            ])
        }
    }

    
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Couldn't login: \(error.localizedDescription)")
            }
        }
    }

    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Couldn't sign: \(error.localizedDescription)")
        }
    }
}
