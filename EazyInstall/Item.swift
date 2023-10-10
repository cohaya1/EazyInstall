//
//  Item.swift
//  EazyInstall
//
//  Created by Chika Ohaya on 10/9/23.
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
