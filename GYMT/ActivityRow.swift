//
//  ActivityRow.swift
//  GYMT
//
//  Created by James Orbell on 14/03/2020.
//  Copyright © 2020 James Orbell. All rights reserved.
//

import SwiftUI

struct ActivityRow: View {
    var body: some View {
        NavigationLink {
            HStack{
                VStack{
                    Text("19")
                        .font(.subheadline)
                    Text("FRI")
                        .font(.subheadline)
                }
                .padding()
                
                Text("1 Hour : 20 Minutes")
                    .fontWeight(.heavy)
                
                Spacer()
            
                Text(">")
                    .padding()
            }
        }
    }
}

struct ActivityRow_Previews: PreviewProvider {
    static var previews: some View {
        ActivityRow()
    }
}
