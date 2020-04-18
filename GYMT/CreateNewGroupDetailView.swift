//
//  CreateNewGroupDetailView.swift
//  GYMT
//
//  Created by James Orbell on 31/03/2020.
//  Copyright © 2020 James Orbell. All rights reserved.
//

import SwiftUI

struct CreateNewGroupDetailView: View {
    
    // Used to pop the view off the navigation stack if a user has deleted the user.
    @Environment(\.presentationMode) var presentationMode
    
    @State var pickerSelectedItem = 0
    
    @State private var groupname = ""
    @State private var groupdescription = ""
    
    @State private var showingAlert = false
    
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
                    List {
                        Text("James Orbell (You)")
                        NavigationLink(destination: AddGroupParticipantView(), tag: 1, selection: $selection) {
                            Button(action: {
                                self.selection = 1
                            }) {
                                Text("Add participants")
                            }
                        }
                    }
                }
                
                Section(){
                    Button(action: {self.showingAlert = true}) {
                    Text("Create group")
                    }
                    .alert(isPresented:$showingAlert) {
                        Alert(title: Text("Are you sure?"), message: Text("Please make sure you're happy with the information provided. It cannot be changed."), primaryButton: .destructive(Text("Yes, create it!")) {
                            self.presentationMode.wrappedValue.dismiss()
                        }, secondaryButton: .cancel(Text("No! Go back")))
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
