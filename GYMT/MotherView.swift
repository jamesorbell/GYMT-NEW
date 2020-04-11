//
//  MotherView.swift
//  GYMT
//
//  Created by James Orbell on 31/03/2020.
//  Copyright © 2020 James Orbell. All rights reserved.
//

import SwiftUI

struct MotherView: View {
    
    @ObservedObject var viewRouter: ViewRouter
    @EnvironmentObject var session: SessionStore
    
    func getUser() {
        session.listen()
    }

    var body: some View {
        
        VStack {
            if viewRouter.currentPage == "page1" {
                WelcomeView(viewRouter: viewRouter).environmentObject(SessionStore())
            } else if viewRouter.currentPage == "page2" {
                LoginView(viewRouter: viewRouter).environmentObject(SessionStore())
            } else if viewRouter.currentPage == "page3" {
                SignupView(viewRouter: viewRouter).environmentObject(SessionStore())
            }
        }
    }
}

struct MotherView_Previews : PreviewProvider {
    static var previews: some View {
        MotherView(viewRouter: ViewRouter())
    }
}
