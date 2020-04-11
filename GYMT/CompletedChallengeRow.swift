//
//  CompletedChallengeRow.swift
//  GYMT
//
//  Created by James Orbell on 18/03/2020.
//  Copyright © 2020 James Orbell. All rights reserved.
//

import SwiftUI

struct CompletedChallengeRow: View {
    var body: some View {
        HStack{
            Text("King of the Hill")
                .font(.headline)
            
            Spacer()
            
            VStack(alignment: .leading){
                Text("17")
                Text("FEB")
            }
            Text(" - ")
            VStack(alignment: .leading){
                Text("20")
                Text("MAR")
            }
        }
        .padding()
    }
}

struct CompletedChallengeRow_Previews: PreviewProvider {
    static var previews: some View {
        CompletedChallengeRow()
    }
}
