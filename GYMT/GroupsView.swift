//
//  GroupsView.swift
//  GYMT
//
//  Created by James Orbell on 26/02/2020.
//  Copyright © 2020 James Orbell. All rights reserved.
//

import SwiftUI
import FirebaseCoreDiagnostics
import FirebaseInstallations
import FirebaseFirestoreSwift
import Firebase

struct UserGroup: Identifiable {
    let id: String
    let GroupName: String
    let GroupDescription: String
    let GroupVisible: Bool
    let GroupCreatorUserID: String
}

struct GroupsView: View {
    
    @State var selection: Int? = nil
    
    @State var Group_Array: [UserGroup] = []
    
    var body: some View {
        NavigationView {
            VStack{
                
                // Put group rows here.
                ForEach(Group_Array) { UserGroup in
                    GroupRow(GroupID: UserGroup.id, GroupName: UserGroup.GroupName, GroupDescription: UserGroup.GroupDescription, GroupCreatorUserID: UserGroup.GroupCreatorUserID)
                }
                
                NavigationLink(destination: CreateNewGroupDetailView(), tag: 1, selection: $selection) {
                    Button(action: {
                        self.selection = 1
                    }) {
                        HStack {
                            Spacer()
                            Text("Create new group").foregroundColor(Color.white).bold()
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
            .navigationBarTitle("Your Groups", displayMode: .inline)
            .onAppear{
                // Insert what functions to run when the view is loaded.
                self.Group_Array = []
                self.Load_Groups()
            }
        }
    }
    
    //Load groups into groups array.
    func Load_Groups(){
        let db = Firestore.firestore()
        db.collection("Groups-Users")
            .whereField("UserID", isEqualTo: Auth.auth().currentUser!.uid)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Database error: \(err)")
                } else {
                    // No database error, proceed.
                    for document in querySnapshot!.documents {
                        // Get group ID from Group-User table.
                        let GroupID = document.get("GroupID")
                        
                        // Need to find out more information about the group, perform another query for this.
                        let docRef = db.collection("Groups").document(GroupID as! String)
                        
                        docRef.getDocument { (document, error) in
                            if let document = document, document.exists {
                                let GroupName = document.get("GroupName")
                                let GroupDescription = document.get("GroupDescription")
                                let GroupVisible = document.get("GroupVisible")
                                let GroupCreatorUserID = document.get("GroupCreatorUserID")
                                
                                // All information gathered, now add group to the group array to be displayed.
                                let usergroup: UserGroup = UserGroup(id: GroupID as! String, GroupName: GroupName as! String, GroupDescription: GroupDescription as! String, GroupVisible: GroupVisible as! Bool, GroupCreatorUserID: GroupCreatorUserID as! String)
                                
                                // Add the group instance to the group array for display.
                                self.Group_Array.append(usergroup)
                                
                            }
                        }
                    }
                }
                
        }
    }
    
}

struct GroupsView_Previews: PreviewProvider {
    static var previews: some View {
        GroupsView()
    }
}
