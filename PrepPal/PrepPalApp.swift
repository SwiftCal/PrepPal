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
    @StateObject private var authModel = AuthModel()
    
    //used this to add firebase
    init(){
        FirebaseApp.configure()
    }
    

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authModel)
        }
    }
}
