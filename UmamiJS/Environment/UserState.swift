//
//  UserState.swift
//  UmamiJS
//
//  Created by Martijn van der Eijk on 22/06/2024.
//

import Foundation


enum UserStateError: Error{
    case signInError, signOutError
}

struct SignInResponse: Codable {
    var token: String
    var user: User
}

struct SignInBody: Codable {
    var username, password: String;
}

struct User: Codable {
    let id, username, role: String
    
    let isAdmin: Bool
}

@MainActor
class UserStateViewModel: ObservableObject {
    
    @Published var isLoggedIn = false
    @Published var isBusy = false
    
    @Published var user: User?
    
   
    
    func signIn(username: String, password: String, website: String) async -> Result<Bool, UserStateError>  {
        guard let url = URL(string: "\(website)/api/auth/login") else {
            print("Invalid URL")
            return .failure(.signInError)
        }
        
        
        isBusy = true
        do{
            let body =  try JSONEncoder().encode(SignInBody(username: username, password: password))
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = body
            
            print(request.httpBody ?? "")
            
            
            
            let (responseData, _) = try await URLSession.shared.upload(for: request, from: body)
            
                
            if let data = try? JSONDecoder().decode(SignInResponse.self, from: responseData) {
                print(data)
                
                UserDefaults.standard.set(data.token, forKey: "Token")
                UserDefaults.standard.set(website, forKey: "Website")
                
                user = data.user
                isLoggedIn = true
                
            }
            
            
            isBusy = false
            
            
            return .failure(.signInError)
        }catch{
            isBusy = false
            return .failure(.signInError)
        }
    }
    
    func verify() async -> Result<Bool, UserStateError>  {
        
       
        guard let token = UserDefaults.standard.string(forKey: "Token") else {
            print("Token is unset")
            return .failure(.signInError)
        }
        
        guard let website = UserDefaults.standard.string(forKey: "Website") else {
            print("Website is unset")
            return .failure(.signInError)
        }
        
        guard let url = URL(string: "\(website)/api/auth/verify") else {
            print("Invalid URL")
            return .failure(.signInError)
        }
        
        
        isBusy = true
        do{
            
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            
            
            
            let (responseData, _) = try await URLSession.shared.data(for: request)
            
                
            if let data = try? JSONDecoder().decode(User.self, from: responseData) {
                print("Verify success")
               
                
                
                user = data
                    
                
                isLoggedIn = true
                isBusy = false
                
                
                return .success(true)
                
            }
            
            
            isBusy = false
            
            
            return .failure(.signInError)
        }catch{
            isBusy = false
            return .failure(.signInError)
        }
    }
    
    func signOut() async -> Result<Bool, UserStateError>  {
        isBusy = true
        do{
            try await Task.sleep(nanoseconds: 1_000_000_000)
            isLoggedIn = false
            isBusy = false
            return .success(true)
        }catch{
            isBusy = false
            return .failure(.signOutError)
        }
    }
}


