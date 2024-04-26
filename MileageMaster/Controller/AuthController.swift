//
//  AuthController.swift
//  MileageMaster
//
//  Created by Jesse Watson on 26/04/2024.
//

import Foundation
import FirebaseAuth

@MainActor
final class AuthController {
    
    private enum AuthError: Error {
        case idTokenError
        case accessTokenError
    }
    
    private let signInWithGoogleHelper = SignInWithGoogleHelper(GIDClientID: "43232244899-bn8a4jbvjd0e9d6tgcin5c8jh7tfsgon.apps.googleusercontent.com")
    
    private func signInWithGoogle() async throws -> AuthCredential {
        let googleSignInResult = try? await signInWithGoogleHelper.signIn()
        
        // --- Load Account from HyGraph
        if let email = googleSignInResult?.email {
            let accountController = AccountController(email: email)
            let accountLoaded = await accountController.loadAccount()
            if accountLoaded == false {
                
                // --- New User, Create Account
                if let fullName = googleSignInResult?.fullName {
                    let accountCreated = await accountController.createAccount(name: fullName)
                    if accountCreated != nil {
                        await accountController.loadAccount()
                    }
                }
                
            }
        }
        
        guard let idToken = googleSignInResult?.idToken else {
            throw AuthError.idTokenError
        }
        guard let accessToken = googleSignInResult?.accessToken else {
            throw AuthError.accessTokenError
        }
        return GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
    }
    
    private func signInWithCredential(credential: AuthCredential) async throws -> AuthDataResult {
        let authDataResult = try await Auth.auth().signIn(with: credential)
        return authDataResult
    }
    
    func signIn() async throws {
        let credential = try await signInWithGoogle()
        let authDataResult = try await signInWithCredential(credential: credential)
        print("Credential -> \(credential)")
        print("AuthDataResult -> \(authDataResult)")
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
        UserDefaultsController.shared.removeAccount()
        MileageMasterData.shared.account = nil
        MileageMasterData.shared.cars = nil
        MileageMasterData.shared.entries = nil
        MileageMasterData.shared.services = nil
    }
    
    func checkAuthentication() -> Bool {
        let userDefaultsController = UserDefaultsController()
        
        if Auth.auth().currentUser != nil {
            if let account = userDefaultsController.loadCachedAccount() {
                MileageMasterData.shared.account = account
                return true
            }
        }
        
        return false
    }
    
}
