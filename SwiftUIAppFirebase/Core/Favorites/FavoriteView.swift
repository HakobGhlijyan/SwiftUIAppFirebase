//
//  FavoritesView.swift
//  SwiftUIAppFirebase
//
//  Created by Hakob Ghlijyan on 1/9/25.
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

struct FavoriteView: View {
    @StateObject private var viewModel: FavoriteViewModel = FavoriteViewModel()
    @State private var didAppear: Bool = false
    
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
        .navigationTitle("Products")
//        .onAppear {
//            //3dlay etogo dobavim state svojstvo...
//            if !didAppear {
//                viewModel.addListenerForFavoriteProducts()
//                print("addListenerForFavoriteProducts")
//                didAppear = true
//            }
//            // 2 . No mi dobavim teper listener... no on budet kajdiy raz vizivatsya ... nam nujno tolko odin raz..
////            viewModel.addListenerForFavoriteProducts()
////            print("addListenerForFavoriteProducts")
//            // 1 . et o pri vizove etogo view .... viewModel.getAllFavorites()
//        }
        .onFirstAppear {
            viewModel.addListenerForFavoriteProducts()
        }
        
    }
}

#Preview {
    NavigationStack {
        FavoriteView()
    }
}

struct OnFirstAppearViewModifier: ViewModifier {
    
    @State private var didAppear: Bool = false
    let perform: (() -> Void)?

    func body(content: Content) -> some View {
        content
            .onAppear {
                if !didAppear {
                    perform?()
                    didAppear = true
                }
            }
    }
}

extension View {
    
    func onFirstAppear(perform: (() -> Void)?) -> some View {
        modifier(OnFirstAppearViewModifier(perform: perform))
    }
    
}
