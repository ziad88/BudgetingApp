//
//  Category.swift
//  BudgetingApp
//
//  Created by Ziad Alfakharany on 13/01/2023.
//

import Foundation
import RealmSwift

class Category: Object {
    @Persisted var name: String = ""
    
    @Persisted var details = List<Detail>()
}
