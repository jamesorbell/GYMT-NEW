//
//  ChallengeDetailView.swift
//  GYMT
//
//  Created by James Orbell on 16/03/2020.
//  Copyright © 2020 James Orbell. All rights reserved.
//

import SwiftUI

struct ChallengeDetailView: View {
    
    let modelData2: [GroupUser] =
        [GroupUser(username: "jorbell", displayname: "James Orbell", coins: 783),
        GroupUser(username: "anitabieda", displayname: "Anita Bieda", coins: 823),
        GroupUser(username: "josheastwell", displayname: "Josh Eastwell", coins: 123),
        GroupUser(username: "maddybrice", displayname: "Maddy Brice", coins: 243),]
    
    var body: some View {
        
        ZStack {
            VStack(alignment: .leading) {
                Image("running-bg")
                    .resizable()
                    .frame(height: 150)
                    .aspectRatio(contentMode: .fit)
                    .background(Color.black)
                    .opacity(0.5)
                    .overlay(ChallengeTitleOverlay(), alignment: .bottomLeading)
                    .overlay(ChallengeStatusOverlay(), alignment: .bottomTrailing)
                
                HStack{
                    Text("Description")
                    .font(.headline)
                    .padding()
                    .foregroundColor(Color.white)
                    
                    Spacer()
                }
                .background(Color(UIColor.systemGray))
                .padding(.top, -8)
                
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras at elementum ligula. Aliquam porta eget elit vitae iaculis. Sed quis orci finibus, laoreet tortor eu, aliquam velit. Mauris ut finibus mi. Nunc convallis nibh augue. Integer ut enim nibh. Nam in ligula eget purus placerat venenatis. Aenean pharetra, diam eu molestie pharetra, nunc quam porta est, a vestibulum ex dolor eget felis.")
                    .font(.caption)
                    .padding()
                
                HStack{
                    Text("Leaderboard")
                    .font(.headline)
                    .padding()
                    .foregroundColor(Color.white)
                    
                    Spacer()
                }
                .background(Color(UIColor.systemGray))
                
                List(modelData2){ GroupUser in
                    HStack{
                        
                        Image("example-avatar")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .padding()
                        
                        VStack(alignment: .leading){
                            Text(GroupUser.displayname)
                                .font(.headline)
                            Text("+ \(GroupUser.coins) coins")
                        }.padding()
                        
                    }
                    .padding(.top, -10)
                    .padding(.bottom, -10)
                }
                
                Spacer()
            }
        }
        .navigationBarTitle(Text("Challenge Overview"))
    }
}

struct ChallengeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeDetailView()
    }
}

struct ChallengeTitleOverlay: View {
    var body: some View {
        VStack(alignment: .leading){
            Text("Challenge Name")
                .font(.headline)
            Text("Group Name")
                .font(.caption)
        }
        .padding()
        .foregroundColor(Color.white)
    }
}

struct ChallengeStatusOverlay: View {
    var body: some View {
        VStack(alignment: .trailing){
            Text("Ongoing")
                .font(.headline)
        }
        .padding()
        .foregroundColor(Color.white)
    }
}
