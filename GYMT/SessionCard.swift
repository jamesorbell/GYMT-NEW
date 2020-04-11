//
//  SessionCard.swift
//  GYMT
//
//  Created by James Orbell on 14/03/2020.
//  Copyright © 2020 James Orbell. All rights reserved.
//

import SwiftUI

struct SessionCard: View {
    var body: some View {
        VStack {
            Text("Current Session")
                .padding(.top, 25)
                .font(.system(size: 25, weight: .bold))
            HStack {
                VStack {
                    Image(systemName: "stopwatch.fill")
                    Text("1:20").font(.system(size: 25, weight: .bold))
                    Text("Time").font(.system(size: 15))
                }
                Spacer()
                VStack {
                    Image(systemName: "heart.fill")
                    Text("143").font(.system(size: 25, weight: .bold))
                    Text("HR").font(.system(size: 15))
                }
                Spacer()
                VStack {
                    Image(systemName: "flame.fill")
                    Text("164").font(.system(size: 25, weight: .bold))
                    Text("Cal").font(.system(size: 15))
                }
            }
            .padding(.horizontal, 50)
            .padding(.vertical, 30)
        }
        .foregroundColor(Color.white)
        .background(Color(UIColor.systemBlue))
        .cornerRadius(20)
        .padding()
    }
}

struct SessionCard_Previews: PreviewProvider {
    static var previews: some View {
        SessionCard()
    }
}
