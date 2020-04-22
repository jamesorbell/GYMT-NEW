//
//  HomeView.swift
//  GYMT
//
//  Created by James Orbell on 26/02/2020.
//  Copyright © 2020 James Orbell. All rights reserved.
//
// The nice blue: rgb(31,61,102)
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct OngoingChallenge: Identifiable {
    var id: String
    var ChallengeID: String
    var ChallengeName: String
    var GroupName: String
    var DisplayPicture: String
}

struct HomeView: View {
    
    @State var ongoingChallengeArray: [OngoingChallenge] = [OngoingChallenge(id: "", ChallengeID: "", ChallengeName: "", GroupName: "", DisplayPicture: "")]
    
    @State var show = false
    @State private var profile_detail_uid : String = Auth.auth().currentUser!.uid
    
    var body: some View {
        
        NavigationView {
            
            ScrollView() {
                
                SessionCard()
                
                Text("Ongoing Challenges")
                    .font(.headline)
                    .padding()
                
                if ongoingChallengeArray.isEmpty {
                    HStack{
                        Spacer()
                        Text("None")
                        Spacer()
                    }
                } else {
                    ScrollView(.horizontal){
                        
                        HStack(spacing: 10){
                            
                            ForEach(ongoingChallengeArray) { OngoingChallenge in
                                ChallengeRow(GroupChallengeID: OngoingChallenge.id, ChallengeID: OngoingChallenge.ChallengeID, ChallengeName: OngoingChallenge.ChallengeName, GroupName: OngoingChallenge.GroupName, DisplayPicture: OngoingChallenge.DisplayPicture)
                            }
                            
                        }.padding(.leading, 10)
                        
                    }.frame(height: 250)
                }
                
            }
            .navigationBarTitle(Text("Home"), displayMode: .inline)
            .navigationBarItems(leading:
                HStack {
                    NavigationLink(destination: ProfileDetailView(profile_detail_uid: self.$profile_detail_uid, isProfileExternalUser: false)){
                        Image(systemName: "person.crop.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(Color(UIColor.systemBlue))
                    
                    }
                }
                
                , trailing:
                HStack {
                    
                    NavigationLink(destination: FriendsListView(profile_detail_uid: self.$profile_detail_uid)){
                        Image(systemName: "person.2.fill")
                            .foregroundColor(Color(UIColor.systemBlue))
                        }
                }
            )
            .onAppear{
                self.ongoingChallengeArray = []
                self.loadOngoingChallenges()
            }
        }
    }
    
    func loadOngoingChallenges(){
        let db = Firestore.firestore()
        
        db.collection("Groups-Users")
        .whereField("UserID", isEqualTo: Auth.auth().currentUser!.uid)
        .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        // Iterate through users groups, looking for all challenge instances.
                        let groupID = document.get("GroupID") as! String
                        
                        // Get info.
                        db.collection("Groups-Challenges")
                            .whereField("GroupID", isEqualTo: groupID)
                            // Check that the challenge is active, as this is only ongoing challenges to be shown.
                            .whereField("ActiveStatus", isEqualTo: true)
                            .getDocuments() { (querySnapshot, err) in
                                    if let err = err {
                                        print("Error getting documents: \(err)")
                                    } else {
                                        for document in querySnapshot!.documents {
                                            // Get groupChallengeID and store it in variable. 1/5
                                            let groupChallengeID = document.documentID
                                            // Get challengeID and store it in variable. 2/5
                                            let challengeID = document.get("ChallengeID") as! String
                                            
                                            let docRef1 = db.collection("Challenges").document(challengeID)

                                            docRef1.getDocument { (document, error) in
                                                if let document = document, document.exists {
                                                    // Get challenge name and store it in variable. 3/5
                                                    let challengeName = document.get("ChallengeName") as! String
                                                    
                                                    // Get challenge image name and store it in variable. 4/5
                                                    let challengeIMG = document.get("ChallengeIMG") as! String
                                                    
                                                    let docRef2 = db.collection("Groups").document(groupID)

                                                    docRef2.getDocument { (document, error) in
                                                        if let document = document, document.exists {
                                                            // Get group display name and store it in variable. 5/5
                                                            let groupDisplayName = document.get("GroupName") as! String
                                                            
                                                            // Create instance of Ongoing challenge, and append it to the array of ongoing challenges for current user.
                                                            let challengeinstance: OngoingChallenge = OngoingChallenge(id: groupChallengeID, ChallengeID: challengeID, ChallengeName: challengeName, GroupName: groupDisplayName, DisplayPicture: challengeIMG)
                                                            self.ongoingChallengeArray.append(challengeinstance)
                                                            
                                                        } else {
                                                            print("Document does not exist")
                                                        }
                                                    }
                                                    
                                                } else {
                                                    print("Document does not exist")
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct LeaderboardItemView: View {
    var body: some View {
        HStack{
            Text("1st")
            Spacer()
            Text("Anita Bieda")
        }.padding()
    }
}

struct RecentActivityItemView: View {
    var body: some View {
        HStack{
            VStack {
                Text("19")
                Text("TH")
            }
            .font(.subheadline)
            .padding()
            
            Text("1 Hour : 20 Minutes")
                .font(.subheadline)
                .fontWeight(.heavy)
                .padding()
            
            Spacer()
            
            Text(">")
                .padding()
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: Alignment.topLeading)
        .border(Color.gray)
    }
}

