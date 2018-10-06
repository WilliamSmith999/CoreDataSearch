//
//  DocumentListViewController.swift
//  Documents
//
//  Created by Dale Musser on 6/7/18.
//  Copyright © 2018 Dale Musser. All rights reserved.
//

import UIKit

class DocumentListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {

    
    @IBOutlet weak var documentsTableView: UITableView!
    
    var documents = [Document]()
    var filteredDoc = [Document]()
    let dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Documents"

        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        
        documentsTableView.delegate = self
        documentsTableView.dataSource = self
        
        configureSearchController()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    
    func configureSearchController() {
        // Initialize and perform a minimum configuration to the search controller.

        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search here..."
        searchController.searchBar.delegate = self as? UISearchBarDelegate
        searchController.searchBar.sizeToFit()
        definesPresentationContext = true
        documentsTableView.tableHeaderView = searchController.searchBar
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredDoc = documents.filter({( doc : Document) -> Bool in
            return doc.name.lowercased().contains(searchText.lowercased())
        })
        
        documentsTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        documents = Documents.get()
        documentsTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredDoc.count
        }
        
        return documents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "documentCell", for: indexPath)
        
        
        if isFiltering(){
            if let cell = cell as? DocumentTableViewCell {
                let document = filteredDoc[indexPath.row]
                cell.nameLabel.text = document.name
                cell.sizeLabel.text = String(document.size) + " bytes"
                cell.modificationDateLabel.text = dateFormatter.string(from: document.modificationDate)
                
            }
        }else{
        
            if let cell = cell as? DocumentTableViewCell {
                let document = documents[indexPath.row]
                cell.nameLabel.text = document.name
                cell.sizeLabel.text = String(document.size) + " bytes"
                cell.modificationDateLabel.text = dateFormatter.string(from: document.modificationDate)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let document = self.documents[indexPath.row]
            Documents.delete(url: document.url)
            self.documents = Documents.get()
            self.documentsTableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        return [delete]
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectedDocument" {
            if let destination = segue.destination as? DocumentViewController,
                let row = documentsTableView.indexPathForSelectedRow?.row {
                destination.document = documents[row]
            }
        }
    }

}
