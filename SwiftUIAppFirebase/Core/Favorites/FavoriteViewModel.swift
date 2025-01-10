//
//  FavoriteViewModel.swift
//  SwiftUIAppFirebase
//
//  Created by Hakob Ghlijyan on 1/10/25.
//

import SwiftUI
import Combine

@MainActor
final class FavoriteViewModel: ObservableObject {
    @Published private(set) var userFavoriteProducts: [UserFavoriteProduct] = []
    private var cancelables: Set<AnyCancellable> = []
    
    func addListenerForFavoriteProducts() {
        guard let authDataResult = try? AuthenticationManager.shared.getAuthenticatedUser() else { return }
        
        //1LISTENER ONLY
//        UserManager.shared.addListenerForAllUserFavoriteProducts(userID: authDataResult.uid) { [weak self] products in
//            self?.userFavoriteProducts = products
//        }
        
        //2 LISTENER ENABLE COMBINE PUBLISHER
        UserManager.shared.addListenerForAllUserFavoriteProductsCombine(userID: authDataResult.uid)
            .sink { completion in
                //
            } receiveValue: { [weak self] products in
                self?.userFavoriteProducts = products
            }
            .store(in: &cancelables)
    }
    
    func removeFromeFavorite(favoriteProductID: String) {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            try? await UserManager.shared.removeUserFavoriteProduct(userID: authDataResult.uid, favoriteProductID: favoriteProductID)
        }
    }
}
