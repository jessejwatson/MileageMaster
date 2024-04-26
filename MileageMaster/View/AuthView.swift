//
//  AuthView.swift
//  MileageMaster
//
//  Created by Jesse Watson on 26/04/2024.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct AuthView: View {
    
    @Binding var showSignInView: Bool
    
    @State private var signingIn = false
    
    var body: some View {
        VStack {
            
            Spacer()
            
            Text("Welcome to MileageMaster!")
                .font(.largeTitle)
                .multilineTextAlignment(.center)
            
            Text("Please sign in with Google to begin.")
                .font(.headline)
            
            Spacer()
            
            Button {
                
                signingIn = true
                Task {
                    do {
                        let authController = AuthController()
                        try await authController.signIn()
                        showSignInView = false
                    } catch {
                        print(error)
                    }
                }
                
            } label: {
                HStack {
                    
                    GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .light, style: .icon, state: .normal)) {
                    }
                    .navigationTitle("Sign In")
                    .padding()
                    
                    Spacer()
                    
                    Text("Sign in with Google")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding()
                    
                }
                .background(.blue)
                .cornerRadius(25)
            }
            .padding()
            
            
        }
        .padding()
    }
}
