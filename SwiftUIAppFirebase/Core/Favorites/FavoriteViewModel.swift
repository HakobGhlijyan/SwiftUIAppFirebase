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
        
//            /*
//             DOBAvim self.. chtom kompilator i eto class bil jiv poka eta func
//             vipolnyaetsya async , chtob vernuv product  on mog naznachit ego
//             MI DOBAVLYAEM SILNUYU SILKU NA CLASS
//
//             no on mojet i ne vernut data ... i tak veset v pamyati ...
//             sdelaem weak self , on budet jdat , no esli budut nil , to sam udalitsya ...
//
//             getAuthenticatedUser u nas s error .? ne budet error obrobativat
//             i sdeleaem zachtu
//             guar chtob esli iuser ne auth , ne vipolnyalsya sleduy chiy kod
//             */
        
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
    
//    func getAllFavorites() {
//        Task {
//            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
//            self.userFavoriteProducts = try await UserManager.shared.getAllUserFavoriteProducts(userID: authDataResult.uid)
//        }
//    }
    
    func removeFromeFavorite(favoriteProductID: String) {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            try? await UserManager.shared.removeUserFavoriteProduct(userID: authDataResult.uid, favoriteProductID: favoriteProductID)
//            getAllFavorites()
        }
    }
}
