//
//  FriendsListView.swift
//  GYMT
//
//  Created by James Orbell on 12/04/2020.
//  Copyright © 2020 James Orbell. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import FirebaseInstallations
import FirebaseCoreDiagnostics

struct Friend: Identifiable {
    let id: String
    
    let firstName: String
    let secondName: String
}

struct FriendRequestRow: View {
    
    var body: some View {
        HStack{
            Image("example-avatar")
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            
            VStack(alignment: .leading){
                Text("Josh Eastwell")
                    .font(.headline)
            }.padding()
            
            Spacer()
            
            Button(action: {
                // Deny and remove friend request, make sure to pop up with 'are you sure?' alert.
            }) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 30))
                    .foregroundColor(Color(UIColor.systemGreen))
            }
            
            Button(action: {
                // Accept friend request
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 30))
                    .foregroundColor(Color(UIColor.systemRed))
            }
        }
    }
}

struct CurrentFriendRow: View {
    
    @State private var profile_detail_uid : String = "CrWgY9v1nFTfieSo04oALNhc4dp2"

    var body: some View {
        // Need to add dynamic profile opening.
        NavigationLink(destination: ProfileDetailView(profile_detail_uid: self.$profile_detail_uid)) {
            HStack{
                Image("example-avatar")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                
                VStack(alignment: .leading){
                    Text("James Orbell")
                        .font(.headline)
                }.padding()
            }
        }
    }
}

struct FriendsListView: View {
    
    @State private var friends = ["Anita", "Josh"]
    
    var body: some View {
        VStack {
            HStack{
                Text("Friend Requests")
                .font(.headline)
                .padding()
                .foregroundColor(Color.white)
                
                Spacer()
            }
            .background(Color(UIColor.systemGray))
            .padding(.top, -8)
            
            List {
                FriendRequestRow()
                FriendRequestRow()

            }
            .frame(minHeight: 0, maxHeight: 150)
            
            HStack{
                Text("All Friends")
                .font(.headline)
                .padding()
                .foregroundColor(Color.white)
                
                Spacer()
            }
            .background(Color(UIColor.systemGray))
            .padding(.top, -8)
            
            List {
                CurrentFriendRow()
                CurrentFriendRow()
                CurrentFriendRow()
                CurrentFriendRow()
                CurrentFriendRow()
                CurrentFriendRow()
            }
            .frame(minHeight: 0, maxHeight: .infinity)
            
        }.navigationBarTitle(Text("Your Friends"), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            
        }) {
            Image(systemName: "plus")
        })
    }
}

struct FriendsListView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsListView()
    }
}
