//
//  Detail.swift
//  BudgetingApp
//
//  Created by Ziad Alfakharany on 13/01/2023.
//

import Foundation
import RealmSwift

class Detail: Object {
    @Persisted var title: String = ""
    @Persisted var cost: Double = 0.0
    @Persisted var dateCreated: String = ""
    
    @Persisted(originProperty: "details") var parentCategory: LinkingObjects<Category>
    
}
