//
//  ProfileDetailView.swift
//  GYMT
//
//  Created by James Orbell on 18/03/2020.
//  Copyright © 2020 James Orbell. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct Activity: Identifiable {
    var id = UUID()
    var day_no: Int
    var day_name: String
    var activity_length: String
}

class UserObject: ObservableObject {
    @Published var UserFirstName: String
    @Published var UserLastName: String
    
    init(firstName: String, lastName: String){
        UserFirstName = firstName
        UserLastName = lastName
    }
}

struct ProfileDetailView: View {
    
    // Bug with scroll view, requires at least one element in the array if it contains a ForEach to loop an array.
    @State var Group_Array: [UserGroup] = [UserGroup(id: "", GroupName: "", GroupDescription: "", GroupVisible: true, GroupCreatorUserID: "", GroupCreationDate: Timestamp())]
    
    // Used to pop the view off the navigation stack if a user has deleted the user.
    @Environment(\.presentationMode) var presentationMode
    
    // Fetching the user id of the current user.
    @Binding var profile_detail_uid : String
    
    @State var isProfileExternalUser : Bool
    @State private var showingDeleteRequestAlert = false
    
    @State var UserFirstName: String = ""
    @State var UserLastName: String = ""
    @State var UserCoins: Int = 0
    
    @State var UserFriendCount: Int = 0
    @State var UserGroupCount: Int = 0
    
    @State private var showingCoinAlert = false
    
    var body: some View {
        ScrollView {
            HStack(alignment: .bottom){
                Text("\(UserFirstName) \(UserLastName)")
                    .fontWeight(.heavy)
                    .font(.largeTitle)
                Spacer()
            }
            .padding()
            .padding(.top, 15)
            .padding(.bottom, 15)
            
            HStack{
                VStack(alignment: .leading) {
                    Text("\(UserFriendCount)")
                        .fontWeight(.heavy)
                    Text("Friends")
                }.padding()
                
                VStack(alignment: .leading) {
                    Text("\(UserGroupCount)")
                        .fontWeight(.heavy)
                    Text("Groups")
                }.padding()
                
                Spacer()
                
                Button(action: {
                    self.showingCoinAlert = true
                }) {
                    Text("\(UserCoins) Coins")
                        .font(.headline)
                }
                .alert(isPresented: $showingCoinAlert) {
                Alert(title: Text("About Coins"),
                      message: Text("Coins are GYMT's primary metric and the one used to compare your exercise/workouts with your friends.\n\nTo calculate coins for each activity, GYMT uses an estimate of your maximum heart rate (from your age) and calculates an effort multiplier for the activity based on average heart rate throughout.\n\nThis effort multiplier is then applied to the length of activity to generate a coin value.\n\nThe harder and longer you work, the more coins you will generate.\n\nSo, get out there and get working 🔥"), dismissButton: .default(Text("OK")))
                }
                
                Image("coin")
                .resizable()
                .frame(width: 15, height: 15)
                .padding(.trailing, 25)
                
            }
            .frame(height: 70)
            .background(Color(UIColor.systemGray3))
            .padding(.top, -25)
            .padding(.bottom, -8)
            
            HStack{
                Text("Badges & Achievements")
                .font(.headline)
                .padding()
                .foregroundColor(Color.white)
                
                Spacer()
            }
            .background(Color(UIColor.systemBlue))
            
            HStack{
                Spacer()
                Text("None")
                Spacer()
            }
            .padding()
            
            HStack{
                Text("Public Groups")
                .font(.headline)
                .padding()
                .foregroundColor(Color.white)
                
                Spacer()
            }
            .background(Color(UIColor.systemBlue))
            
            // Load groups here
            if Group_Array.isEmpty {
                HStack{
                    Spacer()
                    Text("None")
                    Spacer()
                }
            .padding()
            } else {
                // Put group rows here.
                ForEach(Group_Array) { UserGroup in
                    GroupRow(GroupID: UserGroup.id, GroupName: UserGroup.GroupName, GroupDescription: UserGroup.GroupDescription, GroupCreatorUserID: UserGroup.GroupCreatorUserID, GroupCreationDate: UserGroup.GroupCreationDate)
                }
            }
            
            HStack{
                if isProfileExternalUser {
                    Button(action: {
                        self.showingDeleteRequestAlert.toggle()
                    }) {
                    Text("Remove friend")
                        .foregroundColor(Color(UIColor.systemRed))
                        .padding()
                    }
                    .padding()
                    .alert(isPresented: $showingDeleteRequestAlert) {
                    Alert(title: Text("Are you sure?"),
                          message: Text("This action cannot be undone and the user will be removed from your friends list."), primaryButton: .destructive(Text("Remove")) {
                            // Removal of friend relationship from the database
                            let db = Firestore.firestore()
                            db.collection("Friends")
                                .whereField("FromUserID", isEqualTo: self.profile_detail_uid)
                                .whereField("ToUserID", isEqualTo: Auth.auth().currentUser!.uid)
                            .getDocuments() { (querySnapshot, err) in
                            if let err = err {
                                print("Error getting documents: \(err)")
                            } else {
                                if let doc = querySnapshot?.documents, !doc.isEmpty {
                                    for document in querySnapshot!.documents {
                                        db.collection("Friends").document(document.documentID).delete() { err in
                                            if let err = err {
                                                print("Error removing document: \(err)")
                                            } else {
                                                print("Friend successfully removed!")
                                            }
                                        }
                                    }
                                    self.presentationMode.wrappedValue.dismiss()
                                } else {
                                    db.collection("Friends")
                                        .whereField("FromUserID", isEqualTo: Auth.auth().currentUser!.uid)
                                        .whereField("ToUserID", isEqualTo: self.profile_detail_uid)
                                        .getDocuments() { (querySnapshot, err) in
                                            if let err = err {
                                                print("Error getting documents: \(err)")
                                            } else {
                                                for document in querySnapshot!.documents {
                                                    db.collection("Friends").document(document.documentID).delete() { err in
                                                        if let err = err {
                                                            print("Error removing document: \(err)")
                                                        } else {
                                                            print("Friend successfully removed!")
                                                        }
                                                    }
                                                }
                                                self.presentationMode.wrappedValue.dismiss()
                                            }
                                    }
                                }
                            }
                            }
                        }, secondaryButton: .cancel())
                    }
                }
            }
            
        }.onAppear{
            self.getUserData()
            self.Group_Array = []
            self.getUserGroups()
        }
    }
    
    func getUserData(){
        let db = Firestore.firestore()

        // Get user information - Firstname and lastname.
        db.collection("Users").document(self.profile_detail_uid).getDocument { (document, error) in
            if let document = document, document.exists {
               let firstName = document.get("FirstName") as! String
               let lastName = document.get("LastName") as! String

                let userdata = UserObject(firstName: firstName, lastName: lastName)
                self.UserFirstName = userdata.UserFirstName
                self.UserLastName = userdata.UserLastName

            } else {
               print("Document does not exist")

            }
        }
        
        // Get user coin value
        db.collection("Activities")
            .whereField("UserID", isEqualTo: self.profile_detail_uid)
            .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        var coincounter: Int = 0
                        for document in querySnapshot!.documents {
                            let coins = document.get("Coins") as! Int
                            coincounter = coincounter + coins
                        }
                        self.UserCoins = coincounter
                    }
            }
        
        // Get user friend value.
        
        // Check friends that are confirmed, where the user in detail sent the request.
        db.collection("Friends")
            .whereField("FromUserID", isEqualTo: self.profile_detail_uid)
            .whereField("AcceptedStatus", isEqualTo: true)
            .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for _ in querySnapshot!.documents {
                            self.UserFriendCount = self.UserFriendCount + 1
                        }
                    }
            }
        
        // Check friends that are confirmed, where the user in detail received the request.
        db.collection("Friends")
            .whereField("ToUserID", isEqualTo: self.profile_detail_uid)
            .whereField("AcceptedStatus", isEqualTo: true)
            .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for _ in querySnapshot!.documents {
                            self.UserFriendCount = self.UserFriendCount + 1
                        }
                    }
            }
        
    }
    
    func getUserGroups(){
        // Get users public groups, as well as the group count.
        let db = Firestore.firestore()
        db.collection("Groups-Users")
            .whereField("UserID", isEqualTo: self.profile_detail_uid)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Database error: \(err)")
                } else {
                    // No database error, proceed.
                    for document in querySnapshot!.documents {
                        // Get group ID from Group-User table.
                        let GroupID = document.get("GroupID") as! String
                        
                        // Need to find out more information about the group, perform another query for this.
                        let docRef = db.collection("Groups").document(GroupID)
                        
                        // Each relationship between a group and the user in detail increments the group count by one.
                        self.UserGroupCount = self.UserGroupCount + 1
                        
                        docRef.getDocument { (document, error) in
                            if let document = document, document.exists {
                                
                                // As this is a profile detail view, it only shows up public groups. Check for this below.
                                let GroupVisible = document.get("GroupVisible") as! Bool
                                
                                if GroupVisible {
                                    // Group is public, then display it. If not, don't add and move on.
                                    let GroupName = document.get("GroupName") as! String
                                    let GroupDescription = document.get("GroupDescription") as! String
                                    let GroupCreatorUserID = document.get("GroupCreatorUserID") as! String
                                    let GroupCreationDate = document.get("GroupCreationDate") as! Timestamp
                                    
                                    // All information gathered, now add group to the group array to be displayed.
                                    let usergroup: UserGroup = UserGroup(id: GroupID, GroupName: GroupName, GroupDescription: GroupDescription, GroupVisible: GroupVisible, GroupCreatorUserID: GroupCreatorUserID, GroupCreationDate: GroupCreationDate)
                                    
                                    // Add the group instance to the group array for display.
                                    self.Group_Array.append(usergroup)
                                }
                            }
                        }
                    }
                }
                
        }
    }
    
}
