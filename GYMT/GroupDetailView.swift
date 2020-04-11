//
//  GroupDetailView.swift
//  GYMT
//
//  Created by James Orbell on 18/03/2020.
//  Copyright © 2020 James Orbell. All rights reserved.
//

import SwiftUI

struct GroupDetailView: View {
    
    let modelData3: [GroupUser] =
    [GroupUser(username: "jorbell", displayname: "James Orbell", coins: 7384),
    GroupUser(username: "anitabieda", displayname: "Anita Bieda", coins: 2837),
    GroupUser(username: "josheastwell", displayname: "Josh Eastwell", coins: 5748),
    GroupUser(username: "maddybrice", displayname: "Maddy Brice", coins: 3948),]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Image("group-pic")
                    .resizable()
                    .frame(height: 150)
                    .aspectRatio(contentMode: .fit)
                    .background(Color.black)
                    .opacity(0.5)
                    .overlay(GroupTitleOverlay(), alignment: .bottomLeading)
                
                HStack{
                    Text("Lifetime Leaderboard")
                    .font(.headline)
                    .padding()
                    .foregroundColor(Color.white)
                    
                    Spacer()
                }
                .background(Color(UIColor.systemGray))
                .padding(.top, -8)
                
                List(modelData3){ GroupUser in
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
                .padding(.top, -12)
                .frame(height: 250)
                
                HStack{
                    Text("Ongoing Challenges")
                    .font(.headline)
                    .padding()
                    .foregroundColor(Color.white)
                    
                    Spacer()
                }
                .background(Color(UIColor.systemGray))
                .padding(.top, -10)
                
                ScrollView(.horizontal){
                    HStack(spacing: 10){
                        
                        ChallengeRow()
                        ChallengeRow()
                        ChallengeRow()
                        
                    }.padding(.leading, 10)
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: Alignment.topLeading)
                
                HStack{
                    Text("Completed Challenges")
                    .font(.headline)
                    .padding()
                    .foregroundColor(Color.white)
                    
                    Spacer()
                }
                .background(Color(UIColor.systemGray))
                
                List(){
                    CompletedChallengeRow()
                    CompletedChallengeRow()
                    CompletedChallengeRow()
                    CompletedChallengeRow()
                    CompletedChallengeRow()
                }
                .padding(.top, -12)
                .frame(height: 400)
                
                Spacer()
            }
        }
        .navigationBarTitle(Text("Group Overview"))
    }
}

struct GroupDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GroupDetailView()
    }
}

struct GroupTitleOverlay: View {
    var body: some View {
        VStack(alignment: .leading){
            Text("Group Name")
                .font(.title)
                .fontWeight(.bold)
        }
        .padding()
        .foregroundColor(Color.white)
    }
}
