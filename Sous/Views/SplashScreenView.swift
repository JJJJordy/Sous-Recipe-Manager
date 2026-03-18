//
//  SplashScreenView.swift
//  Sous
//
//  Created by Jordan Purcell on 2026-03-17.
//
// Depends on:
//  - Utils/SousTheme.swift  (colour tokens)
//  - Utils/Color+Hex.swift  (hex initialiser)
//


import SwiftUI
 
struct SplashScreenView: View {
 
    // MARK: - Animation States
    @State private var haloScale:     CGFloat = 0.6
    @State private var haloOpacity:   Double  = 0
    @State private var circleScale:   CGFloat = 0.7
    @State private var circleOpacity: Double  = 0
    @State private var textOpacity:   Double  = 0
    @State private var textOffset:    CGFloat = 16
    @State private var accentOpacity: Double  = 0
    @State private var isActive:      Bool    = false
 
    // MARK: - Body
    var body: some View {
        if isActive {
            AuthView()
        } else {
            GeometryReader { geo in
                ZStack {
                    // ─── Background ───────────────────────────────────
                    SousTheme.cream
                        .ignoresSafeArea()
 
                    // ─── Halo ring ────────────────────────────────────
                    Circle()
                        .fill(SousTheme.blush)
                        .frame(width: geo.size.width * 0.90)
                        .position(
                            x: -geo.size.width * 0.05,
                            y:  geo.size.height * 0.48
                        )
                        .scaleEffect(haloScale)
                        .opacity(haloOpacity)
 
                    // ─── Main circle ──────────────────────────────────
                    Circle()
                        .fill(SousTheme.terracotta)
                        .frame(width: geo.size.width * 0.70)
                        .position(
                            x: -geo.size.width * 0.05,
                            y:  geo.size.height * 0.48
                        )
                        .scaleEffect(circleScale)
                        .opacity(circleOpacity)
 
                    // ─── Top-left label ───────────────────────────────
                    VStack(alignment: .leading, spacing: 4) {
                        Rectangle()
                            .fill(SousTheme.espresso)
                            .frame(width: 44, height: 1)
 
                        Text("Recipe")
                            .font(.system(size: 11, weight: .regular))
                            .foregroundColor(SousTheme.taupe)
 
                        Text("Manager")
                            .font(.system(size: 11, weight: .regular))
                            .foregroundColor(SousTheme.taupe)
                    }
                    .opacity(textOpacity)
                    .offset(y: -textOffset)
                    .position(
                        x: 52,
                        y: geo.safeAreaInsets.top + 56
                    )
 
                    // ─── Accent circles ───────────────────────────────
                    VStack(spacing: 10) {
                        Circle()
                            .fill(SousTheme.terracotta)
                            .frame(width: 22, height: 22)
                        Circle()
                            .fill(SousTheme.terracotta)
                            .frame(width: 11, height: 11)
                    }
                    .opacity(accentOpacity)
                    .position(
                        x: geo.size.width - 36,
                        y: geo.size.height * 0.82
                    )
 
                    // ─── App name + mark ──────────────────────────────
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Sous")
                            .font(.custom("Georgia", size: 38))
                            .tracking(4)
                            .foregroundColor(SousTheme.espresso)
 
                        Rectangle()
                            .fill(SousTheme.terracotta)
                            .frame(width: 6, height: 32)
                            .padding(.top, 8)
                    }
                    .opacity(textOpacity)
                    .offset(y: textOffset)
                    .position(
                        x: geo.size.width * 0.22,
                        y: geo.size.height * 0.87
                    )
 
                    // ─── Bottom bar ───────────────────────────────────
                    VStack {
                        Spacer()
                        Rectangle()
                            .fill(SousTheme.terracotta)
                            .frame(height: 52)
                            .ignoresSafeArea(edges: .bottom)
                    }
                }
            }
            .ignoresSafeArea()
            .onAppear { runEntrance() }
        }
    }
 
    // MARK: - Entrance Animation
    private func runEntrance() {
 
        // 1. Halo ring blooms in
        withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.1)) {
            haloScale   = 1.0
            haloOpacity = 1.0
        }
 
        // 2. Main circle grows in
        withAnimation(.spring(response: 0.7, dampingFraction: 0.65).delay(0.3)) {
            circleScale   = 1.0
            circleOpacity = 1.0
        }
 
        // 3. Text fades and slides up
        withAnimation(.easeOut(duration: 0.6).delay(0.7)) {
            textOpacity = 1.0
            textOffset  = 0
        }
 
        // 4. Accent circles pop in
        withAnimation(.easeOut(duration: 0.4).delay(1.0)) {
            accentOpacity = 1.0
        }
 
        // 5. Navigate to auth after 2.8s
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.8) {
            withAnimation(.easeInOut(duration: 0.5)) {
                isActive = true
            }
        }
    }
}
 
// MARK: - Preview
#Preview {
    SplashScreenView()
}
