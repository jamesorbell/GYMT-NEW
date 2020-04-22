//
//  SettingsView.swift
//  GYMT
//
//  Created by James Orbell on 26/02/2020.
//  Copyright © 2020 James Orbell. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var session: SessionStore
    
    var body: some View {
        NavigationView {
            List {
                Button(action: session.signOut) {
                    
                    HStack{
                        Text("Log out")
                            .font(.headline)
                        Spacer()
                        Image(systemName: "hand.point.right.fill")
                        }
                    }
            }
            .navigationBarTitle("Settings", displayMode: .inline)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject(SessionStore())
    }
}

struct SettingListItem: View {
    var body: some View {
        NavigationLink(destination: SettingDetailView()) {
            Text("Setting")
        }
    }
}
