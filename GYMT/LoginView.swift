//
//  LoginView.swift
//  GYMT
//
//  Created by James Orbell on 31/03/2020.
//  Copyright © 2020 James Orbell. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    
    @State var email: String = ""
    @State var password: String = ""
    @State var error: String = ""
    
    @ObservedObject var viewRouter: ViewRouter
    @EnvironmentObject var session: SessionStore
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    func getUser() {
        session.listen()
    }
    
    func signIn() {
        session.signIn(email: email, password: password) { (result, error) in
            if let error = error {
                self.error = error.localizedDescription
            } else {
                self.email = ""
                self.password = ""
            }
        }
    }
    
    let facebook_color = UIColor(red: 59, green: 89, blue: 152, alpha: 1)

    var body: some View {
        Group {
            if (session.session != nil) {
                // Input code for what to do if the user has already signed in.
                ContentView(viewRouter: viewRouter).environmentObject(SessionStore())
            } else {
                // Code for the user if they're not signed in.
                NavigationView {
                    VStack{
                        Image(colorScheme == .light ? "GYMT-logo" : "GYMT-logo-white")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200.0,height:200)
                        
                        Text("Sign in to continue")
                        
                        // Put input fields into here.
                        VStack {
                            TextField("Email address", text: $email)
                                .font(.system(size: 14))
                                .padding(12)
                                .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color(UIColor.systemGray),lineWidth: 1))
                            
                            SecureField("Password", text: $password)
                                .font(.system(size: 14))
                                .padding(12)
                                .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color(UIColor.systemGray),lineWidth: 1))
                        }
                        .padding()
                        
                        Button(action: signIn) {
                            Text("Sign in")
                                .frame(minWidth: 0, maxWidth: 300)
                                .frame(height: 50)
                                .foregroundColor(.white)
                                .font(.system(size: 14, weight: .bold))
                                .background(Color(UIColor.systemBlue))
                                .cornerRadius(5)
                        }
                        .padding()
                        
                        if (error != "") {
                            Text(error)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.red)
                                .padding()
                        }

                        Spacer()
                        
                        HStack {
                            Text("I'm a new user.")
                            Button(action: {self.viewRouter.currentPage = "page3"}) {
                                Text("Create an account")
                                    .fontWeight(.bold)
                            }
                        }
                        
                    }
                }
            }
        }.onAppear(perform: getUser)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewRouter: ViewRouter()).environmentObject(SessionStore())
    }
}
