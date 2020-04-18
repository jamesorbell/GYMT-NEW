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
    let FromUserID: String
    let ToUserID: String
    let AcceptedStatus: Bool
}

struct FriendRequestRow: View {
    
    @State var Friend: Friend
    @State var Friend_Display_Name: String
    
    @State private var showingDeleteRequestAlert = false
    
    var body: some View {
        HStack{
            Image("example-avatar")
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            
            VStack(alignment: .leading){
                Text(Friend_Display_Name)
                    .font(.headline)
            }.padding()
            
            Spacer()
            
            Button(action: {
                let db = Firestore.firestore()
                db.collection("Friends").document(self.Friend.id).setData(["AcceptedStatus": true, "ResponseDate": FieldValue.serverTimestamp()], merge: true) { error in
                    if let error = error {
                        print("Error accepting friend request: \(error)")
                    } else {
                        print("Friend request acccepted successfully.")
                    }
                }
                
            }) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 30))
                    .foregroundColor(Color(UIColor.systemGreen))
            }
            
            
            Button(action: {
                // Deny and remove friend request. Should pop up an 'are you sure' alert.
                self.showingDeleteRequestAlert = true
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 30))
                    .foregroundColor(Color(UIColor.systemRed))
            }
            .alert(isPresented: $showingDeleteRequestAlert) {
            Alert(title: Text("Are you sure?"),
                  message: Text("If you delete this request it will have to be resent."), primaryButton: .destructive(Text("Remove")) {
                    // Removal of request from the database
                    let db = Firestore.firestore()
                    db.collection("Friends").document(self.Friend.id).delete() { error in
                        if let error = error {
                            print("Error removing document: \(error)")
                        } else {
                            print("Document successfully removed!")
                        }
                    }
                    // Re-render list
                    
                    
                }, secondaryButton: .cancel())
            }
            
            
        }.onAppear{
            self.GetDisplayName(UserID: self.Friend.FromUserID)
        }
    }
    
    func GetDisplayName(UserID: String){
        let db = Firestore.firestore()
        
        db.collection("Users").document(UserID).getDocument { (document, error) in
            if let document = document, document.exists {
                let firstname = (document.get("FirstName") as! String)
                let lastname = (document.get("LastName") as! String)
                self.Friend_Display_Name = firstname + " " + lastname

            } else {
               print("Document does not exist")

            }
        }
    }
}

struct CurrentFriendRow: View {
    
    @State var Friend: Friend
    @State var Friend_Display_Name: String
    
    @State private var profile_detail_uid : String = ""

    var body: some View {
        // Need to add dynamic profile opening.
        NavigationLink(destination: ProfileDetailView(profile_detail_uid: self.$profile_detail_uid, isProfileExternalUser: true)) {
            HStack{
                Image("example-avatar")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                
                VStack(alignment: .leading){
                    Text(Friend_Display_Name)
                        .font(.headline)
                }.padding()
            }
        }.onAppear{
            if Auth.auth().currentUser!.uid != self.Friend.FromUserID {
                self.GetDisplayName(UserID: self.Friend.FromUserID)
                self.profile_detail_uid = self.Friend.FromUserID
            } else {
                self.GetDisplayName(UserID: self.Friend.ToUserID)
                self.profile_detail_uid = self.Friend.ToUserID
            }
        }
    }
    
    func GetDisplayName(UserID: String){
        let db = Firestore.firestore()
        
        db.collection("Users").document(UserID).getDocument { (document, error) in
            if let document = document, document.exists {
                let firstname = (document.get("FirstName") as! String)
                let lastname = (document.get("LastName") as! String)
                self.Friend_Display_Name = firstname + " " + lastname

            } else {
               print("Document does not exist")

            }
        }
    }
    
}

struct FriendsListView: View {
    
    @State private var isShowingAddFriend = false
    @State private var addFriendEmail = ""
    
    @State private var showingAddFriendAlert = false
    @State private var showingAddFriendAlertMessage = ""
    @State private var closeAddFriend = true
    
    // Fetching the user id of the current user.
    @Binding var profile_detail_uid : String
    
    @State var Friend_Request_Array : [Friend] = []
    @State var Current_Friend_Array : [Friend] = []
    
    var body: some View {
        VStack {
            
            if isShowingAddFriend == true {
                
                VStack {
                    HStack{
                        Text("Add new friend")
                        .font(.headline)
                        .padding()
                        .foregroundColor(Color.white)
                        
                        Spacer()
                    }
                    .background(Color(UIColor.systemGray))
                    .padding(.top, -8)
                    
                    HStack {
                        TextField("Email address", text: $addFriendEmail)
                        .font(.system(size: 14))
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color(UIColor.systemGray),lineWidth: 1))
                        .padding()
                        
                        Button(action: {
                            self.AddFriend(current_uid: self.profile_detail_uid, toAddEmail: self.addFriendEmail)
                        }) {
                            Text("Add")
                            .padding()
                        }
                        .background(Color(UIColor.systemBlue))
                        .foregroundColor(.white)
                        .cornerRadius(25)
                        .padding()
                        
                    }
                }
                .transition(.scale)
            }
            
            HStack{
                Text("Friend Requests")
                .font(.headline)
                .padding()
                .foregroundColor(Color.white)
                
                Spacer()
            }
            .background(Color(UIColor.systemGray))
            .padding(.top, -8)
            
            // List of friend requests.
            List {
                ForEach(Friend_Request_Array) { Friend in
                    FriendRequestRow(Friend: Friend, Friend_Display_Name: "")
                }
            }
            .buttonStyle(PlainButtonStyle())
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
            
            // List of all current friends.
            List(Current_Friend_Array) { Friend in
                CurrentFriendRow(Friend: Friend, Friend_Display_Name: "")
            }
            .frame(minHeight: 0, maxHeight: .infinity)
            
        }
        .alert(isPresented: $showingAddFriendAlert) {
            // Need to make this alert dynamic, make it show an error if not done successfully, but show a confirmation message if it is.

            Alert(title: Text("Alert"), message: Text(showingAddFriendAlertMessage), dismissButton: Alert.Button.default(
                Text("OK"), action: {
                    if self.closeAddFriend {
                        withAnimation{
                            self.isShowingAddFriend.toggle()
                        }
                    }
                }
            ))
        }
        .navigationBarTitle(Text("Your Friends"), displayMode: .inline)
        .navigationBarItems(trailing:
            Button(action: {
                withAnimation{
                    self.addFriendEmail = ""
                    self.showingAddFriendAlertMessage = ""
                    self.isShowingAddFriend.toggle()
                }
            }) {
            Image(systemName: "plus")
        })
            .onAppear{
                self.Friend_Request_Array = []
                self.Current_Friend_Array = []
                self.Load_Friends()
        }
    }
    
    func Load_Friends() {
        // Load lists full of friends.
        
        let db = Firestore.firestore()
        
        // Populate friend request array with pending friend requests.
        db.collection("Friends")
            .whereField("ToUserID", isEqualTo: self.profile_detail_uid)
            .whereField("AcceptedStatus", isEqualTo: false)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting friend requests for current user: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        
                        let friend: Friend = Friend(id: document.documentID, FromUserID: document.get("FromUserID") as! String, ToUserID: document.get("ToUserID") as! String, AcceptedStatus: document.get("AcceptedStatus") as! Bool)
                        
                        self.Friend_Request_Array.append(friend)
                    }
                }
        }
        
        // Populate current friends array with all of the current users' friends.
        db.collection("Friends")
            .whereField("FromUserID", isEqualTo: self.profile_detail_uid)
            .whereField("AcceptedStatus", isEqualTo: true)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting friend requests for current user: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        
                        let friend: Friend = Friend(id: document.documentID, FromUserID: document.get("FromUserID") as! String, ToUserID: document.get("ToUserID") as! String, AcceptedStatus: document.get("AcceptedStatus") as! Bool)
                        
                        self.Current_Friend_Array.append(friend)
                    }
                }
        }
        
        db.collection("Friends")
            .whereField("ToUserID", isEqualTo: self.profile_detail_uid)
            .whereField("AcceptedStatus", isEqualTo: true)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting friend requests for current user: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        
                        let friend: Friend = Friend(id: document.documentID, FromUserID: document.get("FromUserID") as! String, ToUserID: document.get("ToUserID") as! String, AcceptedStatus: document.get("AcceptedStatus") as! Bool)
                        
                        self.Current_Friend_Array.append(friend)
                    }
                }
        }
    }
    
    func AddFriend(current_uid: String, toAddEmail: String){
        // This function should perform database checks, add new document to collection and then return Message for alert.
        var uidToBeAdded: String = ""
        
        let db = Firestore.firestore()
        
        // Does user exist?
        let docRef = db.collection("Users").whereField("Email", isEqualTo: toAddEmail).limit(to: 1)
        docRef.getDocuments { (querySnapshot, err) in
        if err != nil {
            self.showingAddFriendAlertMessage = "Error: Database problem."
            print("Document Error.")
        } else {
            if let doc = querySnapshot?.documents, !doc.isEmpty {
                self.closeAddFriend = true
                
                for document in querySnapshot!.documents {
                    uidToBeAdded = document.documentID
                    
                    if uidToBeAdded == current_uid {
                        self.showingAddFriendAlertMessage = "Error: You cannot add yourself as a friend."
                        self.showingAddFriendAlert = true
                    } else {
                        // User with email confirmed, and not tried to add themselves.
                        
                        // CHECK: Have they already got a request sent TO this user?
                        db.collection("Friends")
                        .whereField("FromUserID", isEqualTo: current_uid)
                        .whereField("ToUserID", isEqualTo: uidToBeAdded)
                        .whereField("AcceptedStatus", isEqualTo: false)
                            .getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            self.showingAddFriendAlertMessage = "Error: Database problem."
                            print("Error getting documents: \(err)")
                        } else {
                            if let doc = querySnapshot?.documents, !doc.isEmpty {
                                self.showingAddFriendAlertMessage = "Error: You already have a pending friend request to this user."
                                self.showingAddFriendAlert = true
                            } else {
                                print("Check for friend request TO user complete.")
                                // Have they already got a friend request FROM this user?
                                db.collection("Friends")
                                .whereField("FromUserID", isEqualTo: uidToBeAdded)
                                .whereField("ToUserID", isEqualTo: current_uid)
                                .whereField("AcceptedStatus", isEqualTo: false)
                                    .getDocuments() { (querySnapshot, err) in
                                if let err = err  {
                                    self.showingAddFriendAlertMessage = "Error: Database problem."
                                    print("Error getting documents: \(err)")
                                } else {
                                    if let doc = querySnapshot?.documents, !doc.isEmpty {
                                        self.showingAddFriendAlertMessage = "Error: You already have a pending friend request from this user"
                                        self.showingAddFriendAlert = true
                                    } else {
                                        print("Check for friend request FROM user complete.")
                                        // Are they already friends? 1/2
                                        db.collection("Friends")
                                        .whereField("FromUserID", isEqualTo: current_uid)
                                        .whereField("ToUserID", isEqualTo: uidToBeAdded)
                                        .whereField("AcceptedStatus", isEqualTo: true)
                                            .getDocuments() { (querySnapshot, err) in
                                        if let err = err  {
                                            self.showingAddFriendAlertMessage = "Error: Database problem."
                                            print("Error getting documents: \(err)")
                                        } else {
                                            if let doc = querySnapshot?.documents, !doc.isEmpty {
                                                self.showingAddFriendAlertMessage = "Error: You're already friends with this user!"
                                                self.showingAddFriendAlert = true
                                            } else{
                                                print("Check for already friends 1/2 complete.")
                                                // Are they already friends? 2/2
                                                db.collection("Friends")
                                                .whereField("FromUserID", isEqualTo: uidToBeAdded)
                                                .whereField("ToUserID", isEqualTo: current_uid)
                                                .whereField("AcceptedStatus", isEqualTo: true)
                                                    .getDocuments() { (querySnapshot, err) in
                                                if let err = err  {
                                                    self.showingAddFriendAlertMessage = "Error: Database problem."
                                                    print("Error getting documents: \(err)")
                                                } else {
                                                    if let doc = querySnapshot?.documents, !doc.isEmpty {
                                                        self.showingAddFriendAlertMessage = "Error: You're already friends with this user!"
                                                        self.showingAddFriendAlert = true
                                                    } else {
                                                        print("Check for already friends 2/2 complete.")
                                                        // IF NOT, then add friend
                                                        var ref: DocumentReference? = nil
                                                        ref = db.collection("Friends").addDocument(data: [
                                                            "FromUserID": current_uid,
                                                            "ToUserID": uidToBeAdded,
                                                            "AcceptedStatus": false,
                                                            "SentDate": FieldValue.serverTimestamp()
                                                        ]) { err in
                                                            if let err = err  {
                                                                self.showingAddFriendAlertMessage = "Error: Database problem."
                                                                print("Error adding document: \(err)")
                                                            } else {
                                                                print("Friend request sent successfully. ID: \(ref!.documentID)")
                                                                self.showingAddFriendAlertMessage = "Friend request sent successfully."
                                                                self.showingAddFriendAlert = true
                                                            }
                                                        }
                                                    }
                                                    }
                                                }
                                            }
                                            }
                                        }
                                    }
                                    }
                                }
                            }
                            }
                        }
                    }
                }
                
            } else {
                // No user found with that email.
                self.closeAddFriend = false
                self.showingAddFriendAlertMessage = "Error: No user found with that email."
                self.showingAddFriendAlert = true
            }
        }
        
        }
    }
}


struct FriendsListView_Previews: PreviewProvider {
    @State static var profile_detail_uid = "CrWgY9v1nFTfieSo04oALNhc4dp2"
    static var previews: some View {
        FriendsListView(profile_detail_uid: $profile_detail_uid)
    }
}
