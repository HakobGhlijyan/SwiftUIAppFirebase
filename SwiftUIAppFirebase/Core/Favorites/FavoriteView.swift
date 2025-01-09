//
//  FavoritesView.swift
//  SwiftUIAppFirebase
//
//  Created by Hakob Ghlijyan on 1/9/25.
//

import SwiftUI

@MainActor
final class FavoriteViewModel: ObservableObject {
    //@Published private(set) var products: [(userFavoritedProduct: UserFavoriteProduct, product: Product)] = []  //1
    @Published private(set) var userFavoriteProducts: [UserFavoriteProduct] = []                                  //2
    
    func getAllFavorites() {
        Task {
            //1
            /*
             let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
             let userFavoritedProducts = try await UserManager.shared.getAllUserFavoriteProducts(userID: authDataResult.uid)
             var localArray: [(userFavoritedProduct: UserFavoriteProduct, product: Product)] = []
             for userFavoritedProduct in userFavoritedProducts {
                 if let product = try? await ProductsManager.shared.getProduct(productID: String(userFavoritedProduct.productID)) {
                     localArray.append((userFavoritedProduct, product))
                 }
             }
             self.products = localArray
             /*
              1. poluchaem id user
              2. poluchaem vse favorites iz ego collection
              3. v for in cicle proxodim po vsem prosuctam
              imeya produc ispolzuem func get product v product manager ... kotoriy poluchaet product
              //MARK: - GET ONE PRODUCT
              func getProduct(productID: String) async throws -> Product {
                  try await productDocument(productID: productID)
                      .getDocument(as: Product.self)
              }
              4. i u nego est productID , kotoriy tolko u nego , ne putat s id , kotoruy sozdayotsya autoid pri sodanii
              5. Cannot convert value of type 'Int' to expected argument type 'String'
              product on int
              a v vishe func nijen productID: String
             5.let userFavoritedProducts: [UserFavoriteProduct]
              tak mi poluchaem tolko ProductID , no ...
              chtob dobavit i potom udalit , nujen i sozdaniy autoid
              potomu i     @Published private(set) var products: [Product] = []
              menyaem na -> Kortej . TUPLE (
              @Published private(set) var products: [(userFavoritedProduct: UserFavoriteProduct, product: Product)] = []
              6.teper sozdadim localiny array v task..
              var localArray: [(userFavoritedProduct: UserFavoriteProduct, product: Product)] = []
              v nego i dobavim product iz for in
              eli product budet to
              7.v local array apennd v vidfe TUPLE .. (userFavoritedProduct, product), i getprduct u nas s throw .. try? delaem
              8. v konce vnutreniy naznachim na vneshniy array
              
              9. av cicle foreach mi diljni projtis po array , sdelav id , kotoryi bil u
              KeyPath<(userFavoritedProduct: UserFavoriteProduct, product: Product), ID>
              v array productov favoritax  , ne id tavara a tot autoid , potimu chto tak mi v
              array dobavlyaem po id , productID mojet bit odnogo i tago je neskolko
              
              */
             
             //TAK MI POLUCHAEM VSE FAVORITES < -> NO IX TOJE KA PRODUC MOJET BIT 1000 ...
             //eto ne xorocho srazu vse zagrujat... v cicl efor in mi srazu poluchali vse product , eto mojet doldo bit...
             //SOZDADIM PRODUCT CELL VEIW BUILDER
             */
            //2
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
            //1
            /*
             ForEach(viewModel.products, id: \.userFavoritedProduct.id.self) { item in
                 ProductCellView(product: item.product)
                     .contextMenu {
                         Button("Remove From Favorites") {
                             viewModel.removeFromeFavorite(favoriteProductID: item.userFavoritedProduct.id)
                         }
                     }
             }
             */
            // TEPER ISPOLZUEM VMESTO CELL VIEW , BULDERVIEW.. GDE ESI PRODUCT BIL ZAGRUJEN TO ON POKAJETSYA NA EKRANE.
            //2
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
