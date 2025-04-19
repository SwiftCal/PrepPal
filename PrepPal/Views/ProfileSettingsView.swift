//
//  ProfileSettingsView.swift
//  PrepPal
//
//  Created for PrepPal App
//

import SwiftUI

struct ProfileSettingsView: View {
    // MARK: - Properties
    @EnvironmentObject var authModel: AuthModel
    @Environment(\.dismiss) private var dismiss
    
    // State properties for toggles
    @State private var isVegan = true
    @State private var isVegetarian = false
    @State private var isGlutenFree = false
    @State private var isDairyFree = true
    
    @State private var enableMealReminders = true
    @State private var enableExpiringIngredients = true
    @State private var enableWeeklyPlanUpdates = true
    
    @State private var enableDarkMode = false
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Profile header
                profileHeader
                
                // Account settings section
                settingsSection(title: "ACCOUNT") {
                    settingsCard {
                        navigationRow(icon: "person.fill", title: "Personal Information")
                        
                        Divider()
                            .padding(.leading, 52)
                        
                        logoutRow
                    }
                }
                
                // Dietary preferences section
                settingsSection(title: "DIETARY PREFERENCES") {
                    settingsCard {
                        toggleRow(icon: "leaf.fill", title: "Vegan", isOn: $isVegan)
                        
                        Divider()
                            .padding(.leading, 52)
                        
                        toggleRow(icon: "leaf", title: "Vegetarian", isOn: $isVegetarian)
                        
                        Divider()
                            .padding(.leading, 52)
                        
                        toggleRow(icon: "allergens", title: "Gluten-Free", isOn: $isGlutenFree)
                        
                        Divider()
                            .padding(.leading, 52)
                        
                        toggleRow(icon: "drop.fill", title: "Dairy-Free", isOn: $isDairyFree)
                    }
                }
                
                // Notification settings section
                settingsSection(title: "NOTIFICATIONS") {
                    settingsCard {
                        toggleRow(icon: "bell.fill", title: "Meal Reminders", isOn: $enableMealReminders)
                        
                        Divider()
                            .padding(.leading, 52)
                        
                        toggleRow(icon: "exclamationmark.triangle.fill", title: "Expiring Ingredients", isOn: $enableExpiringIngredients)
                        
                        Divider()
                            .padding(.leading, 52)
                        
                        toggleRow(icon: "calendar.badge.clock", title: "Weekly Plan Updates", isOn: $enableWeeklyPlanUpdates)
                    }
                }
                
                // App settings section
                settingsSection(title: "APP SETTINGS") {
                    settingsCard {
                        toggleRow(icon: "moon.fill", title: "Dark Mode", isOn: $enableDarkMode)
                        
                        Divider()
                            .padding(.leading, 52)
                        
                        navigationRow(icon: "questionmark.circle.fill", title: "Help & Support")
                        
                        Divider()
                            .padding(.leading, 52)
                        
                        navigationRow(icon: "envelope.fill", title: "Send Feedback")
                    }
                }
                
                // App version
                Text("PrepPal v1.2.0")
                    .font(.caption2)
                    .foregroundColor(Color.gray.opacity(0.7))
                    .padding(.top, 16)
                    .padding(.bottom, 16)
            }
            .padding(.horizontal)
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Profile Header
    private var profileHeader: some View {
        ZStack {
            // Background
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.prepPalGreen)
            
            // Content
            HStack(spacing: 16) {
                // Avatar with edit button
                ZStack(alignment: .bottomTrailing) {
                    // Avatar circle
                    Circle()
                        .fill(Color.white)
                        .frame(width: 70, height: 70)
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.system(size: 32))
                                .foregroundColor(Color.prepPalGreen)
                        )
                    
                    // Edit button
                    Circle()
                        .fill(Color.white)
                        .frame(width: 24, height: 24)
                        .overlay(
                            Image(systemName: "pencil")
                                .font(.system(size: 12))
                                .foregroundColor(Color.prepPalGreen)
                        )
                        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                }
                
                // User info
                VStack(alignment: .leading, spacing: 4) {
                    Text("Alex Johnson")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("alex.johnson@example.com")
                        .font(.subheadline)
                        .foregroundColor(Color.white.opacity(0.9))
                }
                
                Spacer()
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 16)
        }
    }
    
    // MARK: - Logout Row
    private var logoutRow: some View {
        Button(action: {
            // Sign out the user
            authModel.signOut()
        }) {
            HStack {
                // Icon
                Image(systemName: "arrow.right.square")
                    .font(.system(size: 20))
                    .foregroundColor(Color.prepPalGreen)
                    .frame(width: 36, height: 36)
                
                // Title
                Text("Log Out")
                    .font(.body)
                    .foregroundColor(.primary)
                
                Spacer()
                
                // Chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(Color.gray.opacity(0.5))
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Settings Section
    private func settingsSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            // Section title
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(Color.gray.opacity(0.7))
                .padding(.leading, 4)
            
            // Section content
            content()
        }
    }
    
    // MARK: - Settings Card
    private func settingsCard<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        VStack(spacing: 0) {
            content()
        }
        .padding(.vertical, 4)
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
    
    // MARK: - Navigation Row
    private func navigationRow(icon: String, title: String) -> some View {
        Button(action: {
            // Navigate to destination (Not implemented in this example)
        }) {
            HStack {
                // Icon
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(Color.prepPalGreen)
                    .frame(width: 36, height: 36)
                
                // Title
                Text(title)
                    .font(.body)
                    .foregroundColor(.primary)
                
                Spacer()
                
                // Chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(Color.gray.opacity(0.5))
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Toggle Row
    private func toggleRow(icon: String, title: String, isOn: Binding<Bool>) -> some View {
        HStack {
            // Icon
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(Color.prepPalGreen)
                .frame(width: 36, height: 36)
            
            // Title
            Text(title)
                .font(.body)
                .foregroundColor(.primary)
            
            Spacer()
            
            // Toggle
            Toggle("", isOn: isOn)
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: Color.prepPalGreen))
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
    }
}

// MARK: - Preview
struct ProfileSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileSettingsView()
                .environmentObject(AuthModel())
        }
    }
} 