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

struct HomeView: View {
    
    @State var show = false
    
    var body: some View {
        
        NavigationView {
            
            ScrollView() {
                
                SessionCard()
                
                Text("Ongoing Challenges")
                    .font(.headline)
                    .padding()
                
                ScrollView(.horizontal){
                    
                    HStack(spacing: 10){
                        
                        ChallengeRow()
                        ChallengeRow()
                        ChallengeRow()
                        
                    }.padding(.leading, 10)
                    
                }.frame(height: 250)
                
            }
                
                .navigationBarTitle(Text("Home"), displayMode: .inline)
            
            .navigationBarItems(trailing:
                HStack {
                    
                    NavigationLink(destination: ProfileDetailView()){
                        Image(systemName: "person.crop.circle.fill")
                        .font(.largeTitle)
                            .foregroundColor(Color(UIColor.systemBlue))
                    
                    }
                }
            )
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

