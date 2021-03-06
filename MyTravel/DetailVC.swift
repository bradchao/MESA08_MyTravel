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
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var introText: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImage: UIImageView!
    
    private let q1 = DispatchQueue(label: "q1", qos: DispatchQoS.background, attributes: DispatchQueue.Attributes.concurrent)
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("Detail:\(app.nowId)")    // id, not tid
        
        let mydata = getData(id: app.nowId)
//        print("return:\(mydata.name) : \(mydata.photo)")
        
        app.nowLat = mydata.lat
        app.nowLng = mydata.lng
        
        nameLabel.text = mydata.name
        
        
        indicator.isHidden = false
        indicator.startAnimating()
        q1.async {
            if let url = URL(string: mydata.photo) {
                if let imgData = try? Data(contentsOf: url) {
                    let img = UIImage(data: imgData)
                    DispatchQueue.main.async {
                        self.photoImage.image = img
                        self.indicator.isHidden = true
                    }
                    
                }else{
                    print("errro: network failue")
                    DispatchQueue.main.async {
                        self.indicator.isHidden = true
                    }
                    
                }
            }else {
                print("photo:\(mydata.photo)")
                DispatchQueue.main.async {
                    self.indicator.isHidden = true
                }
            }
        }
        
        introText.text = mydata.intro
        
    }
    
    private func getData(id:String) -> (name:String, photo:String, intro:String, lat:Double, lng:Double) {
        if let _ = app.db {
            let sql = "select id,name,photo,intro,lat,lng from travel where id = ?"
            var stmt:OpaquePointer? = nil
            
            if sqlite3_prepare(app.db, sql, -1, &stmt, nil) != SQLITE_OK {
                // 出錯
                print("error1: id :\(app.nowId)")
                return ("error1","error1","",0,0)
            }
            
            let cid = id.cString(using: .utf8);
            if sqlite3_bind_text(stmt, 1, cid, -1, nil) != SQLITE_OK {
                // 出錯
                print("error2: id :\(app.nowId)")
                return ("error2","error2","",0,0)
            }
            
            if sqlite3_step(stmt) == SQLITE_ROW {
                // 有資料回來
                let cname = sqlite3_column_text(stmt, 1)
                let cphoto = sqlite3_column_text(stmt, 2)
                let cintro = sqlite3_column_text(stmt, 3)
                let clat = sqlite3_column_double(stmt, 4)
                let clng = sqlite3_column_double(stmt, 5)
                
                let name = String(cString: cname!)
                let photo = String(cString: cphoto!)
                let intro = String(cString: cintro!)
                
                return (name, photo, intro, clat, clng)
            }else{
                // 無資料
                let cerrmsg = sqlite3_errmsg(app.db)
                let errmsg = String(cString: cerrmsg!, encoding: String.Encoding.utf8 )
                print(errmsg)
                return ("error3","error3","",0,0)
            }
        }
        return ("","","",0,0)
    }
    
    

}
