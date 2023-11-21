//
//  CoreDataViewModel.swift
//  EazyInstall
//
//  Created by Chika Ohaya on 11/17/23.
//

import CoreData
import SwiftUI

class CoreDataViewModel: ObservableObject {
    let managedObjectContext: NSManagedObjectContext

    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }

    func saveText(_ text: String) {
        let newEntity = ScannedText(context: managedObjectContext)
        newEntity.scantext = text

        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}

