//
//  User.swift
//  PrepPal
//
//  Created for PrepPal App
//

import Foundation
import SwiftData

@Model
final class User {
    var id: UUID
    var fullName: String
    var email: String
    var passwordHash: String // In a real app, we'd store a hash, not plaintext
    var createdAt: Date
    
    init(fullName: String, email: String, passwordHash: String) {
        self.id = UUID()
        self.fullName = fullName
        self.email = email
        self.passwordHash = passwordHash
        self.createdAt = Date()
    }
} 
