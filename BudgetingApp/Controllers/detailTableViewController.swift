//
//  detailTableViewController.swift
//  BudgetingApp
//
//  Created by Ziad Alfakharany on 14/01/2023.
//

import UIKit
import RealmSwift

class detailTableViewController: UITableViewController {

    var items: Results<Detail>?
    let realm = try! Realm()
    var cost: [Int] = [0]
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    var selectedCategory : Category! {
        didSet {
            loadItems()
        }
    }
    
    let j = MainViewController()
    var myBalance : Balance? {
        didSet {
            j.s = String("$\(self.myBalance!.balance)")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.layer.cornerRadius = 10.0
        navigationBar.topItem!.title = selectedCategory.name
        tableView.rowHeight = 80.0
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath)
        
        cell.textLabel?.numberOfLines = 0;
        
        if let item = items?[indexPath.row] {
            cell.textLabel?.text = "\(item.title) costed you $\(item.cost) at \(item.dateCreated)"
        } else {
            cell.textLabel?.text = "no items added"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @IBAction func addButtobPressed(_ sender: UIBarButtonItem) {
        //1. Create the alert controller.
           let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
           //2. Add the text field. You can configure it however you need.
           alert.addTextField { (title) in
               title.text = ""
               title.placeholder = "Enter the item"
           }
           alert.addTextField(configurationHandler: { (cost) in
               cost.text = ""
               cost.placeholder = "Enter the cost of the item"
           })
           // 3. Grab the value from the text field, and print it when the user clicks OK.
           alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak alert] (_) in
               
               let title = alert?.textFields![0] // Force unwrapping because we know it exists.
               let cost = alert?.textFields![1]
               if title != nil {
               if let currentCategory = self.selectedCategory {
                   do{
                       try self.realm.write({
                       let newItem = Detail()
                           newItem.title = title?.text ?? "nil"
                           newItem.cost = Double((cost?.text)!) ?? 0
                           let mytime = Date()
                           let format = DateFormatter()
                           format.timeStyle = .short
                           format.dateStyle = .short
                           newItem.dateCreated = format.string(from: mytime)
                           currentCategory.details.append(newItem)
                           self.myBalance?.balance -= newItem.cost
                       })
                       } catch {
                           print("error saving new items")
                       }
                   }
               }
               self.tableView.reloadData()
               }
           ))
           self.present(alert, animated: true, completion: nil)
    }
        
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                if let itemToDelete = items?[indexPath.row] {
                    do{
                        try self.realm.write {
                            myBalance?.balance += itemToDelete.cost
                            self.realm.delete(itemToDelete)
                        }
                    } catch {
                        print("error deleting\(error)")
                    }
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    loadItems()
                }
            }
        
        }
    func loadItems() {
        items = selectedCategory?.details.sorted(byKeyPath: "dateCreated", ascending: true )
        tableView.reloadData()
    }

}
