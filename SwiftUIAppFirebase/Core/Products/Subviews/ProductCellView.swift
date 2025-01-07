//
//  ProductCellView.swift
//  SwiftUIAppFirebase
//
//  Created by Hakob Ghlijyan on 12/30/24.
//

import SwiftUI

struct ProductCellView: View {
    let product: Product
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            AsyncImage(
                url: URL(string: product.thumbnail ?? "")) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 75, height: 75)
                        .clipShape(.rect(cornerRadius: 10, style: .continuous))
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 75, height: 75)
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(product.title ?? "n/a")
                    .font(.headline)
                    .foregroundStyle(Color.primary)
                Text("Price: $" + String(product.price ?? 0))
                Text("\(product.rating ?? 0, specifier: "%.2f")")
                Text("Category: " + (product.category?.rawValue.capitalized ?? "n/a"))
                Text("Brand: " + (product.brand ?? "n/a"))
            }
            .font(.subheadline)
            .foregroundStyle(Color.secondary)
        }
    }
}

#Preview {
    @Previewable @State var product: Product = Product(
        id: 1,
        title: "Essence Mascara Lash Princess",
        description: "The Essence Mascara Lash Princess is a popular mascara known for its volumizing and lengthening effects. Achieve dramatic lashes with this long-lasting and cruelty-free formula.",
        category: .beauty,
        price: 9.99,
        discountPercentage: 7.17,
        rating: 4.94,
        stock: 5,
        tags: ["beauty","mascara"],
        brand: "Essence",
        sku: "RCH45Q1A",
        weight: 1,
        dimensions: Dimensions(width: 11, height: 11, depth: 11),
        warrantyInformation: "",
        shippingInformation: "",
        availabilityStatus: AvailabilityStatus.inStock,
        reviews: nil,
        returnPolicy: nil,
        minimumOrderQuantity: 1,
        meta: nil,
        images: ["https://cdn.dummyjson.com/products/images/beauty/Essence%20Mascara%20Lash%20Princess/1.png"],
        thumbnail: "https://cdn.dummyjson.com/products/images/beauty/Essence%20Mascara%20Lash%20Princess/thumbnail.png"
    )
    
    ProductCellView(product: product)
}
