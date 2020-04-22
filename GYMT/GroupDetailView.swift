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

struct GroupMember: Identifiable {
    let id: String //Used to open user detail view for each user and identify them.
    let DisplayName: String // The display name, don't want to view each user using their ID.
    let Coins: Int // Used to sort list, depending on value of coins. This value however, is the coins each member has in THAT GROUP.
}

struct CompletedChallenge: Identifiable {
    var id: String
    var ChallengeID: String
    var ChallengeName: String
    var StartDateString: String
    var FinishDateString: String
}

struct GroupMemberRow: View {
    var groupmember: GroupMember

    var body: some View {
        VStack (alignment: .leading){
            Text(groupmember.DisplayName)
                .font(.headline)
                .padding()
                .padding(.top, -10)
            Text("+ \(groupmember.Coins) Coins")
                .padding()
                .padding(.top, -25)
                .padding(.bottom, -10)
        }
    }
}

struct GroupDetailView: View {
    
    // Used to store ongoing challenges for that group.
    @State var ongoingChallengeArray: [OngoingChallenge] = [OngoingChallenge(id: "", ChallengeID: "", ChallengeName: "", GroupName: "", DisplayPicture: "")]
    
    // Used to store completed challenges for that group.
    @State var completedChallengeArray: [CompletedChallenge] = [CompletedChallenge(id: "", ChallengeID: "", ChallengeName: "", StartDateString: "", FinishDateString: "")]
    
    // Used to pop the view off the navigation stack.
    @Environment(\.presentationMode) var presentationMode
    
    @State var GroupID: String
    @State var GroupName: String
    @State var GroupDescription: String
    @State var GroupCreatorUserID: String
    @State var GroupCreationDate: Timestamp
    
    // Array of group members, populated by the functions inside onAppear(). Empty upon opening the view.
    @State var GroupMember_Array: [GroupMember] = []
    
    @State private var showingAlert = false
    
    @State private var showingCompletedChallenges = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                HStack{
                    VStack(alignment: .leading){
                        Text(GroupName)
                            .font(.title)
                            .fontWeight(.bold)
                        Text(GroupDescription)
                            .font(.subheadline)
                    }
                    .padding()
                    .padding(.top, 25)
                    .padding(.bottom, 25)
                }
                
                HStack{
                    Text("Lifetime Leaderboard")
                    .font(.headline)
                    .padding()
                    .foregroundColor(Color.white)
                    
                    Spacer()
                }
                .background(Color(UIColor.systemBlue))
                .padding(.top, -8)
                
                // List of users here, with their coin values since group creation tracked. Before displaying, sorts them into order of coins gained.
                List(GroupMember_Array.sorted{ $0.Coins > $1.Coins }) { groupmember in
                    GroupMemberRow(groupmember: groupmember)
                }
                .padding(.top, -12)
                .frame(height: 250)
                
                HStack{
                    Text("Ongoing Challenges")
                    .font(.headline)
                    .padding()
                    .foregroundColor(Color.white)
                    
                    Spacer()
                    
                    if GroupCreatorUserID == Auth.auth().currentUser!.uid {
                        NavigationLink(destination: CreateChallengeView(GroupID: self.GroupID)) {
                            Image(systemName: "plus")
                            .foregroundColor(.white)
                        }.padding()
                    }
                }
                .background(Color(UIColor.systemBlue))
                .padding(.top, -10)
                
                if ongoingChallengeArray.isEmpty {
                    HStack{
                        Spacer()
                        Text("None")
                        .padding()
                        Spacer()
                    }
                } else {
                    ScrollView(.horizontal){
                        HStack(spacing: 10){
                            
                            ForEach(ongoingChallengeArray) { OngoingChallenge in
                                ChallengeRow(GroupChallengeID: OngoingChallenge.id, ChallengeID: OngoingChallenge.ChallengeID, ChallengeName: OngoingChallenge.ChallengeName, GroupName: OngoingChallenge.GroupName, DisplayPicture: OngoingChallenge.DisplayPicture)
                            }
                            
                        }.padding(.leading, 10)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: Alignment.topLeading)
                }
                
                HStack{
                    Text("Completed Challenges")
                    .font(.headline)
                    .padding()
                    .foregroundColor(Color.white)
                    
                    Spacer()
                    
                }
                .background(Color(UIColor.systemBlue))
                
                if completedChallengeArray.isEmpty {
                    HStack{
                        Spacer()
                        Text("None")
                        Spacer()
                    }
                .padding()
                } else {
                    ScrollView(.vertical){
                        HStack(spacing: 10){
                            List(completedChallengeArray) { challenge in
                                CompletedChallengeRow(GroupChallengeID: challenge.id, ChallengeID: challenge.ChallengeID, ChallengeName: challenge.ChallengeName, StartDateString: challenge.StartDateString, FinishDateString: challenge.FinishDateString )
                            }
                            .padding(.top, -12)
                            .frame(height: 250)

                        }.padding(.leading, 10)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: Alignment.topLeading)
                }
                
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
        }.onAppear{
            // Code for loading list of groups.
            self.GroupMember_Array = []
            self.Load_Group_Members()
            // Code for loading ongoing challenges.
            self.ongoingChallengeArray = []
            self.completedChallengeArray = []
            self.loadChallenges()
        }
        .navigationBarTitle(Text("Group Overview"))
    }
    
    // Function that loads the group members into the Group Member array. Called by onAppear() when view is rendered.
    func Load_Group_Members(){
        let db = Firestore.firestore()
        
        db.collection("Groups-Users")
            .whereField("GroupID", isEqualTo: self.GroupID)
            .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting users in current group: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            // No error getting users. Proceed.
                            
                            // Got user ID
                            let UserID = document.get("UserID") as! String
                            
                            // Now get user display name
                            db.collection("Users").document(UserID)
                                .getDocument { (document, error) in
                                if let document = document, document.exists {
                                    let firstname = (document.get("FirstName") as! String)
                                    let lastname = (document.get("LastName") as! String)
                                    let DisplayName = firstname + " " + lastname
                                    
                                    // Now get coins generated since group was created.
                                    
                                    db.collection("Activities")
                                        .whereField("UserID", isEqualTo: UserID)
                                        .getDocuments() { (querySnapshot, err) in
                                                if let err = err {
                                                    print("Error getting activities for this user: \(err)")
                                                } else {
                                                    // Define variable coins, to be added to on each activity found - depending on the number of coins gained.
                                                    var coins_counter = 0
                                                    
                                                    for document in querySnapshot!.documents {
                                                        // Was activity started before or after group creation, determines if added to the coin value within the group. Can't query using whereField of it, as it has two components seconds and nanoseconds. So disregard nanosecond precision, and just compare the seconds.
                                                        let activityFinish = document.get("TimeFinished") as! Timestamp
                                                        let activityFinishSeconds = activityFinish.seconds
                                                        let GroupCreationDateSeconds = self.GroupCreationDate.seconds
                                                        
                                                        let coinstoadd = document.get("Coins") as! Int

                                                        if activityFinishSeconds > GroupCreationDateSeconds {
                                                            coins_counter = coins_counter + coinstoadd
                                                        }
                                                    }
                                                    // All stuff done. Now add user to the group member array.
                                                    let MemberToAdd: GroupMember = GroupMember(id: UserID, DisplayName: DisplayName, Coins: coins_counter)
                                                    
                                                    self.GroupMember_Array.append(MemberToAdd)
                                                }
                                        }
                                    
                                } else {
                                    print("User does not exist")
                                }
                            }
                        }
                    }
            }
    }
    
    // Function that loads the ongoing challenges for the group into the ongoingChallengeArray. Called by onAppear() when view is rendered.
    func loadChallenges(){
        let db = Firestore.firestore()
        
        db.collection("Groups-Challenges")
            .whereField("GroupID", isEqualTo: self.GroupID)
            .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            
                            let groupchallengeID = document.documentID
                            
                            // Date formatter, used to format dates for date strings.
                            let formatter = DateFormatter()
                            formatter.dateFormat = "MMM d"
                            
                            // Start and finish date strings, for use with completed challenges.
                            let startdate = (document.get("ChallengeStart") as! Timestamp).dateValue()
                            let finishdate = (document.get("ChallengeEnd") as! Timestamp).dateValue()
                            
                            let startdatestring = formatter.string(from: startdate)
                            let finishdatestring = formatter.string(from: finishdate)

                            if (document.get("ActiveStatus") as! Bool) == true {
                                // If ActiveStatus = true, then load into ongoing challenges.
                                let groupname = self.GroupName
                                db.collection("Challenges").document(document.get("ChallengeID") as! String)
                                .getDocument { (document, error) in
                                    if let document = document, document.exists {
                                        let challengeID = document.documentID
                                        let challengename = document.get("ChallengeName") as! String
                                        let displaypicture = document.get("ChallengeIMG") as! String
                                        
                                        let currentchallenge: OngoingChallenge = OngoingChallenge(id: groupchallengeID, ChallengeID: challengeID, ChallengeName: challengename, GroupName: groupname, DisplayPicture: displaypicture)
                                        self.ongoingChallengeArray.append(currentchallenge)
                                        
                                    } else {
                                        print("Document does not exist")
                                    }
                                }
                                
                            } else {
                                // Else, load into completed challenges.
                                db.collection("Challenges").document(document.get("ChallengeID") as! String)
                                .getDocument { (document, error) in
                                    if let document = document, document.exists {
                                        let challengeID = document.documentID
                                        let challengename = document.get("ChallengeName") as! String

                                        let currentchallenge: CompletedChallenge = CompletedChallenge(id: groupchallengeID, ChallengeID: challengeID, ChallengeName: challengename, StartDateString: startdatestring, FinishDateString: finishdatestring)
                                        self.completedChallengeArray.append(currentchallenge)
                                        
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
