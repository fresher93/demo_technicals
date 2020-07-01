//
//  LoginViewModel.swift
//  Calculator
//
//  Created by Bui Cong Dai on 6/17/20.
//  Copyright © 2020 HoangHai. All rights reserved.
//

import Foundation
import UIKit

struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
}
var apiData = ""

class LoginViewModel:NSObject{
    var loginClient = LoginClient()
    var code: Int = 0
    var requesters : [NSDictionary]?
    func fetchLogin(_ username : String, _ password : String)-> String? {
        apiData = loginClient.postJson(username, password) ?? ""
        print("apiData", apiData)
        return apiData
    }
    
    func getRequesters(_ completion: ()->()) {
        loginClient.getJson{requesters in self.requesters = requesters}
    }
    
    func numberOfItemsInSection(section: Int) -> Int {
        return requesters?.count ?? 0
    }
    
    func titleForItemAtIndexPath(indexPath:NSIndexPath) -> String {
        return requesters?[indexPath.row].value(forKeyPath: "im:name:label") as? String ?? ""
    }
}
