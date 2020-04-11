//
//  GroupsView.swift
//  GYMT
//
//  Created by James Orbell on 26/02/2020.
//  Copyright © 2020 James Orbell. All rights reserved.
//

import SwiftUI

struct GroupsView: View {
    
    @State var selection: Int? = nil
    
    var body: some View {
        NavigationView {
            VStack{
                GroupRow()
                GroupRow()
                GroupRow()
                
                NavigationLink(destination: CreateNewGroupDetailView(), tag: 1, selection: $selection) {
                    Button(action: {
                        self.selection = 1
                    }) {
                        HStack {
                            Spacer()
                            Text("Create new group").foregroundColor(Color.white).bold()
                            Spacer()
                        }
                    }
                    .padding()
                    .background(Color(UIColor.systemBlue))
                    .cornerRadius(20)
                    .padding()
                }
                
                Spacer()
            }
            .navigationBarTitle("Your Groups", displayMode: .inline)
        }
    }
}

struct GroupsView_Previews: PreviewProvider {
    static var previews: some View {
        GroupsView()
    }
}
