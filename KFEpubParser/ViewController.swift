//
//  ViewController.swift
//  KFEpubParser
//
//  Created by zhuxuhong on 2017/4/21.
//  Copyright © 2017年 zhuxuhong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    fileprivate var epub: EpubContentModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = Bundle.main.url(forResource: "demo2.epub", withExtension: nil)!
        let dest = URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Documents")
        
        EpubKit.open(epub: url, destination: dest)
        { (model, error) in
            print(error ?? "Epub file is opened successfully")
            self.epub = model
        }
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CatalogListVC",
            let vc = segue.destination as? CatalogListVC,
            let epub = epub {
            vc.catalogs = epub.catalog
        }
    }
}

