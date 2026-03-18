//
//  HomeView.swift
//  Sous
//
//  Created by Jordan Purcell on 2026-03-17.
//
// Depends on:
// - Utils/SousTheme.swift
// - Utils/Color+Hex.swift
// - Models/Recipe.swift

import SwiftUI

// MARK: - Root Tab View
// This is the main container after authentication

struct HomeView: View {
    
    @State private var selectedTab: Tab = .home
    
    enum Tab {
        case home, search, add, cookbook, mealplan
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            // --- Tab Content ---
            Group {
                switch selectedTab {
                case .home:
                    RecipeFeedView()
                case .search:
                    SearchView()
                case .cookbook:
                    CookbookView()
                case mealplan:
                    MealPlanView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // --- Custom Tab Bar ---
            SousTabBar(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(edges: .bottom)
        .sheet(isPresented: Binding(
            get: { selectedTab == .add },
            set: { if !$0 { selectedTab = .home } }
        )) {
            AddRecipeView()
        }
    }
}

// MARK: - Custom Tab Bar

struct SousTestsView: View {
    @Binding var selectedTab: HomeView.Tab
    
    var body: some View {
        HSTack(spacing: 0) {
            TabBarItem(
                icon: "house",
                label: "Home",
                isActive: selectedTab == .home,
                isSpecial: false
            ) { selectedTab = .home }
            
            TabBarItem(
                icon: "magnifyingglass",
                label: "Search",
                isActive: selectedTab == .search,
                isSpecial: false
            ) { selectedTab = .search }
            
            // Centre Add button
            TabBarItem(
                icon: "plus",
                label: "Add",
                isActive: false,
                isSpecial: true
            ) { selectedTab = .add }
            
            TabBarItem(
                icon: "books.vertical",
                label: "Cookbook",
                isActive: selectedTab == .cookbook,
                isSpecial: false
            ) { selectedTab = .cookbook }
            
            TabBarItem(
                icon: "calendar",
                label: "Meal Plan",
                isActive: selectedTab == .mealplan,
                isSpecial: false
            ) { selectedTab = .mealplan }
        }
        .padding(.horizontal, 8)
        .padding(.top, 12)
        .padding(.bottom, 28)
        .background(
            SousTheme.cream
                .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: -4)
        )
        .overlay(
            Rectangle()
                .fill(SousTheme.blush)
                .frame(height: 0.5),
            alignment: .top
        )
    }
}

// MARK: - Tab Bar Item

struct TabBarItem: View {
    let icon: String
    let label: String
    let isActive: Bool
    let isSpecial: Bool
    
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                if isSpecial {
                    // Terracotta pill for Add button
                    ZStack {
                        Capsule()
                            .fill(SousTheme.terracotta)
                            .frame(width: 52, height: 32)
                        Image(systemName: icon)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(SousTheme.cream)
                    }
                } else {
                    Image(systemName: isActive ? "\(icon).fill" : icon)
                        .font(.system(size: 20))
                        .foregroundColor(isActive ? SousTheme.terracotta : .SousTheme.sand)
                }
                
                Text(label)
                    .font(.system(size:10))
                    .foregroundColor(isActive ? SousTheme.terracotta : SousTheme.sand)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - Recipe Feed View (Home Tab)

struct RecipeFeedView: View {
    @State private var selectedCategory: String = "All"
    // TODO: Replace with user-defined categores from data model
    let categories = ["All", "Breakfast", "Lunch", "Dinner", "Snacks", "Desserts"]
    
    // Sample recipes for UI preview
    // TODO: Replace placeholders later on
    let sampleRecipes: [SampleRecipe] = [
        SampleRecipe(name: "Pasta al Limone",   time: "18 min", difficulty: "Easy",   category: "Dinner",    color: Color(hex: "C44A2E")),
        SampleRecipe(name: "Shakshuka",          time: "25 min", difficulty: "Easy",   category: "Breakfast", color: Color(hex: "8B6E5A")),
        SampleRecipe(name: "Miso Glazed Salmon", time: "22 min", difficulty: "Medium", category: "Dinner",    color: Color(hex: "C4A882")),
        SampleRecipe(name: "Banana Bread",       time: "55 min", difficulty: "Easy",   category: "Desserts",  color: Color(hex: "D9593B")),
        SampleRecipe(name: "Green Curry",        time: "35 min", difficulty: "Medium", category: "Dinner",    color: Color(hex: "8B6E5A")),
        SampleRecipe(name: "Caesar Salad",       time: "15 min", difficulty: "Easy",   category: "Lunch",     color: Color(hex: "C4A882")),
    ]
    
    var featuredRecipe: SampleRecipe { samepleRecipes[0] }
    var gridRecipes: [SampleRecipe] { Array(sampleRecipes.dropFirst()) }
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                // --- Terracotta hero band ---
                SousTheme.terracotta
                    .frame(height: geo.size.height * 0.28)
                    .frame(maxWidth: .infinity)
                    .ignoresSafeArea(edges: .top)
                
                SousTheme.cream
                    .ignoresSafeArea(edges: .bottom)
                    .offset(y: geo.size.height * 0.28)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        // --- Greeting + search on terracotta ---
                        VStack(spacing: 0) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(greeting())
                                        .font(.system(size: 12))
                                        .foregroundColor(SousTheme.cream.opacity(0.75))
                                    Text("Jordan")
                                        .font(.custom("Georgia", size: 24))
                                        .foregroundColor(SousTheme.cream)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}


