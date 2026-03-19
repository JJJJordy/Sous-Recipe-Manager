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
                case .add:
                    Color.clear // handled by sheet below
                case .cookbook:
                    CookbookView()
                case .mealplan:
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
            //AddRecipeView()
        }
    }
}

// MARK: - Custom Tab Bar

struct SousTabBar: View {
    @Binding var selectedTab: HomeView.Tab
    
    var body: some View {
        HStack(spacing: 0) {
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
                        .foregroundColor(isActive ? SousTheme.terracotta : SousTheme.sand)
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
    // TODO: ** Replace with user-defined categores from data model **
    let categories = ["All", "Breakfast", "Lunch", "Dinner", "Snacks", "Desserts"]
    
    // Sample recipes for UI preview
    // TODO: ** Replace placeholders later on **
    let sampleRecipes: [SampleRecipe] = [
        SampleRecipe(name: "Pasta al Limone",   time: "18 min", difficulty: "Easy",   category: "Dinner",    color: Color(hex: "C44A2E")),
        SampleRecipe(name: "Shakshuka",          time: "25 min", difficulty: "Easy",   category: "Breakfast", color: Color(hex: "8B6E5A")),
        SampleRecipe(name: "Miso Glazed Salmon", time: "22 min", difficulty: "Medium", category: "Dinner",    color: Color(hex: "C4A882")),
        SampleRecipe(name: "Banana Bread",       time: "55 min", difficulty: "Easy",   category: "Desserts",  color: Color(hex: "D9593B")),
        SampleRecipe(name: "Green Curry",        time: "35 min", difficulty: "Medium", category: "Dinner",    color: Color(hex: "8B6E5A")),
        SampleRecipe(name: "Caesar Salad",       time: "15 min", difficulty: "Easy",   category: "Lunch",     color: Color(hex: "C4A882")),
    ]
    
    var featuredRecipe: SampleRecipe { sampleRecipes[0] }
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
                                Spacer()
                                // Avatar
                                ZStack {
                                    Circle()
                                        .fill(Color.white.opacity(0.2))
                                        .frame(width: 40, height: 40)
                                    // TODO: ** Replace this later on **
                                    Text("JP")
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(SousTheme.cream)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, geo.safeAreaInsets.top * 16)
                            
                            // Search bar
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 14))
                                    .foregroundColor(SousTheme.cream.opacity(0.6))
                                Text("Search recipes...")
                                    .font(.system(size: 14))
                                    .foregroundColor(SousTheme.cream.opacity(0.6))
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                            .frame(height: 42)
                            .background(Color.white.opacity(0.15))
                            .clipShape(Capsule())
                            .padding(.horizontal, 20)
                            .padding(.top, 14)
                            .padding(.bottom, 28)
                        }
                        
                        // --- Cream content card ---
                        VStack(alignment: .leading, spacing: 0) {
                            
                            // Stats row
                            HStack(spacing: 10) {
                                StatCard(value: "24", label: "Recipes")
                                StatCard(value: "3", label: "This week")
                                StatCard(value: "8", label: "Favourites")
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 24)
                            
                            // Category filters
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(categories, id: \.self) { cat in
                                        CategoryPill(
                                            title: cat,
                                            isSelected: selectedCategory == cat
                                        )
                                        .onTapGesture { selectedCategory = cat }
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                            .padding(.top, 20)
                            
                            // Feeatured section
                            Text("Featured")
                                .font(.custom("Georgia", size: 16))
                                .foregroundColor(SousTheme.espresso)
                                .padding(.horizontal, 20)
                                .padding(.top, 24)
                                .padding(.bottom, 12)
                            
                            FeaturedCard(recipe: featuredRecipe)
                                .padding(.horizontal, 20)
                            
                            // Recently added section
                            Text("Recently Added")
                                .font(.custom("Georgia", size: 16))
                                .foregroundColor(SousTheme.espresso)
                                .padding(.horizontal, 20)
                                .padding(.top, 28)
                                .padding(.bottom, 12)
                            
                            // 2-column  grid
                            LazyVGrid(
                                columns: [
                                    GridItem(.flexible(), spacing: 12),
                                    GridItem(.flexible(), spacing: 12)
                                ],
                                spacing: 12
                            ) {
                                ForEach(gridRecipes) { recipe in
                                    RecipeGridCard(recipe: recipe)
                                }
                            }
                            .padding(.horizontal, 20)
                            // Tab Bar Clearance
                            .padding(.bottom, 120)
                        }
                        .background(SousTheme.cream)
                        .clipShape(RoundedCornerShape(radius: 24, corners: [.topLeft, .topRight]))
                        .offset(y: -24)
                    }
                }
            }
        }
        .ignoresSafeArea(edges: .top)
    }
    
    private func greeting() -> String{
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good Morning,"
        case 12..<17: return "Good Afternoon,"
        case 17..<21: return "Good Evening,"
        default:      return "Good Night,"
        }
    }
}

// MARK: - Stat Card

struct StatCard: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(SousTheme.espresso)
            Text(label)
                .font(.system(size: 10))
                .foregroundColor(SousTheme.taupe)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(SousTheme.blush)
        .cornerRadius(10)
    }
}

// MARK: - Category Pill

struct CategoryPill: View {
    let title: String
    let isSelected: Bool
    
    var body: some View {
        Text(title)
            .font(.system(size: 13))
            .foregroundColor(isSelected ? SousTheme.cream : SousTheme.taupe)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isSelected ? SousTheme.terracotta : SousTheme.blush)
            .clipShape(Capsule())
    }
}

// MARK: - Featured Card

struct FeaturedCard: View {
    let recipe: SampleRecipe
 
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            recipe.color
                .frame(height: 160)
                .cornerRadius(16)
 
            // Gradient overlay
            LinearGradient(
                colors: [.clear, Color.black.opacity(0.45)],
                startPoint: .top,
                endPoint: .bottom
            )
            .cornerRadius(16)
 
            VStack(alignment: .leading, spacing: 4) {
                Text("\(recipe.category.uppercased())  •  \(recipe.difficulty.uppercased())")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(SousTheme.cream.opacity(0.8))
                Text(recipe.name)
                    .font(.custom("Georgia", size: 18))
                    .foregroundColor(SousTheme.cream)
                Text(recipe.time)
                    .font(.system(size: 12))
                    .foregroundColor(SousTheme.cream.opacity(0.8))
            }
            .padding(16)
 
            // Heart
            Image(systemName: "heart")
                .font(.system(size: 16))
                .foregroundColor(SousTheme.cream)
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}
 
// MARK: - Recipe Grid Card

struct RecipeGridCard: View {
    let recipe: SampleRecipe
 
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Colour block top
            recipe.color
                .frame(height: 80)
                .cornerRadius(12)
 
            // Info below
            VStack(alignment: .leading, spacing: 3) {
                Text(recipe.name)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(SousTheme.espresso)
                    .lineLimit(1)
                Text(recipe.time)
                    .font(.system(size: 11))
                    .foregroundColor(SousTheme.taupe)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 10)
        }
        .background(SousTheme.blush)
        .cornerRadius(12)
    }
}
 
// MARK: - Sample Recipe Model (temporary until Recipe.swift is built)

struct SampleRecipe: Identifiable {
    let id = UUID()
    let name:       String
    let time:       String
    let difficulty: String
    let category:   String
    let color:      Color
}
 
// MARK: - Placeholder Tab Views

struct SearchView: View {
    var body: some View {
        ZStack {
            SousTheme.cream.ignoresSafeArea()
            VStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 32))
                    .foregroundColor(SousTheme.terracotta)
                Text("Search")
                    .font(.custom("Georgia", size: 20))
                    .foregroundColor(SousTheme.espresso)
                Text("Coming soon")
                    .font(.system(size: 14))
                    .foregroundColor(SousTheme.taupe)
            }
        }
    }
}
 
struct CookbookView: View {
    var body: some View {
        ZStack {
            SousTheme.cream.ignoresSafeArea()
            VStack(spacing: 8) {
                Image(systemName: "books.vertical")
                    .font(.system(size: 32))
                    .foregroundColor(SousTheme.terracotta)
                Text("Cookbook")
                    .font(.custom("Georgia", size: 20))
                    .foregroundColor(SousTheme.espresso)
                Text("Coming soon")
                    .font(.system(size: 14))
                    .foregroundColor(SousTheme.taupe)
            }
        }
    }
}
 
struct MealPlanView: View {
    var body: some View {
        ZStack {
            SousTheme.cream.ignoresSafeArea()
            VStack(spacing: 8) {
                Image(systemName: "calendar")
                    .font(.system(size: 32))
                    .foregroundColor(SousTheme.terracotta)
                Text("Meal Plan")
                    .font(.custom("Georgia", size: 20))
                    .foregroundColor(SousTheme.espresso)
                Text("Coming soon")
                    .font(.system(size: 14))
                    .foregroundColor(SousTheme.taupe)
            }
        }
    }
}
 
// MARK: - Previews
#Preview("Home Feed") { RecipeFeedView() }
#Preview("Full App")  { HomeView() }
 


