//
//  Balance.swift
//  BudgetingApp
//
//  Created by Ziad Alfakharany on 14/01/2023.
//

import Foundation
import RealmSwift

class Balance: Object {
    @Persisted var balance: Double = 0.0
}
