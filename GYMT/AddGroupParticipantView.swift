//
//  AddGroupParticipantView.swift
//  GYMT
//
//  Created by James Orbell on 18/04/2020.
//  Copyright © 2020 James Orbell. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseInstallations
import FirebaseFirestoreSwift
import FirebaseCoreDiagnostics

struct GroupParticipantRowView: View {
    
    @State var Friend: Friend
    @State var DisplayName = ""
    
    @Binding var selectedItems: Set<String>
    
    var isSelected: Bool {
        selectedItems.contains(Friend.id)
    }
    
    var body: some View {
        HStack {
            Text(self.DisplayName)
                .font(.headline)
                .fontWeight(.medium)
            Spacer()
            if self.isSelected {
                Image(systemName: "checkmark")
                .foregroundColor(Color.blue)
            }
        }
        .contentShape(Rectangle())
        .padding()
        .onAppear{
        self.GetDisplayName(Friend: self.Friend)
        }
        .onTapGesture {
            if self.isSelected {
                self.selectedItems.remove(self.Friend.id)
            } else {
                self.selectedItems.insert(self.Friend.id)
            }
        }
    }
    
    func GetDisplayName(Friend: Friend){
        let db = Firestore.firestore()
        
        if Auth.auth().currentUser!.uid == Friend.ToUserID {
            db.collection("Users").document(Friend.FromUserID).getDocument { (document, error) in
                if let document = document, document.exists {
                    let firstname = (document.get("FirstName") as! String)
                    let lastname = (document.get("LastName") as! String)
                    self.DisplayName = firstname + " " + lastname

                } else {
                   print("Document does not exist")
                }
            }
        } else {
            db.collection("Users").document(Friend.ToUserID).getDocument { (document, error) in
                if let document = document, document.exists {
                    let firstname = (document.get("FirstName") as! String)
                    let lastname = (document.get("LastName") as! String)
                    self.DisplayName = firstname + " " + lastname

                } else {
                   print("Document does not exist")
                }
            }
        }
    }
    
}

struct AddGroupParticipantView: View {
    
    @State private var Friend_Array: [Friend] = []
    
    @State var selectedRows = Set<String>()
    
    var body: some View {
        NavigationView {
            VStack{
                List(Friend_Array, selection: $selectedRows) { Friend in
                    // If current user is equal to ToUserID (A request to them, that they accepted)
                    GroupParticipantRowView(Friend: Friend, selectedItems: self.$selectedRows)
                }
                .navigationBarTitle(Text("Add \(selectedRows.count) participants"))
                .onAppear{
                    self.Friend_Array = []
                    self.Load_Friends()
                }
                
                // Button only appears when at least 1 person has been selected.
                if !selectedRows.isEmpty {
                    Button(action: {}) {
                        HStack {
                            Spacer()
                            Text("Add").foregroundColor(Color.white).bold()
                            Spacer()
                        }
                    }
                    .padding()
                    .background(Color(UIColor.systemBlue))
                    .cornerRadius(20)
                    .padding()
                }
                Spacer()
            }
        }
    }
    
    func Load_Friends() {
        // Load lists full of friends.
        
        let db = Firestore.firestore()
        
        // Populate current friends array with all of the current users' friends.
        db.collection("Friends")
            .whereField("FromUserID", isEqualTo: Auth.auth().currentUser!.uid)
            .whereField("AcceptedStatus", isEqualTo: true)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting friend requests for current user: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        
                        let friend: Friend = Friend(id: document.documentID, FromUserID: document.get("FromUserID") as! String, ToUserID: document.get("ToUserID") as! String, AcceptedStatus: document.get("AcceptedStatus") as! Bool)
                        
                        self.Friend_Array.append(friend)
                    }
                }
        }
        
        db.collection("Friends")
            .whereField("ToUserID", isEqualTo: Auth.auth().currentUser!.uid)
            .whereField("AcceptedStatus", isEqualTo: true)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting friend requests for current user: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        
                        let friend: Friend = Friend(id: document.documentID, FromUserID: document.get("FromUserID") as! String, ToUserID: document.get("ToUserID") as! String, AcceptedStatus: document.get("AcceptedStatus") as! Bool)
                        
                        self.Friend_Array.append(friend)
                    }
                }
        }
    }
    
}

struct AddGroupParticipantView_Previews: PreviewProvider {
    static var previews: some View {
        AddGroupParticipantView()
    }
}
