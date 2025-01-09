//
//  TabBarView.swift
//  SwiftUIAppFirebase
//
//  Created by Hakob Ghlijyan on 1/9/25.
//

import SwiftUI

struct TabBarView: View {
    @Binding var showSignInView: Bool

    var body: some View {
        TabView {
            NavigationStack {
                ProductsView()
            }
            .tabItem {
                Image(systemName: "cart")
                Text("Products")
            }
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(.ultraThickMaterial, for: .tabBar)
            
            NavigationStack {
                FavoriteView()
            }
            .tabItem {
                Image(systemName: "star.fill")
                Text("Favorite")
            }
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(.ultraThickMaterial, for: .tabBar)
            
            NavigationStack {
                ProfileView(showSignInView: $showSignInView)
            }
            .tabItem {
                Image(systemName: "person")
                Text("Profile")
            }
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(.ultraThickMaterial, for: .tabBar)
            
        }
        
    }
}

#Preview {
    TabBarView(showSignInView: .constant(false))
}
