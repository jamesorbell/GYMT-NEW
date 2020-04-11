//
//  ContentView.swift
//  GYMT
//
//  Created by James Orbell on 25/02/2020.
//  Copyright © 2020 James Orbell. All rights reserved.
//

import SwiftUI

struct GroupUser: Identifiable {
    var id = UUID()
    var username: String
    var displayname: String
    // var avatar: String
    var coins: Int
}

struct ContentView: View {
    
    @ObservedObject var viewRouter: ViewRouter
    
    var body: some View {
        
        // Tab View, displaying 4 different other seperate SwiftUI views - named after their respective pages.
        TabView{
            // Link to HomeView.swift file
            HomeView()
                // Initiates a new tab bar item.
                .tabItem {
                    // Uses a vertical stacking system for the tab item's layout.
                    VStack {
                        // Import relevant logo from the SFLogos library, built into XCode
                        Image(systemName: "house.fill")
                        // Simple tab label
                        Text("Home")
                    }
                }
            .tag(0)
            
            // Link to ActivityScreenView.swift file
            ActivityScreenView()
                .tabItem {
                    VStack {
                        Image(systemName: "flame.fill")
                        Text("Activity")
                    }
                }
            .tag(1)
            
            // Link to GroupsView.swift file
            GroupsView()
                .tabItem {
                    VStack {
                        Image(systemName: "person.3.fill")
                        Text("Groups")
                    }
                }
            .tag(2)
            
            // Link to SettingsView.swift file
            SettingsView()
                .tabItem {
                    VStack {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                }
            .tag(3)
            
        }
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewRouter: ViewRouter())
    }
}
