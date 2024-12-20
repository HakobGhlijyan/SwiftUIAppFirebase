//
//  AuthenticationView.swift
//  SwiftUIAppFirebase
//
//  Created by Hakob Ghlijyan on 12/20/24.
//

import SwiftUI

struct AuthenticationView: View {
    var body: some View {
        VStack {
            NavigationLink {
                SignInEmailView()
            } label: {
                Text("Sign In With Email")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(.blue)
                    .cornerRadius(10)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Sign In")
    }
}

#Preview {
    NavigationStack {
        AuthenticationView()
    }
}
