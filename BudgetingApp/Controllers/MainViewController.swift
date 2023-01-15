//
//  ViewController.swift
//  BudgetingApp
//
//  Created by Ziad Alfakharany on 08/01/2023.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController {

    @IBOutlet weak var balanceTxt: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var s: String = ""
    
    var categories: Results<Category>?
    let realm = try! Realm()
    var newBalance = Balance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.layer.cornerRadius = 10.0
        tableView.rowHeight = 80.0
        loadPage()
    }

    
    @IBAction func addCategoryButtonPressed(_ sender: Any) {
        var alertTxtField = UITextField()
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
           
            if alertTxtField.text != "" {
            let newCategory = Category()
            newCategory.name = alertTxtField.text!
            self.saveCategories(category: newCategory)
            } else {
                return
            }
        }
        
        alert.addTextField() { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            alertTxtField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func refreshButtonPressed(_ sender: UIButton) {
        if s == "" {
        balanceTxt.text = String("$\(newBalance.balance)")
        } else {
            balanceTxt.text = s
        }
    }
    
    @IBAction func editBalancePressed(_ sender: UIButton) {
        var alertTxtField = UITextField()
        let alert = UIAlertController(title: "Edit Your Balance", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Edit Balance", style: .default) { (action) in
           
            if alertTxtField.text != "" {
                self.newBalance.balance = Double(alertTxtField.text!) ?? self.newBalance.balance
            self.saveBalance(newbalance: self.newBalance)
            } else {
                return
            }
        }
        
        alert.addTextField() { (alertTextField) in
            alertTextField.placeholder = "enter your new balance"
            alertTxtField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}




    extension MainViewController: UITableViewDelegate, UITableViewDataSource {
        
        
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "no categories added yet"
        
        return cell
    }
    
    func loadPage() {
        categories = realm.objects(Category.self)
        guard let lastBalance = realm.objects(Balance.self).last else {return}
        
        balanceTxt.text = String("$\(lastBalance.balance)")
        newBalance.balance = lastBalance.balance
        tableView.reloadData()
    }
    
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                if let categoryToDelete = categories?[indexPath.row] {
                    do{
                        try self.realm.write {
                            self.realm.delete(categoryToDelete)
                        }
                    } catch {
                        print("error deleting\(error)")
                    }
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    
                    loadPage()
                }
            }
        }
    
        func saveBalance(newbalance: Balance) {
            do {
                try realm.write({
                    realm.add(newbalance)
                })
            } catch {
                print("error saving balance \(error)")
            }
            balanceTxt.text = String("$\(newbalance.balance)")
        }
        
        
    func saveCategories(category: Category) {
        do {
            try realm.write({
                realm.add(category)
            })
        } catch {
            print("error saving categories \(error)")
        }
        tableView.reloadData()
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
         tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! detailTableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
            destinationVC.myBalance = newBalance
        }
    }


}
