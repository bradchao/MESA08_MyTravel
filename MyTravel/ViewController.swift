//
//  ViewController.swift
//  MyTravel
//
//  Created by user22 on 2017/9/28.
//  Copyright © 2017年 Brad Big Company. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    private var mydata:[Int:String] = [:]
    
    let app = UIApplication.shared.delegate as! AppDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = app.db {
            let sql = "select count(*) from travel"
            var stmt:OpaquePointer? = nil
            sqlite3_prepare(app.db, sql, -1, &stmt, nil)
            sqlite3_step(stmt)
            let num = Int(sqlite3_column_int(stmt, 0))
            return num
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let row = getData(i: indexPath.row)
        cell.textLabel?.text = row.id + ":" + row.name
        mydata[indexPath.row] = row.id
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        app.nowId = mydata[indexPath.row]!
    }
    
    
    private func getData(i: Int) -> (id:String, name:String) {
        if let _ = app.db {
            let sql = "select id,name from travel where id = ?"
            var stmt:OpaquePointer? = nil
            
            sqlite3_prepare(app.db, sql, -1, &stmt, nil)
            sqlite3_bind_int(stmt, 1, Int32(i + 1))
            sqlite3_step(stmt)
            let tempId = String(cString: sqlite3_column_text(stmt, 0))
            let tempName = String(cString: sqlite3_column_text(stmt, 1))
            
            return (tempId, tempName)
        }else{
            return ("---", "----")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        queryAll()
    }
    
    private func queryAll(){
        if let _ = app.db {
            let keyword = "美食"
            let search = "%\(keyword)%"
            let csearch = search.cString(using: .utf8)
            
            let sql = "select * from travel where intro like ?"
            var stmt:OpaquePointer? = nil
            
            if sqlite3_prepare(app.db, sql, -1, &stmt, nil) != SQLITE_OK {
                // 出錯
                print("error1: id :\(app.nowId)")
            }
            
            
            sqlite3_bind_text(stmt, 1, csearch, -1, nil)
            
            while sqlite3_step(stmt) == SQLITE_ROW {
                // 有資料回來
                let cid = sqlite3_column_text(stmt, 0)
                let cname = sqlite3_column_text(stmt, 1)
                let cphoto = sqlite3_column_text(stmt, 2)
                let ccity = sqlite3_column_text(stmt, 6)

                let id = String(cString: cid!)
                let name = String(cString: cname!)
                let photo = String(cString: cphoto!)
                let city = String(cString: ccity!)

                print("\(id):\(name):\(photo):\(city)")
                
            }
        }

    }
    
}

