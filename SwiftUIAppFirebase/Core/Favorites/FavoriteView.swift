//
//  FavoritesView.swift
//  SwiftUIAppFirebase
//
//  Created by Hakob Ghlijyan on 1/9/25.
//

import SwiftUI

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

