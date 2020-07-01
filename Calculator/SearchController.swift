//
//  SearchController.swift
//  Calculator
//
//  Created by HoangHai on 6/15/20.
//  Copyright © 2020 HoangHai. All rights reserved.
//

import UIKit
import UserNotifications


class MyCell: UITableViewCell {
    @IBOutlet weak var device: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var name: UILabel!
}

class SearchController: UIViewController {
    var apiController = LoginClient()
    internal var data: Array<[String:Any]> = []
    @IBOutlet weak var tableSearchVIew: UITableView!
    @IBOutlet weak var searchType: UIButton!
    @IBOutlet weak var searchNameOrDevice: UITextField!
    @IBOutlet weak var searchDate: UIButton!
    @IBOutlet weak var searchDevice: UIButton!
    @IBOutlet weak var searchName: UIButton!
    var type_search = 0
//    let names = ["Hieu", "Hai", "Duy"]
//    let data1 = [["name": "resquest_name_1",
//                  "status": "new",
//                  "detail":"detai_1"
//        ],
//             ["name": "resquest_name_2",
//                  "status": "new2",
//                  "detail":"detai_2"
//        ]]
 
    @IBAction func btn_click (_ sender: UIButton) {
        let type_search_text = sender.titleLabel!.text!
        
        if type_search_text == "Date" {
            type_search = 1
        } else if type_search_text == "Device" {
            type_search = 2
            searchNameOrDevice.placeholder = "search device"
        } else if type_search_text == "Name" {
            type_search = 3
            searchNameOrDevice.placeholder = "search name"
        }
    }

    @IBAction func btn_search_click(_ sender: UIButton) {
        apiController.getJson("1", String(type_search), searchNameOrDevice.text!) {
            (json) in
            self.data = (json?["list_request"] as? Array<[String : Any]>)!
        }
        DispatchQueue.main.async {
            self.tableSearchVIew.reloadData()
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.tableSearchVIew.reloadData()
        }
        searchNameOrDevice.becomeFirstResponder()
        
        // 1. ask for permisson
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
        
        }
         // 2. create the notification content
        
        let content = UNMutableNotificationContent()
        content.title = "notification title"
        content.body = "notification body"
        
        // 3. create notification trigger
        let date  = Date().addingTimeInterval(5)
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // 4. create the request
        
        let uuidString = UUID().uuidString
        
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        // 5 register the request
        center.add(request){ (error) in
            // check error and handle error
        }
    }
    
}

extension SearchController: UITableViewDataSource, UITableViewDelegate {
    
//    func downloadJson() {
//        apiController.getJson("3", "2","device1"){
//            (json) in
//            self.data = json?["list_request"] as! Array
//        }
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected me \(indexPath)")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.data.count
        return self.data.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as? MyCell else { return UITableViewCell() }
        
//        cell.textLabel?.text = names[indexPath.row]
//        cell.name.text = data1[indexPath.row]["name"]
       
        cell.device.text = self.data[indexPath.row]["detail"] as? String
        cell.name.text = self.data[indexPath.row]["name"] as? String
        cell.status.text = self.data[indexPath.row]["status"] as? String
        
        return cell
    }
    

}
