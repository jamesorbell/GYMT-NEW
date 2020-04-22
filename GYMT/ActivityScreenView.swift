//
//  CalendarView.swift
//  GYMT
//
//  Created by James Orbell on 26/02/2020.
//  Copyright © 2020 James Orbell. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseInstallations
import FirebaseFirestoreSwift
import FirebaseCoreDiagnostics

struct ActivityPreview: Identifiable {
    let id: String // Activity ID
    let StartNSDate: NSDate // Pass NSDate, to be reformatted later.
    let Length: Int64 // Given length in seconds. As a 64 bit integer.
}

struct ActivityScreenView: View {
    
    @State var Activity_Preview_Array: [ActivityPreview] = []
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        NavigationView {
            VStack {
                
                Text("This Week")
                    .font(.caption)
                    .padding()
                    .padding(.bottom, -40)
                
                HStack{
                    Spacer()
                    
                    HStack (spacing: 16){
                        VStack {
                            ZStack (alignment: .bottom) {
                                Capsule().frame(width: 20, height: 150)
                                    .foregroundColor(Color(UIColor.systemGray5))
                                Capsule().frame(width: 20, height: 100)
                                    .foregroundColor(Color(UIColor.systemPink))
                                    .shadow(radius: 3)
                            }
                            Text("Mon")
                                .font(.caption)
                        }
                        VStack {
                            ZStack (alignment: .bottom) {
                                Capsule().frame(width: 20, height: 150)
                                    .foregroundColor(Color(UIColor.systemGray5))
                                Capsule().frame(width: 20, height: 100)
                                    .foregroundColor(Color(UIColor.systemPink))
                                    .shadow(radius: 3)
                            }
                            Text("Tue")
                                .font(.caption)
                        }
                        VStack {
                            ZStack (alignment: .bottom) {
                                Capsule().frame(width: 20, height: 150)
                                    .foregroundColor(Color(UIColor.systemGray5))
                                Capsule().frame(width: 20, height: 10)
                                    .foregroundColor(Color(UIColor.systemPink))
                                    .shadow(radius: 3)
                            }
                            Text("Wed")
                                .font(.caption)
                        }
                        VStack {
                            ZStack (alignment: .bottom) {
                                Capsule().frame(width: 20, height: 150)
                                    .foregroundColor(Color(UIColor.systemGray5))
                                Capsule().frame(width: 20, height: 60)
                                    .foregroundColor(Color(UIColor.systemPink))
                                    .shadow(radius: 3)
                            }
                            Text("Thu")
                                .font(.caption)
                        }
                        VStack {
                            ZStack (alignment: .bottom) {
                                Capsule().frame(width: 20, height: 150)
                                    .foregroundColor(Color(UIColor.systemGray5))
                                Capsule().frame(width: 20, height: 125)
                                    .foregroundColor(Color(UIColor.systemPink))
                                    .shadow(radius: 3)
                            }
                            Text("Fri")
                                .font(.caption)
                        }
                        VStack {
                            ZStack (alignment: .bottom) {
                                Capsule().frame(width: 20, height: 150)
                                    .foregroundColor(Color(UIColor.systemGray5))
                                Capsule().frame(width: 20, height: 75)
                                    .foregroundColor(Color(UIColor.systemPink))
                                    .shadow(radius: 3)
                            }
                            Text("Sat")
                                .font(.caption)
                        }
                        VStack {
                            ZStack (alignment: .bottom) {
                                Capsule().frame(width: 20, height: 150)
                                    .foregroundColor(Color(UIColor.systemGray5))
                                Capsule().frame(width: 20, height: 50)
                                    .foregroundColor(Color(UIColor.systemPink))
                                    .shadow(radius: 3)
                            }
                            Text("Sun")
                                .font(.caption)
                        }
                    }
                    .padding()
                    
                    Spacer()
                    
                }.padding()
                .padding(.bottom, -20)
                
                HStack{
                    Text("Your Activities")
                    .font(.headline)
                    .padding()
                    .foregroundColor(Color.white)
                    
                    Spacer()
                }
                .background(Color(UIColor.systemBlue))
                .padding(.bottom, -12)
                
                // List of activities.
                List(Activity_Preview_Array) { activitypreview in
                    ActivityListItem(ActivityPreview: activitypreview)
                }
                
                Spacer()
                
                    .onAppear{
                        // Fetch all users activities
                        self.Activity_Preview_Array = []
                        self.getActivities()
                }
                .navigationBarTitle("Activity Overview", displayMode: .inline)
            }
        }
    }
    
    func getActivities(){
        let db = Firestore.firestore()
        
        db.collection("Activities")
        .whereField("UserID", isEqualTo: Auth.auth().currentUser!.uid)
        .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting friend requests for current user: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        
                        let starttimestamp = document.get("TimeStarted") as! Timestamp
                        let endtimestamp = document.get("TimeFinished") as! Timestamp
                        let length = (endtimestamp.seconds) - (starttimestamp.seconds)
                        
                        let startdate = starttimestamp.dateValue() // Converts timestamp to NSDate value. Some precision lost, but not nearly enough to be worried about.
                        
                        let activity: ActivityPreview = ActivityPreview(id: (document.documentID), StartNSDate: startdate as NSDate, Length: length)
                        
                        self.Activity_Preview_Array.append(activity)
                    }
                }
        }
    }
}

struct ActivityScreenView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityScreenView()
    }
}

struct ActivityListItem: View {
    
    var ActivityPreview: ActivityPreview
    
    @State var lengthinseconds: (Int64, Int64) = (0,0)
    @State var DateString: String = ""
    @State var YearString: String = ""
    
    var body: some View {
        NavigationLink(destination: ActivityDetailView(ActivityID: ActivityPreview.id, LengthHours: lengthinseconds.0, LengthSeconds: lengthinseconds.1)) {
            HStack{
                VStack{
                    Text(DateString).font(.caption)
                    Text(YearString).font(.caption)
                }.padding()
                // If activity longer than an hour:
                if lengthinseconds.0 != 0 {
                    Text("\(lengthinseconds.0) Hour(s) : \(lengthinseconds.1) Minutes")
                    .padding()
                } else {
                    Text("\(lengthinseconds.1) Minutes")
                    .padding()
                }
            }
        }.onAppear{
            // Find the minutes and hours of each activity.
            self.secondsToHoursMinutes()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d"
            self.DateString = dateFormatter.string(from: self.ActivityPreview.StartNSDate as Date)
            dateFormatter.dateFormat = "y"
            self.YearString = dateFormatter.string(from: self.ActivityPreview.StartNSDate as Date)
        }
    }
    
    // Function to return the minutes and hours of each activity.
    func secondsToHoursMinutes() {
        self.lengthinseconds = ((ActivityPreview.Length / 3600), ((ActivityPreview.Length % 3600) / 60))
    }
    
}
