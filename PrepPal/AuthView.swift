//
//  AuthView.swift
//  PrepPal
//
//  Created for PrepPal App
//

import SwiftUI
import SwiftData

// Define app's primary color
extension Color {
    static let primaryColor = Color(red: 58/255, green: 170/255, blue: 117/255)
}

// Enum to track auth mode
enum AuthMode {
    case login
    case signup
}

struct AuthView: View {
    // authentication object to help use the login, signup and the likes
    @EnvironmentObject var authenthicationModel: AuthModel
    
    
    // State variables
    @State private var authMode: AuthMode = .login
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var fullName: String = ""
    @State private var confirmPassword: String = ""
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    
    // Access to model context for database operations
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    // Callback to inform parent view of authentication status
    var onAuthenticated: (() -> Void)?
    
    // App logo view
    private var logoSection: some View {
        VStack(spacing: 8) {
            // App icon
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.primaryColor)
                .frame(width: 50, height: 50)
            
            // App title
            Text("PrepPal")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            // App tagline
            Text("Meal Planning Made Easy")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding(.bottom, 30)
    }
    
    // Custom text field style
    private func textFieldStyle(placeholder: String, text: Binding<String>, isSecure: Bool = false) -> some View {
        Group {
            if isSecure {
                SecureField(placeholder, text: text)
            } else {
                TextField(placeholder, text: text)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .padding(.bottom, 15)
    }
    
    // Custom segmented control to match design
    private var customSegmentedControl: some View {
        HStack(spacing: 0) {
            // Login tab
            Button(action: {
                withAnimation {
                    authMode = .login
                    // Clear error when switching tabs
                    errorMessage = ""
                    showError = false
                }
            }) {
                Text("Log In")
                    .fontWeight(.medium)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(authMode == .login ? Color.primaryColor : Color(.systemGray5))
                    .foregroundColor(authMode == .login ? .white : .primary)
            }
            .cornerRadius(8, corners: [.topLeft, .bottomLeft])
            
            // Sign Up tab
            Button(action: {
                withAnimation {
                    authMode = .signup
                    // Clear error when switching tabs
                    errorMessage = ""
                    showError = false
                }
            }) {
                Text("Sign Up")
                    .fontWeight(.medium)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(authMode == .signup ? Color.primaryColor : Color(.systemGray5))
                    .foregroundColor(authMode == .signup ? .white : .primary)
            }
            .cornerRadius(8, corners: [.topRight, .bottomRight])
        }
        .cornerRadius(8)
        .padding(.horizontal)
        .padding(.bottom, 30)
    }
    
    // Login form
    private var loginForm: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header text
            VStack(alignment: .leading, spacing: 8) {
                Text("Welcome back!")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Log in to continue planning your meals")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.bottom, 10)
            
            // Email field
            textFieldStyle(placeholder: "your@email.com", text: $email)
            
            // Password field with forgot password link
            VStack(alignment: .trailing) {
                textFieldStyle(placeholder: "••••••••", text: $password, isSecure: true)
                
                Button(action: {
                    // Handle forgot password
                    handleForgotPassword()
                }) {
                    Text("Forgot Password?")
                        .font(.footnote)
                        .foregroundColor(.primaryColor)
                }
            }
            
            // Error message (if present)
            if showError && !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.footnote)
                    .padding(.top, 5)
            }
            
            // Login button
            Button(action: {
                authenthicationModel.logIn(email: email, password: password)
            }) {
                HStack {
                    Text("Log In")
                        .fontWeight(.semibold)
                    Spacer()
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.primaryColor)
                .cornerRadius(10)
            }
            .padding(.top, 20)
        }
        .padding(.horizontal)
    }
    
    // Sign up form
    private var signupForm: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header text
            VStack(alignment: .leading, spacing: 8) {
                Text("Create an account")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Start planning your delicious meals")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.bottom, 10)
            
            // Full name field
            textFieldStyle(placeholder: "Alex Johnson", text: $fullName)
            
            // Email field
            textFieldStyle(placeholder: "your@email.com", text: $email)
            
            // Password field
            textFieldStyle(placeholder: "••••••••", text: $password, isSecure: true)
            
            // Confirm password field
            textFieldStyle(placeholder: "••••••••", text: $confirmPassword, isSecure: true)
            
            // Error message (if present)
            if showError && !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.footnote)
                    .padding(.top, 5)
            }
            
            // Sign up button
            Button(action: {
                // handleLogin()
                // i replaced this with the authenication model signup function
                authenthicationModel.signUp(email: email, password: password, fullname: fullName )
            }) {
                HStack {
                    Text("Sign Up")
                        .fontWeight(.semibold)
                    Spacer()
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.primaryColor)
                .cornerRadius(10)
            }
            .padding(.top, 20)
        }
        .padding(.horizontal)
    }
    
    // MARK: - Authentication Methods
    
//    // Handle login attempt
//    private func handleLogin() {
//        // Validate fields
//        guard !email.isEmpty else {
//            setError("Please enter your email")
//            return
//        }
//        
//        guard !password.isEmpty else {
//            setError("Please enter your password")
//            return
//        }
//        
//        // In a real app, you would query the database to find the user
//        // For demo purposes, we'll just simulate a successful login
//        
//        // Simulate successful login
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            // Call the onAuthenticated callback to inform parent view
//            onAuthenticated?()
//        }
//    }
    
//    // Handle signup attempt
//    private func handleSignup() {
//        // Validate fields
//        guard !fullName.isEmpty else {
//            setError("Please enter your full name")
//            return
//        }
//        
//        guard !email.isEmpty, email.contains("@") else {
//            setError("Please enter a valid email address")
//            return
//        }
//        
//        guard !password.isEmpty, password.count >= 6 else {
//            setError("Password must be at least 6 characters")
//            return
//        }
//        
//        guard password == confirmPassword else {
//            setError("Passwords do not match")
//            return
//        }
//        
//        // Create a new User (in a real app, you would hash the password)
//        let newUser = User(fullName: fullName, email: email, passwordHash: password)
//        
//        // Add to database
//        modelContext.insert(newUser)
//        
//        // Save the changes
//        do {
//            try modelContext.save()
//            
//            // Call the onAuthenticated callback to inform parent view
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                onAuthenticated?()
//            }
//        } catch {
//            setError("Error creating account: \(error.localizedDescription)")
//        }
//    }
    
    // Handle forgot password
    private func handleForgotPassword() {
        // In a real app, this would initiate a password reset flow
        // For this demo, we'll just show a message
        setError("Password reset functionality would be implemented here")
    }
    
    // Helper to set error message and show it
    private func setError(_ message: String) {
        errorMessage = message
        showError = true
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Logo and app info
                logoSection
                
                // Custom segmented control
                customSegmentedControl
                
                // Show the appropriate form based on selected mode
                if authMode == .login {
                    loginForm
                } else {
                    signupForm
                }
                
                Spacer()
            }
            .padding(.top, 60)
            .background(Color.white)
            .edgesIgnoringSafeArea(.all)
            .navigationBarItems(leading: 
                Button(action: {
                    dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(.gray)
                }
            )
        }
    }
}

// Extension for rounded corners on specific sides
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

// Custom shape for rounded corners on specific sides
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

// Custom navigation button style
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.primaryColor)
                    .opacity(configuration.isPressed ? 0.8 : 1)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
    }
}

#Preview {
    AuthView(onAuthenticated: nil)
        .modelContainer(for: User.self, inMemory: true)
}
