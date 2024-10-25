//
//  Item.swift
//  WellyBus
//
//  Created by Eoin Kelly on 26/10/2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
