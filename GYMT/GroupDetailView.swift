//
//  GroupDetailView.swift
//  GYMT
//
//  Created by James Orbell on 18/03/2020.
//  Copyright © 2020 James Orbell. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseInstallations
import FirebaseFirestoreSwift
import FirebaseCoreDiagnostics

struct GroupDetailView: View {
    
    // Used to pop the view off the navigation stack.
    @Environment(\.presentationMode) var presentationMode
    
    @State var GroupID: String
    @State var GroupName: String
    @State var GroupDescription: String
    @State var GroupCreatorUserID: String
    
    @State private var showingAlert = false
    
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
                    .overlay(GroupTitleOverlay(GroupName: GroupName, GroupDescription: GroupDescription), alignment: .bottomLeading)
                
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
                
                // If current user is the group creator, give the option to delete the group. Else, present the leave group option.
                if GroupCreatorUserID == Auth.auth().currentUser!.uid {
                    // Current user is the groups creator.
                    HStack{
                        Spacer()
                        Button(action: {
                            // What to perform
                            self.showingAlert.toggle()
                        }) {
                            // How the button looks like
                            Text("Delete group")
                                .foregroundColor(Color(UIColor.systemRed))
                                .padding()
                        }
                        Spacer()
                    }.alert(isPresented: $showingAlert) {
                    Alert(title: Text("Are you sure?"),
                          message: Text("If you delete this group, it cannot be recovered. All data will be lost."), primaryButton: .destructive(Text("Remove")) {
                            // Leaving group by deleting Group document and all group-user documents.
                            
                            let db = Firestore.firestore()
                            
                            // Delete all Groups-Users documents.
                            db.collection("Groups-Users")
                                .whereField("GroupID", isEqualTo: self.GroupID)
                                .getDocuments() { (querySnapshot, err) in
                                        if let err = err {
                                            print("Error getting documents: \(err)")
                                        } else {
                                            for document in querySnapshot!.documents {
                                                db.collection("Groups-Users").document(document.documentID).delete() { err in
                                                    if let err = err {
                                                        print("Error removing document: \(err)")
                                                    } else {
                                                        print("Successfully removed user.")
                                                    }
                                                }
                                            }
                                        }
                                }
                            
                            // Delete Groups document
                            db.collection("Groups").document(self.GroupID).delete() { err in
                                if let err = err {
                                    print("Error removing document: \(err)")
                                } else {
                                    print("Group deleted successfully.")
                                }
                            }
                            
                            // Close navigation link and return to parent page.
                            self.presentationMode.wrappedValue.dismiss()
                        }, secondaryButton: .cancel())
                    }
                } else {
                    // Current user is NOT the creator, and just a member.
                    HStack{
                        Spacer()
                        Button(action: {
                            // What to perform
                            self.showingAlert.toggle()
                        }) {
                            Text("Leave group")
                                .foregroundColor(Color(UIColor.systemRed))
                                .padding()
                        }
                        Spacer()
                    }.alert(isPresented: $showingAlert) {
                    Alert(title: Text("Are you sure?"),
                          message: Text("Once you have left the group you cannot be re-added."), primaryButton: .destructive(Text("Leave")) {
                            // Leaving group by deleting Group-User document
                            let db = Firestore.firestore()
                            db.collection("Groups-Users")
                                .whereField("GroupID", isEqualTo: self.GroupID)
                                .whereField("UserID", isEqualTo: Auth.auth().currentUser!.uid)
                                .getDocuments() { (querySnapshot, err) in
                                        if let err = err {
                                            print("Error getting documents: \(err)")
                                        } else {
                                            for document in querySnapshot!.documents {
                                                db.collection("Groups-Users").document(document.documentID).delete() { err in
                                                    if let err = err {
                                                        print("Error removing document: \(err)")
                                                    } else {
                                                        print("Successfully left the group!")
                                                    }
                                                }
                                            }
                                        }
                                }
                            
                            // Close navigation link and return to parent page.
                            self.presentationMode.wrappedValue.dismiss()
                        }, secondaryButton: .cancel())
                    }
                }
            }
        }
        .navigationBarTitle(Text("Group Overview"))
    }
}

struct GroupDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GroupDetailView(GroupID: "LXiKfr4LuP6MGfEPOleg", GroupName: "The Three Muskateers", GroupDescription: "Just three lads from Loughborough.", GroupCreatorUserID: "CrWgY9v1nFTfieSo04oALNhc4dp2")
    }
}

struct GroupTitleOverlay: View {
    
    @State var GroupName: String
    @State var GroupDescription: String
    
    var body: some View {
        VStack(alignment: .leading){
            Text(GroupName)
                .font(.title)
                .fontWeight(.bold)
            Text(GroupDescription)
                .font(.caption)
                .fontWeight(.medium)
        }
        .padding()
        .foregroundColor(Color.white)
    }
}
