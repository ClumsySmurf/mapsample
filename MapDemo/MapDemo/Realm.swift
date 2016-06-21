//
//  Realm.swift
//  MapDemo
//
//  Created by John Hamilton on 6/20/16.
//  Copyright © 2016 TLDR. All rights reserved.
//

import RealmSwift

extension Realm {
    
    func filter<ParentType: Object>(parentType parentType: ParentType.Type, subclasses: [ParentType.Type], predicate: NSPredicate?) -> [ParentType] {
        
        if (predicate == nil) {
            return ([parentType] + subclasses).flatMap { classType in
                return Array(self.objects(classType))
            }

        } else {
            return ([parentType] + subclasses).flatMap { classType in
                return Array(self.objects(classType).filter(predicate!))
            }
        }
    }
    
    
}
