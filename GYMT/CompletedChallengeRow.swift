//
//  CompletedChallengeRow.swift
//  GYMT
//
//  Created by James Orbell on 18/03/2020.
//  Copyright © 2020 James Orbell. All rights reserved.
//

import SwiftUI

struct CompletedChallengeRow: View {
    
    @State var GroupChallengeID: String
    @State var ChallengeID: String
    @State var ChallengeName: String
    @State var StartDateString: String
    @State var FinishDateString: String
    
    var body: some View {
        NavigationLink(destination: ChallengeDetailView(ChallengeID: ChallengeID, GroupChallengeID: GroupChallengeID)){
            HStack{
                Text(ChallengeName)
                    .font(.headline)
                Spacer()
                VStack(alignment: .leading){
                    Text(StartDateString)
                }
                Text(" - ")
                VStack(alignment: .leading){
                    Text(FinishDateString)
                }
            }
            .padding()
        }
    }
}
