//
//  TableViewController.swift
//  Notes
//
//  Created by MN on 12.11.2022.
//
// Main controller

import UIKit
import CoreData



class TableViewController: UITableViewController {
    var notes: [Note] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchNotes()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Notes"
        setBarButtons()
    }
    
    func setBarButtons() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAddTapped))
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    @objc func onAddTapped() {
        let alertController = UIAlertController(title: "Create a note", message: "Enter", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { [weak self] action in
            
            let title = alertController.textFields?.first?.text
            let newNote = CoreDataManager.create(title: title, content: nil)
            self?.notes.append(newNote)
            self?.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        alertController.addAction(action)
        alertController.addAction(cancelAction)
        alertController.addTextField()
        
        self.present(alertController, animated: true)
    }
    
    func fetchNotes() {
        notes = CoreDataManager.getNotes()
    }
}
extension TableViewController {
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, complitionHandler) in
            guard let self = self else { return }
            // Which note to remove
            let noteToRemove = self.notes[indexPath.row]
            // Remove note
            CoreDataManager.delete(note: noteToRemove)
            self.notes.removeAll { $0 == noteToRemove }
            self.tableView.reloadData()
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let task = notes[indexPath.row]
        cell.textLabel?.text = task.title
        // Configure the cell...
        
        return cell
    }
    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            
            
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        notes.swapAt(fromIndexPath.row, to.row)
        CoreDataManager.resave(notes: notes)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let secondViewController = storyboard.instantiateViewController(withIdentifier: "notes") as? ViewController else { return }
        
        let note = self.notes[indexPath.row]
        secondViewController.note = note
        
        navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    
    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
}
