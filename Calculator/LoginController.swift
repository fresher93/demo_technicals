//
//  LoginController.swift
//  Calculator
//
//  Created by Bui Cong Dai on 6/18/20.
//  Copyright © 2020 HoangHai. All rights reserved.
//

import UIKit

class LoginController: UIViewController {



    @IBOutlet weak var username: UITextField!
    var loginClient = LoginClient()
    var loginString = ""
    @IBOutlet weak var pasword: UITextField!
    var requesters:[NSDictionary] = []
    @IBOutlet weak var login: UIButton!
    @IBAction func login(_ sender: UIButton) {
        if(sender.tag == 1) {
            loginClient.postJson(String(username.text!), String(pasword.text!)){
                (jsonDic) in
                let code = jsonDic!["code"] as! Int
                print("code response login \(code)")
                if code == 0 {
                    let storeBroad: UIStoryboard = UIStoryboard(name:"Main",bundle:nil)
                    let vc = storeBroad.instantiateViewController(withIdentifier: "SearchViewController")
                    self.present(vc, animated: true)
                    
                }
                else if code == 1 {
                    let alert = UIAlertController(title:"ERROR", message: "tai khoan khong ton tai", preferredStyle: .alert)
                    let alertActionCancel = UIAlertAction(title:"Cancel", style: .cancel){
                        (act) in
                    }
                    alert.addAction(alertActionCancel)
                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    let alert = UIAlertController(title:"ERROR", message: "sai password ", preferredStyle: .alert)
                    let alertActionCancel = UIAlertAction(title:"Cancel", style: .cancel){
                        (act) in
                    }
                    alert.addAction(alertActionCancel)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
    }
    
    @IBAction func Register(_ sender: Any) {
        let storeBroad: UIStoryboard = UIStoryboard(name:"Main",bundle:nil)
        let vc = storeBroad.instantiateViewController(withIdentifier: "RegistController")
        self.present(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
   

}
