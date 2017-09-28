//
//  DetailVC.swift
//  MyTravel
//
//  Created by user22 on 2017/9/28.
//  Copyright © 2017年 Brad Big Company. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    let app = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Detail:\(app.nowId)")
    }

}
