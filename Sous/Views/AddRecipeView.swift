//
//  AddRecipeView.swift
//  Sous
//
//  Created by Jordan Purcell on 2026-03-17.
//
// Depends on:
// - Utils/SousTheme.swift
// - Utils/Color+Hex.swift
//

import SwiftUI
import PhotosUI

// MARK: - Import Method
enum ImportMethod: CaseIterable {
    case url, caption, manual, photo
    
    var title: String {
        switch self {
        case .url: return "Paste URL"
        case .caption: return "Paste Caption"
        case .manual: return "Type Manual"
        case .photo: return "Take Photo"
        }
    }
    
    var icon: String {
        switch self {
        case .url: return "link"
        case .caption: return "text.alignleft"
        case .manual: return "pencil"
        case .photo: return "camera"
        }
    }
    
    var description: String {
        switch self {
        case .url: return "From Instagram, Youtube, Pinterest or any food blog"
        case .caption: return "Paste the recipe text from a caption or message"
        case .manual: return "Write your own recipe from scratch"
        case .photo: return "Photograph a recipe card or cookbook page"
        }
    }
}

// MARK: - Add Recipe View

struct AddRecipeView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedMethod: ImportMethod? = nil
    @State private var headerOpacity: Double = 0
    @State private var cardsOffset: CGFloat = 40
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                
                // --- Terracotta background ---
                SousTheme.terracotta.ignoresSafeArea()
                
                // --- Top header ---
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(SousTheme.cream)
                        }
                        Spacer()
                    }
                    .padding(.top, geo.safeAreaInsets.top + 16)
                    
                    Text("Add a Recipe")
                        .font(.custom("Georgia", size: 28))
                        .foregroundColor(SousTheme.cream)
                    
                    Text("How would you like to import it?")
                        .font(.system(size: 14))
                        .foregroundColor(SousTheme.cream.opacity(0.75))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 28)
                .opacity(headerOpacity)
                .frame(maxHeight: .infinity, alignment: .top)
                
                // --- Cream content card ---
                VStack(spacing: 0) {
                    if let method = selectedMethod {
                        // Show the selected import method
                        ImportMethodView(
                            method: method,
                            onBack: {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                                    selectedMethod = nil
                                }
                            },
                            onSave: {
                                // TODO: Save recipe and dismiss
                                dismiss()
                            }
                        )
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)
                        ))
                    } else {
                        // Show method picker
                        MethodPickerView(
                            geo: geo,
                            onSelect: { method in
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                                    selectedMethod = method
                                }
                            }
                        )
                        .transition(.asymmetric(
                            insertion: .move(edge: .leading).combined(with: .opacity),
                            removal: .move(edge: .trailing).combined(with: .opacity)
                        ))
                    }
                }
                .frame(maxWidth: .infinity)
                .background(SousTheme.cream)
                .clipShape(RoundedCornerShape(radius: 28, corners: [.topLeft, .topRight]))
                .offset(y: cardsOffset)
            }
        }
        .ignoresSafeArea()
        .onAppear { runEntrance() }
    }
    
    private func runEntrance() {
        withAnimation(.easeOut(duration: 0.3).delay(0.05)) {
            headerOpacity = 1
        }
        withAnimation(.spring(response: 0.55, dampingFraction: 0.78).delay(0.1)) {
            cardsOffset = 0
        }
    }
}

// MARK: - Method Picker View

struct MethodPickerView: View {
    let geo:      GeometryProxy
    let onSelect: (ImportMethod) -> Void
 
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Handle
            RoundedRectangle(cornerRadius: 2)
                .fill(SousTheme.sand.opacity(0.4))
                .frame(width: 36, height: 4)
                .frame(maxWidth: .infinity)
                .padding(.top, 14)
                .padding(.bottom, 8)
 
            Text("Choose an option")
                .font(.custom("Georgia", size: 22))
                .foregroundColor(SousTheme.espresso)
                .padding(.horizontal, 28)
                .padding(.top, 16)
                .padding(.bottom, 8)
 
            Text("You can always edit the recipe after saving.")
                .font(.system(size: 13))
                .foregroundColor(SousTheme.taupe)
                .padding(.horizontal, 28)
                .padding(.bottom, 28)
 
            // Method cards
            VStack(spacing: 12) {
                ForEach(ImportMethod.allCases, id: \.self) { method in
                    ImportMethodCard(method: method) {
                        onSelect(method)
                    }
                }
            }
            .padding(.horizontal, 20)
 
            Spacer()
                .frame(height: geo.safeAreaInsets.bottom + 40)
        }
    }
}

// MARK: - Import Method Card



// MARK: - Previews
#Preview("Add Recipe")  { AddRecipeView() }
//#Preview("URL Import")  { URLImportView(onSave: {}) }
//#Preview("Manual Entry") { ManualEntryView(onSave: {}) }
