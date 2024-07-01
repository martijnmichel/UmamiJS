//
//  LoginView.swift
//  UmamiJS
//
//  Created by Martijn van der Eijk on 22/06/2024.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var vm: UserStateViewModel
    @State var email = ""
    @State var password = ""
    @State var website = ""
        
    fileprivate func EmailInput() -> some View {
        TextField("Username", text: $email)
            .keyboardType(.emailAddress)
            .disableAutocorrection(true)
            .autocapitalization(.none)
            .input()
    }
    
    fileprivate func WebsiteInput() -> some View {
        TextField("Umami URL", text: $website)
            .disableAutocorrection(true)
            .autocapitalization(.none)
            .input()
    }
        
    fileprivate func PasswordInput() -> some View {
        SecureField("Password", text: $password)
            .input()
    }
        
    fileprivate func LoginButton() -> some View {
        Button(action: {
            Task {
                await vm.signIn(
                    username: email,
                    password: password,
                    website: website
                )
            }
        }) {
            Text(LocalizedStringKey("Login")).padding()
        }
    }
        
    var body: some View {
        VStack {
            if vm.isBusy {
                ProgressView()
            } else {
                Text("Login").font(.title)
                WebsiteInput()
                EmailInput()
                PasswordInput()
                LoginButton()
            }
        }.padding().frame(maxWidth: .infinity, maxHeight: .infinity).background(.base100)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var userStateViewModel = UserStateViewModel()
        @AppStorage("Token") var token = ""
        
        NavigationStack {
            LoginView().task {
                let re = await userStateViewModel.verify()
                print(re)
            }
        }.environmentObject(userStateViewModel)
    }
}
