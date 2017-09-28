//
//  AppDelegate.swift
//  MyTravel
//
//  Created by user22 on 2017/9/28.
//  Copyright © 2017年 Brad Big Company. All rights reserved.
//

import UIKit
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var db:OpaquePointer? = nil

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let fmgr = FileManager.default
        let srcDB = Bundle.main.path(forResource: "iii", ofType: "db")
        let tagDB = NSHomeDirectory() + "/Documents/iii.db"
        if !fmgr.fileExists(atPath: tagDB) {
            try? fmgr.copyItem(atPath: srcDB!, toPath: tagDB)
            //sqlite3_open(tagDB, &db)
            // 匯入遠端資料
            importRemoteData()
        }else{
            //sqlite3_open(tagDB, &db)
            importRemoteData()
        }
        
        return true
    }

    private func importRemoteData(){
        Alamofire.request("http://data.coa.gov.tw/Service/OpenData/ODwsv/ODwsvAttractions.aspx").responseJSON { response in
            if let data = response.data {
                let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                for row in json as! [[String:String]] {
                    print("\(row["Name"] ?? "xx") : \(row["Coordinate"] ?? "xx") : \(row["Photo"] ?? "xx")")
                }
                
            }
        }
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

