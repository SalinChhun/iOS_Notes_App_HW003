//
//  ViewController.swift
//  Notes2
//
//  Created by PVH_002 on 13/9/23.
//

import UIKit
import CoreData
class ViewController: UIViewController, Delegate {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let fetchRequest: NSFetchRequest<Notes> = Notes.fetchRequest()
    var numOfNotes = 0
    func getText(title: String, desc: String) {
        if title == "" && desc == "" {
            return
        } else if title != "" || desc != ""{
            createItems(title: title, desc: desc)
        }
    }
    
    var folder = [
        [
            "Quick Notes"
        ],
        [
            "Notes",
        ]
    ]
    
    var numNote = [Notes]()
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.searchTextField.clipsToBounds = true
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchBar.searchTextField.layer.masksToBounds = true
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    @IBAction func goToEditorScreen(_ sender: Any) {
        let nav = storyboard?.instantiateViewController(withIdentifier: "TextViewViewController") as! TextViewViewController
        nav.delegate = self
        navigationController?.pushViewController(nav, animated: true)
    }
    
}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = CGFloat()
        height = 50
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 0) {

        } else {
            let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "NoteViewController") as! NoteViewController
            navigationController?.pushViewController(secondVC, animated: true)
        }
    }
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return ""
        } else {
            return "ICLOUD"
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return folder.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.layer.cornerRadius = 10
        cell.folderName?.text = folder[indexPath.section][indexPath.row]
        if indexPath.section == 0 {
            cell.imageView?.image = UIImage(systemName: "folder")
        } else {
            cell.imageView?.image = UIImage(systemName: "calendar")
            cell.noteNumber.text = "\(numOfNotes)"
        }
        return cell
        
    }
    
    // handle count of notes
    override func viewWillAppear(_ animated: Bool) {
        do {
            let count = try context.count(for: fetchRequest)
            numOfNotes = count
            try self.context.save()
            
        } catch {
            
        }
        tableView.reloadData()
    }

    // handle create direct from first screen
    func createItems(title: String, desc: String) {
        let newItems = Notes(context: context)
        newItems.title = title
        newItems.desc = desc
        do {
            try context.save()
        } catch {
            // error
        }
    }

}

