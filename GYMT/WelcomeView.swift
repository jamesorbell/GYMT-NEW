//
//  WelcomeView.swift
//  GYMT
//
//  Created by James Orbell on 31/03/2020.
//  Copyright © 2020 James Orbell. All rights reserved.
//

import SwiftUI

struct WelcomeView: View {
    
    @ObservedObject var viewRouter: ViewRouter
    @EnvironmentObject var session: SessionStore
    
    var body: some View {
        
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    Image("running-man")
                        .resizable()
                        .aspectRatio(geometry.size, contentMode: .fill)
                        .edgesIgnoringSafeArea(.all)
                    VStack {
                        
                        Text("Welcome to GYMT")
                        .foregroundColor(Color.white)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        .padding()
                        
                        Text("GYMT is the app to help you reach all your fitness goals whilst competing along with you friends!")
                        .frame(width: 310)
                            .foregroundColor(Color.white)
                            .padding()
                        
                        Text("Let's get going and start crushing it 💪")
                            .frame(width:350)
                        .foregroundColor(Color.white)
                            .padding()
                        
                        Spacer()
                        
                        Button(action: {self.viewRouter.currentPage = "page2"}) {
                        Text("Get started")
                            .padding()
                        }
                        .frame(width: 250)
                        .foregroundColor(Color.white)
                        .background(Color.gray)
                        .opacity(0.8)
                        .cornerRadius(20)
                        .padding()

                        }
                    }
                }
            }
        }
    }

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(viewRouter: ViewRouter())
    }
}
