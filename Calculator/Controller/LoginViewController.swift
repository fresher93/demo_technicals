//
//  LoginViewControler.swift
//  Calculator
//
//  Created by Bui Cong Dai on 6/16/20.
//  Copyright © 2020 HoangHai. All rights reserved.
//

import Foundation

class LoginViewController:NSObject {
    
    private var apiClient: APIClient
    var userData:[NSDictionary]?
    public init(client:APIClient) {
           self.apiClient = client
    }
    
    func fechLogin(completion: () -> ()){
      let url = "http://127.0.0.1:8000/rest/api/authen/requester/login"
      let httpPost = "POST"
      let urlData = ["username":"requester1","password":"requester1"]
        apiClient.fetchPost(url: url, method: httpPost, urlData as Data, completion: <#T##([String : String]?) -> Void#>)
     }
    
}

