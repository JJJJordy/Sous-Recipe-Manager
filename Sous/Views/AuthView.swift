//
//  AuthView.swift
//  Sous
//
//  Created by Jordan Purcell on 2026-03-17.
//
// Depends on:
// - Utils/SousTheme.swift (colour tokens)
// - Utils/Color+Hex.swift (hex initialiser)
//

import SwiftUI

// MARK: - Auth Coordinator
// Controls whether Sign Up or Log In is shown

struct AuthView: View {
    @State private var showLogin = false
    
    var body: some View {
        ZStack {
            if showLogin {
                LoginView(onSwitchToSignUp: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showLogin = false
                    }
                })
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)
                                       ))
            } else {
                SignUpView(onSwitchToLogin: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showLogin = true
                    }
                })
                .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)
                                       ))
            }
        }
    }
}

// MARK: - Sign Up View

struct SignUpView: View {
    var onSwitchToLogin: () -> Void
    
    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var agreedTerms: Bool = false
    @State private var cardOffSet: CGFloat = 500
    @State private var topOpacity: Double = 0
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                // --- Terracotta Background ---
                SousTheme.terracotta.ignoresSafeArea()
                
                // --- Top area: back arrow + app name ---
                VStack(alignment: .leading, spacing: 12) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(SousTheme.cream)
                        .padding(.top, geo.safeAreaInsets.top + 16)
                    
                    Text("Sous")
                        .font(.custom("Georgia", size: 28))
                        .tracking(3)
                        .foregroundColor(SousTheme.cream)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 28)
                .opacity(topOpacity)
                .frame(maxHeight: .infinity, alignment: .top)
                
                // --- Cream card ---
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        
                        // Heading
                        Text("Create\nAccount.")
                            .font(.custom("Georgia", size: 32))
                            .foregroundColor(SousTheme.espresso)
                            .lineSpacing(6)
                            .padding(.top, 40)
                            .padding(.horizontal, 28)
                        
                        Text("Start saving your favourite recipes.")
                            .font(.system(size: 13))
                            .foregroundColor(SousTheme.taupe)
                            .padding(.top, 8)
                            .padding(.horizontal, 28)
                        
                        // Input Fields
                        VStack(spacing: 28) {
                            SousInputField(placeholder: "Full Name", text: $fullName, isSecure: false)
                            SousInputField(placeholder: "Email", text: $email, isSecure: false, keyboardType: .emailAddress)
                            SousInputField(placeholder: "Password", text: $password, isSecure: true)
                            SousInputField(placeholder: "Confirm Password", text:$confirmPassword, isSecure: true)
                        }
                        .padding(.top, 32)
                        .padding(.horizontal, 28)
                        
                        // Terms checkbox
                        HStack(spacing: 10) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 3)
                                    .stroke(SousTheme.sand, lineWidth: 1)
                                    .frame(width: 16, height: 16)
                                if agreedTerms {
                                    RoundedRectangle(cornerRadius: 3)
                                        .fill(SousTheme.terracotta)
                                        .frame(width: 16, height: 16)
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 9, weight: .bold))
                                        .foregroundColor(SousTheme.cream)
                                }
                            }
                            .onTapGesture { agreedTerms.toggle() }
 
                            Text("Agree to terms and conditions")
                                .font(.system(size: 12))
                                .foregroundColor(SousTheme.taupe)
                        }
                        .padding(.top, 28)
                        .padding(.horizontal, 28)
                        
                        // Sign Up button
                        Button {
                            // TODO: handle sign up
                        } label: {
                            Text("Sign Up")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(SousTheme.cream)
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(SousTheme.espresso)
                                .cornerRadius(8)
                        }
                        .padding(.top, 24)
                        .padding(.horizontal, 28)
                        
                        // Switch to login
                        HStack(spacing: 4) {
                            Text("Already have an account?")
                                .font(.system(size: 12))
                                .foregroundColor(SousTheme.sand)
                            Button("Sign in") {
                                onSwitchToLogin()
                            }
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(SousTheme.terracotta)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 20)
                        .padding(.bottom, geo.safeAreaInsets.bottom + 32)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .background(SousTheme.cream)
                .clipShape(RoundedCornerShape(radius: 28, corners: [.topLeft, .topRight]))
                .padding(.top, 130)
                .offset(y: cardOffSet)
            }
        }
        .ignoresSafeArea()
        .onAppear { runEntrance() }
    }
    private func runEntrance() {
        withAnimation(.easeOut(duration: 0.3).delay(0.05)) {
            topOpacity = 1
        }
        withAnimation(.spring(response: 0.55, dampingFraction: 0.78).delay(0.1)) {
            cardOffSet = 0
        }
    }
}

// MARK: - Log In View
struct LoginView: View {
    var onSwitchToSignUp: () -> Void
    
    @State private var email:       String  = ""
    @State private var password:    String  = ""
    @State private var rememberMe:  Bool    = true
    @State private var cardOffset:  CGFloat = 500
    @State private var topOpacity:  Double  = 0
 
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
 
                // ─── Terracotta background ─────────────────────────
                SousTheme.terracotta
                    .ignoresSafeArea()
 
                // ─── Top area: back arrow + app name ──────────────
                VStack(alignment: .leading, spacing: 12) {
                    Button(action: onSwitchToSignUp) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(SousTheme.cream)
                    }
                    .padding(.top, geo.safeAreaInsets.top + 16)
 
                    Text("Sous")
                        .font(.custom("Georgia", size: 28))
                        .tracking(3)
                        .foregroundColor(SousTheme.cream)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 28)
                .opacity(topOpacity)
                .frame(maxHeight: .infinity, alignment: .top)
 
                // ─── Cream card ────────────────────────────────────
                VStack(alignment: .leading, spacing: 0) {
 
                    // Heading
                    Text("Welcome\nBack.")
                        .font(.custom("Georgia", size: 32))
                        .foregroundColor(SousTheme.espresso)
                        .lineSpacing(6)
                        .padding(.top, 40)
                        .padding(.horizontal, 28)
 
                    Text("Continue your culinary adventure.")
                        .font(.system(size: 13))
                        .foregroundColor(SousTheme.taupe)
                        .padding(.top, 8)
                        .padding(.horizontal, 28)
 
                    // Input fields
                    VStack(spacing: 28) {
                        SousInputField(
                            placeholder: "Email",
                            text: $email,
                            isSecure: false,
                            keyboardType: .emailAddress
                        )
                        SousInputField(
                            placeholder: "Password",
                            text: $password,
                            isSecure: true,
                            showEye: true
                        )
                    }
                    .padding(.top, 32)
                    .padding(.horizontal, 28)
 
                    // Remember me
                    HStack(spacing: 10) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 3)
                                .stroke(SousTheme.sand, lineWidth: 1)
                                .frame(width: 16, height: 16)
                            if rememberMe {
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(SousTheme.terracotta)
                                    .frame(width: 16, height: 16)
                                Image(systemName: "checkmark")
                                    .font(.system(size: 9, weight: .bold))
                                    .foregroundColor(SousTheme.cream)
                            }
                        }
                        .onTapGesture { rememberMe.toggle() }
 
                        Text("Remember me")
                            .font(.system(size: 12))
                            .foregroundColor(SousTheme.taupe)
                    }
                    .padding(.top, 28)
                    .padding(.horizontal, 28)
 
                    // Sign In button
                    Button {
                        // TODO: handle login
                    } label: {
                        Text("Sign In")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(SousTheme.cream)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(SousTheme.espresso)
                            .cornerRadius(8)
                    }
                    .padding(.top, 24)
                    .padding(.horizontal, 28)
 
                    // Forgot password
                    HStack {
                        Spacer()
                        Button("Forgot password?") {
                            // TODO: handle forgot password
                        }
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(SousTheme.terracotta)
                    }
                    .padding(.top, 14)
                    .padding(.horizontal, 28)
 
                    // Divider
                    HStack(spacing: 12) {
                        Rectangle()
                            .fill(SousTheme.blush)
                            .frame(height: 1)
                        Text("or")
                            .font(.system(size: 12))
                            .foregroundColor(SousTheme.sand)
                        Rectangle()
                            .fill(SousTheme.blush)
                            .frame(height: 1)
                    }
                    .padding(.top, 24)
                    .padding(.horizontal, 28)
 
                    // Social buttons
                    HStack(spacing: 12) {
                        SousSocialButton(title: "Apple",  icon: "apple.logo")
                        SousSocialButton(title: "Google", icon: "globe")
                    }
                    .padding(.top, 14)
                    .padding(.horizontal, 28)
 
                    // Switch to sign up
                    HStack(spacing: 4) {
                        Text("Don't have an account?")
                            .font(.system(size: 12))
                            .foregroundColor(SousTheme.sand)
                        Button("Sign up") {
                            onSwitchToSignUp()
                        }
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(SousTheme.terracotta)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(SousTheme.cream)
                .clipShape(RoundedCornerShape(radius: 28, corners: [.topLeft, .topRight]))
                .offset(y: cardOffset)
            }
        }
        .ignoresSafeArea()
        .onAppear { runEntrance() }
    }
 
    private func runEntrance() {
        withAnimation(.easeOut(duration: 0.3).delay(0.05)) {
            topOpacity = 1
        }
        withAnimation(.spring(response: 0.55, dampingFraction: 0.78).delay(0.1)) {
            cardOffset = 0
        }
    }
}

// MARK: - Reusable Input Field Component
struct SousInputField: View {
    let placeholder: String
    @Binding var text: String
    let isSecure: Bool
    var showEye:     Bool         = false
    var keyboardType: UIKeyboardType = .default
 
    @State private var isRevealed = false
    @FocusState private var isFocused: Bool
 
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(placeholder)
                .font(.system(size: 12))
                .foregroundColor(isFocused ? SousTheme.terracotta : SousTheme.sand)
                .animation(.easeOut(duration: 0.2), value: isFocused)
 
            HStack {
                if isSecure && !isRevealed {
                    SecureField("", text: $text)
                        .focused($isFocused)
                        .font(.system(size: 15))
                        .foregroundColor(SousTheme.espresso)
                } else {
                    TextField("", text: $text)
                        .focused($isFocused)
                        .font(.system(size: 15))
                        .foregroundColor(SousTheme.espresso)
                        .autocapitalization(.none)
                        .keyboardType(keyboardType)
                }
 
                if showEye && isSecure {
                    Button {
                        isRevealed.toggle()
                    } label: {
                        Image(systemName: isRevealed ? "eye.slash" : "eye")
                            .font(.system(size: 14))
                            .foregroundColor(SousTheme.sand)
                    }
                }
            }
 
            // Animated underline
            Rectangle()
                .fill(isFocused ? SousTheme.terracotta : SousTheme.sand.opacity(0.4))
                .frame(height: isFocused ? 1.5 : 1)
                .animation(.easeOut(duration: 0.2), value: isFocused)
        }
    }
}

// MARK: - Reusable Social Button Component
struct SousSocialButton: View {
    let title: String
    let icon:  String
 
    var body: some View {
        Button {
            // TODO: handle social auth
        } label: {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                Text(title)
                    .font(.system(size: 13, weight: .medium))
            }
            .foregroundColor(SousTheme.espresso)
            .frame(maxWidth: .infinity)
            .frame(height: 46)
            .background(SousTheme.blush)
            .cornerRadius(8)
        }
    }
}
 
// MARK: - Rounded Top Corners Shape
struct RoundedCornerShape: Shape {
    var radius: CGFloat
    var corners: UIRectCorner
 
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
 
// MARK: - Previews
#Preview("Sign Up")   { SignUpView(onSwitchToLogin: {}) }
#Preview("Log In")    { LoginView(onSwitchToSignUp: {}) }
#Preview("Auth Flow") { AuthView() }
