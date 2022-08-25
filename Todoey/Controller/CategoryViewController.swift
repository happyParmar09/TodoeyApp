//
//  CategoryViewController.swift
//  Todoey
//
//  Created by gokulparmar on 23/08/22.
//

import UIKit
import RealmSwift
import SwiftUI
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categoryArray : Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        
        tableView.rowHeight = 80.0
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let nevBar = navigationController?.navigationBar else {
            fatalError("Navigation controller does not exist ")
        }
        nevBar.backgroundColor = UIColor(hexString: "1D9BF6")
    }
    
    //MARK: - tableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categoryArray?[indexPath.row] {
            
            cell.textLabel?.text = category.name
            
            guard let categoryColor = UIColor(hexString: category.color) else {fatalError()}
            
            cell.backgroundColor = categoryColor
            
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true )
        }
        
        return cell
        
    }
    
    //MARK: - tableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    
    //MARK: - Add New items in category array
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default){ (action) in
            
            
            let newCat = Category()
            newCat.name = textField.text!
            newCat.color = UIColor.randomFlat().hexValue()
            
            self.saveCategories(category: newCat)
            
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            alertTextField.placeholder = "Create new item"
        }
        
        present(alert,animated: true , completion: nil)
        
    }
    
    
    //MARK: - tableView Manipulation Methods
    func saveCategories(category : Category){
        
        do{
            try realm.write{
                realm.add(category)
            }
        }catch{
            print("Error saving Categories, \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategories(){
        
        categoryArray = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    // to delete category
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categoryArray?[indexPath.row] {
                        do{
                            try self.realm.write{
                                self.realm.delete(categoryForDeletion)
                            }
                        }catch{
                            print("Error deleting category , \(error)")
                        }
        
                        //tableView.reloadData()
            }
    }
}
