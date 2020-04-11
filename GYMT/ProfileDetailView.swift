//
//  ProfileDetailView.swift
//  GYMT
//
//  Created by James Orbell on 18/03/2020.
//  Copyright © 2020 James Orbell. All rights reserved.
//

import SwiftUI

struct Activity: Identifiable {
    var id = UUID()
    var day_no: Int
    var day_name: String
    var activity_length: String
}

struct ProfileDetailView: View {
    
    let modelData: [Activity] =
        [Activity(day_no: 18, day_name: "FEB", activity_length: "1 Hour : 20 Minutes"),
        Activity(day_no: 17, day_name: "FEB", activity_length: "2 Hours : 5 Minutes"),
        Activity(day_no: 13, day_name: "MAR", activity_length: "48 Minutes"),
        Activity(day_no: 09, day_name: "SEP", activity_length: "1 Hour : 14 Minutes"),
        Activity(day_no: 14, day_name: "DEC", activity_length: "1 Hour : 43 Minutes")]
    
    @State private var showingCoinAlert = false
    
    var body: some View {
        
        ScrollView {
            HStack(alignment: .bottom){
                Text("James Orbell")
                    .fontWeight(.heavy)
                    .font(.largeTitle)
                Spacer()
                Image("example-avatar")
                .resizable()
                    .frame(width: 75, height: 75)
                .clipShape(Circle())
            }
            .padding()
            
            HStack{
                VStack(alignment: .leading) {
                    Text("43")
                        .fontWeight(.heavy)
                    Text("Friends")
                }.padding()
                
                VStack(alignment: .leading) {
                    Text("12")
                        .fontWeight(.heavy)
                    Text("Groups")
                }.padding()
                
                Spacer()
                
                Button(action: {
                    self.showingCoinAlert = true
                }) {
                    Text("1945 Coins")
                        .font(.headline)
                }
                .alert(isPresented: $showingCoinAlert) {
                Alert(title: Text("About Coins"),
                      message: Text("Coins are used to reward you for working out. \n \n The number of coins earnt from an activity is calculated using three key metrics: \n \n ⏰ Time taken \n 🔥 Calories burnt \n ❤️ Heart rate \n \n Remember, the number of coins gained depends on the type of challenge too!"), dismissButton: .default(Text("OK")))
                }
                
                Image("coin")
                .resizable()
                .frame(width: 15, height: 15)
                .padding(.trailing, 25)
                
            }
            .frame(height: 70)
            .background(Color(UIColor.systemGray3))
            .padding(.top, -25)
            .padding(.bottom, -8)
            
            HStack{
                Text("Badges & Achievements")
                .font(.headline)
                .padding()
                .foregroundColor(Color.white)
                
                Spacer()
            }
            .background(Color(UIColor.systemBlue))
            .padding(.bottom, -12)
            
            HStack{
                Image("")
            }
            
            HStack{
                Text("Recent Activity")
                .font(.headline)
                .padding()
                .foregroundColor(Color.white)
                
                Spacer()
            }
            .background(Color(UIColor.systemBlue))
            .padding(.bottom, -12)
            
            // Iterate through list to generate the leaderboard according to current points within the challenge. However, currently just points to an external view (need to include variables to parse through etc in the future)

            List(modelData){ Activity in
                HStack{
                    VStack(alignment: .leading){
                        Text("\(Activity.day_no)")
                        Text(Activity.day_name)
                    }.padding()
                    
                    Spacer()
                    
                    Text(Activity.activity_length)
                        .fontWeight(.bold)
                        .padding(.trailing, 20)
                    
                }
                .padding(.top, -10)
                .padding(.bottom, -10)
            }
            .frame(height: 200)
            
            
            HStack{
                Text("Groups")
                .font(.headline)
                .padding()
                .foregroundColor(Color.white)
                
                Spacer()
            }
            .background(Color(UIColor.systemBlue))
            .padding(.top, -8)
            
            GroupRow()
            GroupRow()
            GroupRow()
            
            .navigationBarTitle("Profile")
        }
    }
}

struct ProfileDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileDetailView()
    }
}
