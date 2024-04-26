//
//  CarsController.swift
//  MileageMaster
//
//  Created by Jesse Watson on 15/04/2024.
//

import Foundation

class AccountController {
    
    let email: String
    
    init(email: String) {
        self.email = email
    }
    
    private let GET_ACCOUNT =
                        """
                        query GetAccount($email: String) {
                          account(where: {email: $email}) {
                            id
                            email
                            name
                          }
                        }
                        """
    
    private let CREATE_ACCOUNT =
                        """
                        mutation CreateAccount($email: String!, $name: String!) {
                          createAccount(data: {email: $email, name: $name}) {
                            id
                            email
                            name
                          }
                        
                          publishManyAccountsConnection(
                            to: PUBLISHED
                            last: 100
                            where: {email: $email}
                          ) {
                            edges {
                              node {
                                id
                              }
                            }
                          }
                        }
                        """
    
    private let UPDATE_ACCOUNT_NAME =
                        """
                        mutation UpdateAccountName($email: String, $name: String) {
                          updateAccount(where: {email: $email}, data: {name: $name}) {
                            id
                            email
                            name
                          }
                        
                          publishManyAccountsConnection(
                            to: PUBLISHED
                            last: 100
                            where: {email: $email}
                          ) {
                            edges {
                              node {
                                id
                              }
                            }
                          }
                        }
                        """
    
    private func getAccount() async -> Account? {
        let graphQLRequest = GraphQLRequest<GraphQLResponse<AccountResponse>>(query: GET_ACCOUNT, variables: [(key: "email", value: .string(email))])
        do {
            let response = try await graphQLRequest.run()
            return response.data.account
        } catch {
            print("Failure getting account: \(error.localizedDescription)\n\(error)")
            return nil
        }
    }
    
    func createAccount(name: String) async -> Account? {
        let graphQLRequest = GraphQLRequest<GraphQLResponse<CreateAccount>>(query: CREATE_ACCOUNT, variables: [
            (key: "email", value: .string(email)),
            (key: "name", value: .string(name))
        ])
        do {
            let response = try await graphQLRequest.run()
            return response.data.createAccount
        } catch {
            print("Failure creating account: \(error.localizedDescription)\n\(error)")
            return nil
        }
    }
    
    func loadAccount() async -> Bool {
        let account: Account? = await getAccount()
        if account != nil {
            DispatchQueue.main.async {
                MileageMasterData.shared.account = account
            }
            
            let userDefaultsController = UserDefaultsController()
            userDefaultsController.cacheAccount(account: account!)
            
            return true
        }
        return false
    }
    
}
