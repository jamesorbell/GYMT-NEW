//
//  ChallengeRow.swift
//  GYMT
//
//  Created by James Orbell on 14/03/2020.
//  Copyright © 2020 James Orbell. All rights reserved.
//

import SwiftUI

struct ChallengeRow: View {
    
    @State var GroupChallengeID: String
    @State var ChallengeID: String
    @State var ChallengeName: String
    @State var GroupName: String
    @State var DisplayPicture: String
    
    var body: some View {
        
        // Unique Challenge Image
        
        // Navigation link should send details about the challenge itself, and the instance of challenge group.
        NavigationLink(destination: ChallengeDetailView(ChallengeID: ChallengeID, GroupChallengeID: GroupChallengeID)) {
            Image("\(DisplayPicture)")
            .resizable()  // resizable image
            .aspectRatio(contentMode: .fill)
            .frame(width: 175, height: 250) // image frame
            .opacity(0.5)
            // create outer view with border (color, width)
            .border(Color.gray.opacity(0.5), width: 0.5)
            .cornerRadius(20)
            .overlay(ChallengeTitlesOverlay(name: ChallengeName, groupname: GroupName), alignment: .topLeading)
        }
    }
}

struct ChallengeTitlesOverlay: View{
    
    @State var name: String
    @State var groupname: String
    
    var body: some View{
        VStack(alignment: .leading) {
            Text(name)
                .font(.title)
                .fontWeight(.bold)
            
            Spacer()
            
            VStack(alignment: .leading){
                Text("Group")
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.bottom, 5)
                Text(groupname)
                .font(.subheadline)
            }
        }
        .padding()
        .foregroundColor(Color.white)
    }
}

