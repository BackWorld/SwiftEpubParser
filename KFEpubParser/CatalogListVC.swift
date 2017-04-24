//
//  CatalogListVC.swift
//  KFEpubParser
//
//  Created by zhuxuhong on 2017/4/24.
//  Copyright © 2017年 zhuxuhong. All rights reserved.
//

import UIKit

class CatalogListVC: UITableViewController {

    public var catalogs: [EpubCatalogItem]?{
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "Header")
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return catalogs?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let catalog = catalogs?[section]
        return catalog?.subs.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Header")
        if let catalog = catalogs?[section]{
            view?.textLabel?.text = catalog.text
        }
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if let catalog = catalogs?[indexPath.section]{
            let item = catalog.subs[indexPath.row]
            
            cell.textLabel?.text = item.text
            cell.detailTextLabel?.text = "\(item.depth)"
        }
        
        return cell
    }

}
