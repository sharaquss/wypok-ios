//
//  WypokMirkoRepository.swift
//  wypok
//
//  Created by Przemyslaw Jablonski on 19/08/2018.
//  Copyright © 2018 Przemyslaw Jablonski. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class WypokMirkoRepository {
    
    typealias E = MirkoEntity
    
    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let container = appDelegate.persistentContainer
        let context = container.viewContext
        let entityDescription = NSEntityDescription.entity(forEntityName: "MirkoEntity", in: context)!
        let entity = MirkoEntity(entity: entityDescription, insertInto: context)
        entity.application = "Asdasdasd"
        do {
            try context.save()
        } catch {
            //...
        }
    }
    
    
    func put(_ item: E) {
        
    }
    
    func put(_ items: [E]) {
        items.forEach { item in self.put(item) }
    }
    
}
