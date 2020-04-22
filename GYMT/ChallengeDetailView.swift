//
//  ChallengeDetailView.swift
//  GYMT
//
//  Created by James Orbell on 16/03/2020.
//  Copyright © 2020 James Orbell. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseInstallations
import FirebaseFirestoreSwift
import FirebaseCoreDiagnostics
import Foundation

struct ChallengeMember: Identifiable {
    let id: String // Used to identify users.
    let DisplayName: String // The display name, don't want to view each user using their ID.
    let MetricValue: Double // Used to sort list, depending on the metric used by the challenge.
}

struct ChallengeMemberRowView: View {
    
    @State var challengemember: ChallengeMember
    @State var ChallengeMetric: String
    
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text(challengemember.DisplayName)
                    .font(.headline)
                Text("+\(String(format:"%.0f", challengemember.MetricValue)) \(ChallengeMetric)")
            }.padding()
            
            Spacer()
            
        }
        .padding(.top, -10)
        .padding(.bottom, -10)
    }
}

struct ChallengeDetailView: View {
    
    @State var ChallengeID: String
    @State var GroupChallengeID: String
    
    // Challenge info to display, populated using the loadChallenge() function.
    @State var FinishTime: Date = Date()
    @State var FinishTimeString: String = ""
    @State var ChallengeName: String = ""
    @State var GroupName: String = ""
    @State var ChallengeDesc: String = ""
    @State var ChallengeMetric: String = ""
    @State var ChallengeActive: Bool = true
    
    // Array represnting all members of the group, used to iterate through and get display names and metric scores.
    @State var groupMembers: [String] = []
    @State var ChallengeLeaderboardArray: [ChallengeMember] = []
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack{
                    VStack(alignment: .leading){
                        Text(ChallengeName)
                            .font(.title)
                            .fontWeight(.bold)
                        Text(GroupName)
                            .font(.subheadline)
                        
                        HStack{
                            if ChallengeActive == true {
                                Text("Ends:")
                                .font(.headline)
                                .fontWeight(.bold)
                            } else {
                                Text("Ended:")
                                .font(.headline)
                                .fontWeight(.bold)
                            }
                            Text(FinishTimeString)
                                .font(.headline)
                                .fontWeight(.medium)
                                .foregroundColor(Color(UIColor.systemPink))
                        }
                        .padding(.top, 25)
                    }
                    .padding()
                    .padding(.bottom, 25)
                    
                    Spacer()
                    
                    // Checks if challenge is complete or ongoing.
                    if ChallengeActive == true {
                        Text("Ongoing")
                        .font(.headline)
                        .padding()
                    } else {
                        Text("Completed")
                        .font(.headline)
                        .padding()
                    }

                }.padding(.top, -80)

                HStack{
                    Text("Description")
                    .font(.headline)
                    .padding()
                    .foregroundColor(Color.white)
                    
                    Spacer()
                }
                .background(Color(UIColor.systemGray))
                .padding(.top, -8)
                
                Text(ChallengeDesc)
                    .font(.caption)
                    .padding()
                
                HStack{
                    Text("Leaderboard")
                    .font(.headline)
                    .padding()
                    .foregroundColor(Color.white)
                    
                    Spacer()
                }
                .background(Color(UIColor.systemGray))
                
                // Leaderboard list
                List(ChallengeLeaderboardArray.sorted{ $0.MetricValue > $1.MetricValue }) { member in
                    ChallengeMemberRowView(challengemember: member, ChallengeMetric: self.ChallengeMetric)
                }
                
                Spacer()
            }
        }.onAppear{
            self.loadChallengeInfo()
            self.loadMembers()
        }
    }
    
    func loadChallengeInfo(){
        // Load stuff about challenge.
        let db = Firestore.firestore()
        db.collection("Groups-Challenges").whereField("ChallengeID", isEqualTo: self.ChallengeID)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        // Load challenge finish time.
                        let finishtimestamp = document.get("ChallengeEnd") as! Timestamp
                        self.FinishTime = finishtimestamp.dateValue()
                        
                        let formatter = DateFormatter()
                        formatter.dateFormat = "MMM d, h:mm a"
                        self.FinishTimeString = formatter.string(from: self.FinishTime)
                        
                        // Load group name
                        let GroupID = document.get("GroupID") as! String
                        db.collection("Groups").document(GroupID)
                        .getDocument { (document, error) in
                            if let document = document, document.exists {
                                self.GroupName = document.get("GroupName") as! String
                            } else {
                                print("Group does not exist")
                            }
                        }
                    }
                }
        }
        // Get Challenge Name, Description and chosen Metric.
        db.collection("Challenges").document(self.ChallengeID)
        .getDocument { (document, error) in
            if let document = document, document.exists {
                self.ChallengeName = document.get("ChallengeName") as! String
                self.ChallengeDesc = document.get("ChallengeDescription") as! String
                self.ChallengeMetric = document.get("Metric") as! String
            } else {
                print("Challenge does not exist")
            }
        }
    }
    
    func loadMembers(){
        let db = Firestore.firestore()
        // Load the group members array.
        db.collection("Groups-Challenges").document(self.GroupChallengeID)
        .getDocument { (document, error) in
            if let document = document, document.exists {
                // Fetch group ID associated with the challenge.
                let groupID = document.get("GroupID") as! String
                
                // Set status of challenge.
                if (document.get("ActiveStatus") as! Bool) == false {
                    self.ChallengeActive = false
                }
                
                db.collection("Groups-Users")
                    .whereField("GroupID", isEqualTo: groupID)
                    .getDocuments() { (querySnapshot, err) in
                            if let err = err {
                                print("Error getting group members: \(err)")
                            } else {
                                for document in querySnapshot!.documents {
                                    // For each member in group, add their ID to the group members array.
                                    let userid = document.get("UserID") as! String
                                    self.groupMembers.append(userid)
                                }
                                // Then load leaderboard array.
                                
                                // From the group members array, generate a leaderboard of ChallengeMember objects. Each containing an id, displayname and metric value.
                                for item in self.groupMembers {
                                    
                                    // Get display name.
                                    db.collection("Users").document(item)
                                        .getDocument { (document, error) in
                                            if let document = document, document.exists {
                                                // Get display name
                                                let firstname = document.get("FirstName") as! String
                                                let lastname = document.get("LastName") as! String
                                                let userDisplayName = firstname + " " + lastname
                                                
                                                // Metric counter, used to tally up users scores on the given challenge metric.
                                                var metriccounter: Double = 0
                                                
                                                db.collection("Activities")
                                                .whereField("UserID", isEqualTo: item)
                                                .getDocuments() { (querySnapshot, err) in
                                                        if let err = err {
                                                            print("Error getting activity: \(err)")
                                                        } else {
                                                            for document in querySnapshot!.documents {
                                                                
                                                                // Get activity metrics
                                                                let activity_coins = Double(truncating: document.get("Coins") as! NSNumber)
                                                                let activity_steps = Double(truncating: document.get("Steps") as! NSNumber)
                                                                let activity_calories = Double(truncating: document.get("Calories") as! NSNumber)
                                                                
                                                                let activityid = document.documentID
                                                                // For each activity, check if it has a activity-group-challenge entry with the same as the current page.
                                                                db.collection("Activities-Groups-Challenges")
                                                                    .whereField("ActivityID", isEqualTo: activityid)
                                                                    .whereField("GroupChallengeID", isEqualTo: self.GroupChallengeID)
                                                                    .getDocuments() { (querySnapshot, err) in
                                                                            if let err = err {
                                                                                print("Error: \(err)")
                                                                            } else {
                                                                                // Activity IS in the challenge. Do the below:
                                                                                if self.ChallengeMetric == "Coins" {
                                                                                    // Coins gained
                                                                                    metriccounter = metriccounter + activity_coins
                                                                                } else if self.ChallengeMetric == "Steps" {
                                                                                    // Steps
                                                                                    metriccounter = metriccounter + activity_steps
                                                                                } else {
                                                                                    // Calories burnt
                                                                                    metriccounter = metriccounter + activity_calories
                                                                                }
                                                                            }
                                                                    }
                                                            }
                                                        }
                                                }
                                                
                                                // Add to leaderboard array.
                                                let memberLeaderboardInstance: ChallengeMember = ChallengeMember(id: item, DisplayName: userDisplayName, MetricValue: metriccounter)
                                                self.ChallengeLeaderboardArray.append(memberLeaderboardInstance)
                                                
                                            } else {
                                                print("Document does not exist")
                                            }
                                        }
                                }
                            }
                    }
                
            } else {
                print("Challenge does not exist")
            }
        }
        
    }
}
