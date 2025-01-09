//
//  FavoritesView.swift
//  SwiftUIAppFirebase
//
//  Created by Hakob Ghlijyan on 1/9/25.
//

import SwiftUI

@MainActor
final class FavoriteViewModel: ObservableObject {
    @Published private(set) var userFavoriteProducts: [UserFavoriteProduct] = []
    
    func getAllFavorites() {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            self.userFavoriteProducts = try await UserManager.shared.getAllUserFavoriteProducts(userID: authDataResult.uid)
        }
    }
    
    func removeFromeFavorite(favoriteProductID: String) {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            try? await UserManager.shared.removeUserFavoriteProduct(userID: authDataResult.uid, favoriteProductID: favoriteProductID)
            getAllFavorites()
        }
    }
}

struct FavoriteView: View {
    @StateObject private var viewModel: FavoriteViewModel = FavoriteViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.userFavoriteProducts, id: \.id.self) { item in
                ProductCellViewBuilder(productID: String(item.productID))
                    .contextMenu {
                        Button("Remove From Favorites") {
                            viewModel.removeFromeFavorite(favoriteProductID: item.id)
                        }
                    }
            }
        }
        .onAppear {
            viewModel.getAllFavorites()
        }
        .navigationTitle("Products")
    }
}

#Preview {
    NavigationStack {
        FavoriteView()
    }
}
