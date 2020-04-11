//
//  CalendarTesting.swift
//  GYMT
//
//  Created by James Orbell on 21/03/2020.
//  Copyright © 2020 James Orbell. All rights reserved.
//

import SwiftUI
import CalendarHeatmap

struct CalendarTesting: View {
    var body: some View {
        ZStack{
            let startDate = Date()
            CalendarHeatmap(startDate: startDate)
        }
    }
}

struct CalendarTesting_Previews: PreviewProvider {
    static var previews: some View {
        CalendarTesting()
    }
}
