//
//  ChallengeRow.swift
//  GYMT
//
//  Created by James Orbell on 14/03/2020.
//  Copyright © 2020 James Orbell. All rights reserved.
//

import SwiftUI

struct ChallengeRow: View {
    var body: some View {
        
        // Unique Challenge Image
        
        NavigationLink(destination: ChallengeDetailView()) {
            Image("king-of-hill")
            .resizable()  // resizable image
            .aspectRatio(contentMode: .fill)
            .frame(width: 175, height: 250) // image frame
            // create outer view with border (color, width)
            .border(Color.gray.opacity(0.5), width: 0.5)
            .cornerRadius(20)
            .overlay(ProfilePictureOverlay(), alignment: .topLeading)
            .overlay(ChallengeTitlesOverlay(), alignment: .bottomLeading)
        }
    }
}

struct ChallengeRow_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeRow()
    }
}

struct ProfilePictureOverlay: View{
    var body: some View {
        HStack(alignment: .top) {
            // First place avatar
            ZStack{
                Image("example-avatar")
                .resizable()
                .frame(width: 50, height: 50)
                .overlay(
                Circle().stroke(Color.white, lineWidth: 4))
            }
            .clipShape(Circle())
            .padding()
            .shadow(radius: 10)
            .overlay(
                Image("medal-gold")
                .resizable()
                .frame(width: 20, height: 20)
                    .offset(y: -5)
            , alignment: .bottom)
        }
    }
}

struct ChallengeTitlesOverlay: View{
    var body: some View{
        VStack(alignment: .leading) {
            Text("Challenge Name")
                .font(.headline)
            
            Text("Challenge Group")
                .font(.caption)
        }
        .padding()
        .foregroundColor(Color.white)
    }
}
