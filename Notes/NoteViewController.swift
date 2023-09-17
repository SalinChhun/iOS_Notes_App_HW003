//
//  NoteViewController.swift
//  Notes2
//
//  Created by PVH_002 on 13/9/23.
//

import UIKit
protocol Delegate {
    func getText(title: String, desc: String)
}
class NoteViewController: UIViewController, Delegate {
    var itemUpdate: Notes?
    var combineText = ""
    var updateTitle = ""
    var updateDesc = ""
    var models = [Notes]()
    var didUpdate = false
    func getText(title: String, desc: String) {
        updateTitle = title
        updateDesc = desc
        if title == "" && desc == "" {
            return
        } else if (title != "" || desc != "") && didUpdate == false {
            createItems(title: title, desc: desc)
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noteNum: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.searchTextField.clipsToBounds = true
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchBar.searchTextField.layer.masksToBounds = true
        tableView.delegate = self
        tableView.dataSource = self
        getAllItems()
    }
    @IBAction func navigation(_ sender: Any) {
        let nav = storyboard?.instantiateViewController(withIdentifier: "TextViewViewController") as! TextViewViewController
        nav.delegate = self
        navigationController?.pushViewController(nav, animated: true)
    }
    @IBAction func btnBackFolder(_ sender: Any) {
        UserDefaults.standard.set(models.count, forKey: "noteNum")
        navigationController?.popViewController(animated: true)
    }
    @IBAction func folderBackBtn(_ sender: Any) {
        UserDefaults.standard.set(models.count, forKey: "noteNum")
        navigationController?.popViewController(animated: true)
    }
    

}

extension NoteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = CGFloat()
        height = 55
        return height
    }
}

extension NoteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NoteViewCell
        
        let model = models[indexPath.row]
        cell.titleLabel.text = model.title
        cell.descLabel.text = model.desc
        
        // Check if the cell is the top cell
        if indexPath.row == 0 {
            cell.layer.cornerRadius = 10
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        
        // Check if the cell is the last cell
        if indexPath.row == models.count - 1 {
            cell.layer.cornerRadius = 10
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.width, bottom: 0, right: 0)
        } else {
            cell.separatorInset = UIEdgeInsets.zero
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = models[indexPath.row]
        itemUpdate = item
        didUpdate = true
        let nav = storyboard?.instantiateViewController(withIdentifier: "TextViewViewController") as! TextViewViewController
        combineText = "\(item.title!) \n \(item.desc!)"
        nav.textView = combineText
        nav.delegate = self
        navigationController?.pushViewController(nav, animated: true)
    }

    // swip cell to delete
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, handler) in
            guard let self = self else { return }
            let noteToRemove = self.models[indexPath.row]
            self.deleteItems(item: noteToRemove)
            self.models.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            if (self.models.count) > 1 {
                self.noteNum.title = "\(self.models.count) Notes"
            } else {
                self.noteNum.title = "\(self.models.count) Note"
            }
        }
        // perform delete action
        deleteAction.image = UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    // handle crud
    func getAllItems() {
        do {
            models = try context.fetch(Notes.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            // error
        }
    }
    
    func createItems(title: String, desc: String) {
        let newItems = Notes(context: context)
        newItems.title = title
        newItems.desc = desc
        do {
            try context.save()
            getAllItems()
        } catch {
            // error
        }
    }
    
    func deleteItems(item: Notes) {
        context.delete(item)
        do {
            try context.save()
        } catch {
            // error
        }
    }
    
    func updateNote() {
        itemUpdate!.title = updateTitle
        itemUpdate!.desc = updateDesc
        do {
        try context.save()
            getAllItems()
        } catch {
            // error
        }
    }
    
    // perform action when screen will appear
    override func viewWillAppear(_ animated: Bool) {
        // perform update action
        if didUpdate == true {
            updateNote()
            didUpdate = false
        }
        if models.count > 1 {
            noteNum.title = "\(models.count) Notes"
        } else {
            noteNum.title = "\(models.count) Note"
        }
        

    }
    
    
}
