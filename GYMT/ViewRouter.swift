//
//  ViewRouter.swift
//  GYMT
//
//  Created by James Orbell on 31/03/2020.
//  Copyright © 2020 James Orbell. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class ViewRouter: ObservableObject {
    
    init() {
        if !UserDefaults.standard.bool(forKey: "didLaunchBefore") {
            UserDefaults.standard.set(true, forKey: "didLaunchBefore")
            currentPage = "page1"
        } else {
            currentPage = "page2"
        }
    }
    
    @Published var currentPage: String {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    let objectWillChange = PassthroughSubject<ViewRouter,Never>()
}
