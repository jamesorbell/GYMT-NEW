//
//  CreateNewGroupDetailView.swift
//  GYMT
//
//  Created by James Orbell on 31/03/2020.
//  Copyright © 2020 James Orbell. All rights reserved.
//

import SwiftUI
import Combine
import Firebase
import FirebaseInstallations
import FirebaseFirestoreSwift
import FirebaseCoreDiagnostics

// Used to switch between two alerts.
enum ActiveAlert {
    case first, second
}

struct CreateNewGroupDetailView: View {
    
    @State private var show_modal: Bool = false
    
    // Used to pop the view off the navigation stack.
    @Environment(\.presentationMode) var presentationMode
    
    // Array of friend relationships, passed between both the create new group view, and the add participant view.
    @State var selectedParticipants: Set<String> = []
    @State var selectedParticipantsDisplayNames: [String] = []
    @State var selectedParticipantsUID: [String] = []
    
    @State var pickerSelectedItem = 0
    
    @State private var groupname = ""
    @State private var groupdescription = ""
    
    @State private var groupUIDCreated = ""
    
    @State private var createGroupError = ""
    
    // Determines if alert is showing, and which alert is showing.
    @State private var showAlert = false
    @State private var activeAlert: ActiveAlert = .second
    
    @State var selection: Int? = nil
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Group info")){
                    TextField("Group name",
                    text: $groupname)
                    TextField("Group description",
                    text: $groupdescription)
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Group visibility")){
                    Picker(selection: $pickerSelectedItem, label: Text("")){
                        Text("Private").tag(0)
                        Text("Public").tag(1)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("People")){
                    List() {
                        Text("James Orbell (You)")
                            .fontWeight(.medium)
                        
                        ForEach(selectedParticipantsDisplayNames, id: \.self) { item in
                            Text(item)
                        }
                        Button(action: {
                            self.show_modal = true
                            self.selection = 1
                        }) {
                            Text("Select participants")
                        }.sheet(isPresented: self.$show_modal) {
                            AddGroupParticipantView(selectedParticipants: self.$selectedParticipants, selectedParticipantsDisplayNames: self.$selectedParticipantsDisplayNames, selectedParticipantsUID: self.$selectedParticipantsUID )
                        }
                    }
                }
                
                Section(){
                    Button(action: {
                        // Perform checks to make sure fields are entered and the user has selected people to add to their group.
                        if self.groupname == "" {
                            // No group name entered.
                            self.createGroupError = "Please enter a group name."
                            self.activeAlert = .second
                            self.showAlert = true
                            
                        } else if self.groupdescription == "" {
                            // No group description entered.
                            self.createGroupError = "Please enter a group description."
                            self.activeAlert = .second
                            self.showAlert = true
                            
                        } else if self.selectedParticipantsUID.isEmpty {
                            // No participants added.
                            self.createGroupError = "You must select at least one other participant to start a group."
                            self.activeAlert = .second
                            self.showAlert = true
                            
                        } else {
                            // Checks complete, good to go.
                            self.activeAlert = .first
                            self.showAlert = true
                        }
                        }) {
                    Text("Create group")
                    }
                        // Are you sure? - Alert
                    .alert(isPresented:$showAlert) {
                        
                        switch activeAlert {
                            case .first: return Alert(title: Text("Are you sure?"), message: Text("Please make sure you're happy with the information provided. It cannot be changed."), primaryButton: .destructive(Text("Yes, create it!")) {
                                
                                var groupvisible = true
                                
                                // Get picker variable. 0 is private, 1 is public.
                                if self.pickerSelectedItem == 0 {
                                    groupvisible = false
                                }
                                
                                let db = Firestore.firestore()
                                var ref1: DocumentReference? = nil
                                ref1 = db.collection("Groups").addDocument(data: [
                                    "GroupName": self.groupname,
                                    "GroupDescription": self.groupdescription,
                                    "GroupVisible": groupvisible,
                                    "GroupCreatorUserID": Auth.auth().currentUser!.uid
                                ]) { err in
                                    if let err = err {
                                        print("Error adding document: \(err)")
                                    } else {
                                        print("Group added with ID: \(ref1!.documentID)")
                                        // Get variable for document id just added, so we can use it to add users.
                                        
                                        // Add current user to that group
                                        var ref2: DocumentReference? = nil
                                        ref2 = db.collection("Groups-Users").addDocument(data: [
                                            "GroupID": ref1!.documentID,
                                            "UserID": Auth.auth().currentUser!.uid
                                        ]) { err in
                                            if let err = err {
                                                print("Error adding document: \(err)")
                                            } else {
                                                print("Group-User relationship added with ID: \(ref2!.documentID)")
                                            }
                                        }
                                        
                                        // Add other users to that new group.
                                        for item in self.selectedParticipantsUID{
                                            var ref3: DocumentReference? = nil
                                            ref3 = db.collection("Groups-Users").addDocument(data: [
                                                "GroupID": ref1!.documentID,
                                                "UserID": item
                                            ]) { err in
                                                if let err = err {
                                                    print("Error adding document: \(err)")
                                                } else {
                                                    print("Group-User relationship added with ID: \(ref3!.documentID)")
                                                }
                                            }
                                        }
                                        
                                    }
                                }
                                
                                // Dismiss alert, and go back from the create new group page.
                                self.presentationMode.wrappedValue.dismiss()
                                
                            }, secondaryButton: .cancel(Text("No! Go back")))
                            
                            case .second: return Alert(title: Text("Error"), message: Text(createGroupError), dismissButton: .default(Text("OK")){
                            })
                        }
                    }
                
                }
                
            } .navigationBarTitle("Create a new group", displayMode: .inline)
        }
    }
}

struct CreateNewGroupDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewGroupDetailView()
    }
}
