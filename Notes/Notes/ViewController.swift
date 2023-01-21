//
//  ViewController.swift
//  Notes
//
//  Created by MN on 12.11.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    var note: Note!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBut()
        setupUI()
    }
    
    func setupUI() {
        title = note.title
        textView.text = note.content
    }
    
    func setNavBut() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButton))
    }
    
    @objc func saveButton() {
        note.title = title
        note.content = textView.text
        CoreDataManager.saveContext()
        navigationController?.popViewController(animated: true)
    }   
}
