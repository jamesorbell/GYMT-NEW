//
//  ActivityDetailView.swift
//  GYMT
//
//  Created by James Orbell on 31/03/2020.
//  Copyright © 2020 James Orbell. All rights reserved.
//

import SwiftUI

struct ActivityDetailView: View {
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
                        Text("1 Hour : 15 minutes").font(.headline)
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
                        Text("143 bpm").font(.headline)
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
                        Text("95 bpm").font(.headline)
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
                        Text("3,400").font(.headline)
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
                        Text("475").font(.headline)
                        Text("Calories burnt").font(.caption)
                    }.padding()
                }
            }.frame(height: 390)
                
            HStack{
                Spacer()
                Text("+ 100 Coins")
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
            
            .navigationBarTitle("Activity breakdown", displayMode: .inline)
        }
    }
}

struct ActivityDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityDetailView()
    }
}
