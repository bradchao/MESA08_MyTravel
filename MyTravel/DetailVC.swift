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
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImage: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Detail:\(app.nowId)")    // id, not tid
        
        let mydata = getData(id: app.nowId)
        print("return:\(mydata.name) : \(mydata.photo)")
        
    }
    
    private func getData(id:String) -> (name:String, photo:String) {
        if let _ = app.db {
            let sql = "select id,name,photo from travel where id = ?"
            var stmt:OpaquePointer? = nil
            if sqlite3_prepare(app.db, sql, -1, &stmt, nil) != SQLITE_OK {
                // 出錯
                print("error1: id :\(app.nowId)")
                return ("error1","error1")
            }
            let cid = id.cString(using: .utf8);
            if sqlite3_bind_text(stmt, 1, cid, -1, nil) != SQLITE_OK {
                // 出錯
                print("error2: id :\(app.nowId)")
                return ("error2","error2")
            }
            
            if sqlite3_step(stmt) == SQLITE_ROW {
                // 有資料回來
                let cname = sqlite3_column_text(stmt, 1)
                let cphoto = sqlite3_column_text(stmt, 2)
                let name = String(cString: cname!)
                let photo = String(cString: cphoto!)
                return (name, photo)
            }else{
                // 無資料
                let cerrmsg = sqlite3_errmsg(app.db)
                let errmsg = String(cString: cerrmsg!, encoding: String.Encoding.utf8 )
                print(errmsg)
                return ("error3","error3")
            }
        }
        return ("","")
    }
    
    

}
