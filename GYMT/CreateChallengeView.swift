//
//  CreateChallengeView.swift
//  GYMT
//
//  Created by James Orbell on 20/04/2020.
//  Copyright © 2020 James Orbell. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseInstallations
import FirebaseFirestoreSwift
import FirebaseCoreDiagnostics

extension Color {
    init(hex: Int, alpha: Double = 1) {
        let components = (
            R: Double((hex >> 16) & 0xff) / 255,
            G: Double((hex >> 08) & 0xff) / 255,
            B: Double((hex >> 00) & 0xff) / 255
        )
        self.init(
            .sRGB,
            red: components.R,
            green: components.G,
            blue: components.B,
            opacity: alpha
        )
    }
}

struct ChallengePreview: Identifiable, Hashable {
    var id: String
    var name: String
    var lengthindays: NSNumber
    var metric: String
    var desc: String
}

struct ChallengePreviewView: View{
    
    @State var challengeSelected: Bool = false
    @State var challenge: ChallengePreview
    
    @Binding var selectedChallenges: Set<ChallengePreview>
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Text(challenge.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .font(.system(size: 20))
                    .padding()
                    .padding(.bottom, -25)
                Spacer()
            }
            HStack{
                VStack(alignment: .leading){
                    HStack{
                        Text("Length:")
                            .font(.caption)
                            .fontWeight(.bold)
                        Text("\(challenge.lengthindays.stringValue) days")
                            .font(.caption)
                        Spacer()
                    }
                    .padding()
                    .padding(.bottom, -25)
                    HStack{
                        Text("Metric:")
                            .font(.caption)
                            .fontWeight(.bold)
                        Text(challenge.metric)
                            .font(.caption)
                        Spacer()
                    }
                    .padding()
                    .padding(.bottom, -25)
                    Text(challenge.desc)
                        .fixedSize(horizontal: false, vertical: true)
                        .font(.caption)
                        .padding()
                }
                .frame(maxHeight: .infinity)
                .foregroundColor(.white)
                // Check mark filled when selcted, not when deselected.
                
                if self.challengeSelected {
                    Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
                    .padding()
                } else {
                    Image(systemName: "checkmark.circle")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
                    .padding()
                }
            }
        }
        .onTapGesture {
            self.challengeSelected.toggle()
            if self.challengeSelected {
                self.selectedChallenges.insert(ChallengePreview(id: self.challenge.id, name: self.challenge.name, lengthindays: self.challenge.lengthindays, metric: self.challenge.metric, desc: self.challenge.desc))
            } else {
                self.selectedChallenges.remove(ChallengePreview(id: self.challenge.id, name: self.challenge.name, lengthindays: self.challenge.lengthindays, metric: self.challenge.metric, desc: self.challenge.desc))
            }
        }
        .background(Color(UIColor.systemIndigo))
        .frame(maxWidth: .infinity)
        .cornerRadius(25)
        .padding()
        .padding(.bottom, -30)
    }
}

struct CreateChallengeView: View {
    
    // Used to pop the view off the navigation stack.
    @Environment(\.presentationMode) var presentationMode
    
    @State var GroupID: String
    
    @State var isNavigationBarHidden: Bool = true
    
    // Bug with scroll view, requires at least one element in the array if it contains a ForEach to loop an array.
    @State var Challenge_Array: [ChallengePreview] = [ChallengePreview(id: "", name: "", lengthindays: 0, metric: "", desc: "")]
    
    @State var selectedChallengeSet = Set<ChallengePreview>()

    var body: some View {
        NavigationView{
            
            ZStack{
                ScrollView(.vertical){
                    VStack{
                        ForEach(Challenge_Array) { ChallengePreview in
                            ChallengePreviewView(challenge: ChallengePreview, selectedChallenges: self.$selectedChallengeSet)
                        }
                    }
                }
                
                if selectedChallengeSet.isEmpty == false {
                    VStack {
                        Spacer()

                        HStack {
                            Spacer()

                            Button(action: {
                                // Add challenge entry into database.
                                let db = Firestore.firestore()
                                
                                for i in self.selectedChallengeSet {
                                    
                                    let startTime = Timestamp()
                                    let startTimeNSDate = startTime.dateValue()
                                    // Add on the number of days provided.
                                    let endTime = startTimeNSDate.addingTimeInterval((Double(truncating: i.lengthindays) * 86400))
                                    
                                    var ref: DocumentReference? = nil
                                    ref = db.collection("Groups-Challenges").addDocument(data: [
                                        "ChallengeID": i.id,
                                        "GroupID": self.GroupID,
                                        "ActiveStatus": true,
                                        "ChallengeStart": startTime,
                                        "ChallengeEnd": endTime
                                    ]) { err in
                                        if let err = err {
                                            print("Error adding document: \(err)")
                                        } else {
                                            print("Group-Challenge entry added with ID: \(ref!.documentID)")
                                        }
                                    }
                                }
                                
                                self.presentationMode.wrappedValue.dismiss()
                                
                            }, label: {
                                Text("Start selected challenge(s)")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .padding()
                                    .foregroundColor(.white)
                            })
                            .background(Color(UIColor.systemPink))
                            .cornerRadius(38.5)
                            .padding()
                            .shadow(color: Color.black.opacity(0.3),
                                    radius: 3,
                                    x: 3,
                                    y: 3)
                            
                            Spacer()
                        }
                    }
                }
            }.navigationBarTitle("")
            .navigationBarHidden(self.isNavigationBarHidden)
            .onAppear{
                self.isNavigationBarHidden = true
                // Load challenges into challenge array.
                self.Challenge_Array = []
                self.loadChallenges()
            }
        }
    }
    
    func loadChallenges(){
        let db = Firestore.firestore()
        db.collection("Challenges")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let challenge: ChallengePreview = ChallengePreview(id: document.documentID, name: document.get("ChallengeName") as! String, lengthindays: document.get("LengthInDays") as! NSNumber, metric: document.get("Metric") as! String, desc: document.get("ChallengeDescription") as! String)
                        self.Challenge_Array.append(challenge)
                    }
                }
        }
    }
}
