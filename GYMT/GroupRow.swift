//
//  GroupRow.swift
//  GYMT
//
//  Created by James Orbell on 18/04/2020.
//  Copyright © 2020 James Orbell. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import FirebaseInstallations
import FirebaseCoreDiagnostics

struct GroupRow: View {
    
    @State var GroupID: String
    @State var GroupName: String
    @State var GroupDescription: String
    
    var body: some View {
        NavigationLink(destination: GroupDetailView(GroupID: GroupID, GroupName: GroupName, GroupDescription: GroupDescription)) {
            HStack{
                VStack(alignment: .leading){
                    Text(GroupName)
                        .font(.system(size: 25))
                        .fontWeight(.bold)
                    Text("")
                    Text(GroupDescription)
                        .font(.caption)
                        .fontWeight(.medium)
                }
                .padding()
                .padding(.trailing, -25)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .padding()
            }
            .background(Color(UIColor.systemPink))
            .foregroundColor(Color.white)
            .cornerRadius(20)
            .padding(.bottom, -20)
            .padding()
        }
    }
}

struct GroupRow_Previews: PreviewProvider {
    static var previews: some View {
        GroupRow(GroupID: "LXiKfr4LuP6MGfEPOleg", GroupName: "The Three Muskateers", GroupDescription: "Just three lads from Loughborough.")
    }
}
