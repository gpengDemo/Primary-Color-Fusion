//
//  GameOverViewController.swift
//  PrimaryColorFusion
//
//  Created by 辜鹏 on 2019/10/12.
//  Copyright © 2019 PengGu. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController {
    
    var passedScore:String?
    
    @IBOutlet weak var topscoreLb: UILabel!
    @IBOutlet weak var scoreLb: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreLb.text = passedScore
        self.title = "Primary color fusion"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem?.tintColor = .black


    }
    

    @IBAction func againAction(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "refreshback")))
        

    }
    
    @IBAction func homeAction(_ sender: Any) {
        
        navigationController?.popToRootViewController(animated: true)

    }
}
