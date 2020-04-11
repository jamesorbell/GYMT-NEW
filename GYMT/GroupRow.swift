//
//  GroupRow.swift
//  GYMT
//
//  Created by James Orbell on 14/03/2020.
//  Copyright © 2020 James Orbell. All rights reserved.
//

import SwiftUI

struct GroupRow: View {
    var body: some View {
        NavigationLink(destination: GroupDetailView()) {
            HStack{
                VStack(alignment: .leading){
                    Text("Group Name")
                        .fontWeight(.bold)
                    // List of avatars
                    HStack{
                        // Main avatar
                        Image("example-avatar")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .overlay(
                        Circle().stroke(Color.white, lineWidth: 2))
                        
                        // 2nd Avatar
                        Image("example-avatar")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .overlay(
                        Circle().stroke(Color.white, lineWidth: 2))
                        
                        // 3rd Avatar
                        Image("example-avatar")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .overlay(
                        Circle().stroke(Color.white, lineWidth: 2))
                        
                        // 4th Avatar
                        Image("example-avatar")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .overlay(
                        Circle().stroke(Color.white, lineWidth: 2))
                    }
                }
                .padding()
                
                Spacer()
                
                VStack{
                    Image("example-avatar")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .overlay(
                        Circle().stroke(Color.white, lineWidth: 2))
                    
                    Text("Leader Name")
                        .font(.caption)
                }
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
        GroupRow()
    }
}
