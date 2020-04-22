//
//  ActivityDetailView.swift
//  GYMT
//
//  Created by James Orbell on 31/03/2020.
//  Copyright © 2020 James Orbell. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseInstallations
import FirebaseFirestoreSwift
import FirebaseCoreDiagnostics

struct ActivityDetailView: View {
    
    @State var ActivityID: String
    @State var LengthHours: Int64
    @State var LengthSeconds: Int64
    
    // Variables to display about the activity, populated by values using the loadActivity() method.
    @State var MaxHeartRate: Int = 0
    @State var AvgHeartRate: Int = 0
    @State var Steps: Int = 0
    @State var Calories: Int = 0
    @State var Coins: Int = 0
    
    var body: some View {
        VStack {
            List {
                // Time elapsed
                HStack{
                    Image(systemName: "stopwatch.fill")
                        .imageScale(.large)
                        .padding()
                        .frame(width:60)
                    
                    VStack(alignment: .leading){
                        
                        if LengthHours != 0 {
                            Text("\(LengthHours) Hour(s) : \(LengthSeconds) Minutes")
                                .font(.headline)
                        } else {
                            Text("\(LengthSeconds) Minutes")
                                .font(.headline)
                        }
                        Text("Time elapsed").font(.caption)
                    }.padding()
                }
                
                // Maximum heart rate
                HStack{
                    Image(systemName: "suit.heart.fill")
                        .imageScale(.large)
                        .padding()
                        .frame(width:60)
                    
                    VStack(alignment: .leading){
                        Text("\(MaxHeartRate) bpm").font(.headline)
                        Text("Maximum heart rate").font(.caption)
                    }.padding()
                }
                
                // Average heart rate
                HStack{
                    Image(systemName: "heart.circle.fill")
                        .imageScale(.large)
                        .padding()
                        .frame(width:60)
                    
                    VStack(alignment: .leading){
                        Text("\(AvgHeartRate) bpm").font(.headline)
                        Text("Average heart rate").font(.caption)
                    }.padding()
                }
                
                // Steps
                HStack{
                    Image(systemName: "forward.fill")
                        .imageScale(.large)
                        .padding()
                        .frame(width:60)
                    
                    VStack(alignment: .leading){
                        Text("\(Steps)").font(.headline)
                        Text("Steps").font(.caption)
                    }.padding()
                }
                
                // Calories burnt
                HStack{
                    Image(systemName: "flame.fill")
                        .imageScale(.large)
                        .padding()
                        .frame(width:60)
                    
                    VStack(alignment: .leading){
                        Text("\(Calories)").font(.headline)
                        Text("Calories burnt").font(.caption)
                    }.padding()
                }
            }.frame(height: 390)
                
            HStack{
                Spacer()
                Text("+ \(Coins) Coins")
                .padding()
                Image("coin")
                .resizable()
                .frame(width: 15, height: 15)
                .padding(.trailing, 25)
                .padding(.leading, -15)
                Spacer()
            }
            .foregroundColor(Color.white)
            .frame(minWidth: 0, maxWidth: .infinity, alignment: Alignment.topLeading)
            .background(Color(UIColor.systemGray))
                
            Spacer()
            
                
            .onAppear{
                self.loadActivity()
            }
            .navigationBarTitle("Activity breakdown", displayMode: .inline)
        }
    }
    
    // Called by onAppear, used to load activity information from database into variables to be displayed.
    func loadActivity() {
        let db = Firestore.firestore()
        
        let docRef = db.collection("Activities").document(self.ActivityID)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.MaxHeartRate = document.get("AverageHeartRate") as! Int
                self.AvgHeartRate = document.get("MaximumHeartRate") as! Int
                self.Steps = document.get("Steps") as! Int
                self.Calories = document.get("Calories") as! Int
                self.Coins = document.get("Coins") as! Int
            } else {
                print("Activity does not exist")
            }
        }
    }
    
}
