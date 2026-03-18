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
                            SousInputField(placeholder: "Email", text: $email, isSecure: false, keyboardtype: .emailAddress)
                            SousInputField(placeholder: "Password, text: $password", isSecure: true)
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

// MARK: - Log In View
struct LoginView: View {
    var onSwitchToSignUp: () -> Void
}
