//
//  ResultViewController.swift
//  PrimaryColorFusion
//
//  Created by 辜鹏 on 2019/10/12.
//  Copyright © 2019 PengGu. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    @IBOutlet weak var tableView_01: UITableView!
    
    @IBOutlet weak var tableView_02: UITableView!
    
    
    
    
    
    var dataSource1:[Int]?
    var dataSource2:[Int]?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        setupUI()
        
        dataSource1 = UserDefaults.standard.array(forKey: "score") as? [Int] ?? []
        dataSource2 = UserDefaults.standard.array(forKey: "score2") as? [Int] ?? [ ]


    }
    
    func setupUI()  {
        
        tableView_01.dataSource = self
        tableView_02.dataSource = self

        tableView_01.delegate = self
        tableView_02.delegate = self
        
        tableView_01.separatorStyle = .none
        tableView_02.separatorStyle = .none

        
        
        
    }
    


}

extension ResultViewController :UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == tableView_01 {
            
            return  dataSource1!.count
        }
        
        if tableView == tableView_02 {
            
            return dataSource2!.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell:UITableViewCell?
        
        
        if tableView == self.tableView_01 {
           
            var  cell1 :CellA = tableView.dequeueReusableCell(withIdentifier: "a", for: indexPath) as! CellA
            cell1.index_1.text = String(indexPath.row + 1 )
            cell1.scoreLb.text = String(dataSource1![indexPath.row])
            
            return cell1
        }
        
        if tableView == self.tableView_02 {
           
            var  cell2 :CellB = tableView.dequeueReusableCell(withIdentifier: "b", for: indexPath) as! CellB
            cell2.index_2.text = String(indexPath.row + 1 )
            cell2.scoreLb2.text = String(dataSource2![indexPath.row])
            return cell2

        }

        
        
        return cell!
        
    }
    
    
    
}
