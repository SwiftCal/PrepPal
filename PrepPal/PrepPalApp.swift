//
//  PrepPalApp.swift
//  PrepPal
//
//  Created by Ifeoluwakiitan Ayandosu on 4/8/25.
//

import SwiftUI
import SwiftData
import FirebaseCore

@main
struct PrepPalApp: App {
    @StateObject private var authenthicationModel = AuthModel()
    
    //used this to add firebase
    init(){
        FirebaseApp.configure()
    }
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            User.self,
            Meal.self,
            Ingredient.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(authenthicationModel)
        }
        .modelContainer(sharedModelContainer)
    }
}
