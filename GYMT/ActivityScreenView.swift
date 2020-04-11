//
//  CalendarView.swift
//  GYMT
//
//  Created by James Orbell on 26/02/2020.
//  Copyright © 2020 James Orbell. All rights reserved.
//

import SwiftUI

struct ActivityScreenView: View {
    
    @State var pickerSelectedItem = 0
    
    var body: some View {
        NavigationView {
            VStack {
                HStack (spacing: 16){
                    VStack {
                        ZStack (alignment: .bottom) {
                            Capsule().frame(width: 20, height: 200)
                                .foregroundColor(Color(UIColor.systemGray5))
                            Capsule().frame(width: 20, height: 100)
                                .foregroundColor(Color(UIColor.systemGray))
                                .shadow(radius: 3)
                        }
                        Text("Mon")
                            .font(.caption)
                    }
                    VStack {
                        ZStack (alignment: .bottom) {
                            Capsule().frame(width: 20, height: 200)
                                .foregroundColor(Color(UIColor.systemGray5))
                            Capsule().frame(width: 20, height: 100)
                                .foregroundColor(Color(UIColor.systemGray))
                                .shadow(radius: 3)
                        }
                        Text("Tue")
                            .font(.caption)
                    }
                    VStack {
                        ZStack (alignment: .bottom) {
                            Capsule().frame(width: 20, height: 200)
                                .foregroundColor(Color(UIColor.systemGray5))
                            Capsule().frame(width: 20, height: 100)
                                .foregroundColor(Color(UIColor.systemGray))
                                .shadow(radius: 3)
                        }
                        Text("Wed")
                            .font(.caption)
                    }
                    VStack {
                        ZStack (alignment: .bottom) {
                            Capsule().frame(width: 20, height: 200)
                                .foregroundColor(Color(UIColor.systemGray5))
                            Capsule().frame(width: 20, height: 100)
                                .foregroundColor(Color(UIColor.systemGray))
                                .shadow(radius: 3)
                        }
                        Text("Thu")
                            .font(.caption)
                    }
                    VStack {
                        ZStack (alignment: .bottom) {
                            Capsule().frame(width: 20, height: 200)
                                .foregroundColor(Color(UIColor.systemGray5))
                            Capsule().frame(width: 20, height: 100)
                                .foregroundColor(Color(UIColor.systemGray))
                                .shadow(radius: 3)
                        }
                        Text("Fri")
                            .font(.caption)
                    }
                    VStack {
                        ZStack (alignment: .bottom) {
                            Capsule().frame(width: 20, height: 200)
                                .foregroundColor(Color(UIColor.systemGray5))
                            Capsule().frame(width: 20, height: 100)
                                .foregroundColor(Color(UIColor.systemGray))
                                .shadow(radius: 3)
                        }
                        Text("Sat")
                            .font(.caption)
                    }
                    VStack {
                        ZStack (alignment: .bottom) {
                            Capsule().frame(width: 20, height: 200)
                                .foregroundColor(Color(UIColor.systemGray5))
                            Capsule().frame(width: 20, height: 100)
                                .foregroundColor(Color(UIColor.systemGray))
                                .shadow(radius: 3)
                        }
                        Text("Sun")
                            .font(.caption)
                    }
                }
                .padding()
                .padding(.bottom, -30)
                
                Picker(selection: $pickerSelectedItem, label: Text("")){
                    Text("Weekly").tag(0)
                    Text("Monthly").tag(1)
                    Text("Yearly").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                    
                List{
                    ActivityListItem()
                    ActivityListItem()
                    ActivityListItem()
                    ActivityListItem()
                    ActivityListItem()
                }
                
                Spacer()
                
                .navigationBarTitle("Your Activity", displayMode: .inline)
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
    var body: some View {
        NavigationLink(destination: ActivityDetailView()) {
            HStack{
                VStack{
                    Text("19").font(.caption)
                    Text("FEB").font(.caption)
                }
                Text("1 Hour : 15 Minutes")
                    .font(.headline)
                    .padding()
            }
        }
    }
}
