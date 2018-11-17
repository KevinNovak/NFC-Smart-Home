//
//  ViewController.swift
//  TagReader
//
//  Created by Jameson Quave on 6/16/17.
//  Copyright © 2017 Jameson Quave. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
  
    let clientId = "KS3jX70d_p2nbU9odXNR3GSyBw8KlNwG"
    let clientSecret = "VpYyQnw_JpUNIIxacFz5COfUhfvnnRFN"
    let authURL = "https://api.wink.com/oauth2/authorize"
    let accessTokenURL = "https://api.wink.com/oauth2/token"
    let token = "fQaRyKFD_XQHGDPsgOnGPjzGd6Le5aJK"
    let lightIdToLightName = NSMutableDictionary()
    var nfcIdToLightId: [String: String] = ["1": "3035644", "2": "3032585"]
    var deviceCollection = [deviceStruct]()
    
    struct deviceStruct {
        var id = ""
        var name = ""
        var isPowered = false
    }
    
    
    
    @IBOutlet weak var winkLogin: UIWebView!
    let helper = NFCHelper()
  var payloadLabel: UILabel!
   
    override func viewDidLoad() {
    super.viewDidLoad()
    
    let button = UIButton(type: .system)
    button.setTitle("Read NFC", for: .normal)
    button.titleLabel?.font = UIFont(name: "Helvetica", size: 28.0)
    button.addTarget(self, action: #selector(didTapReadNFC), for: .touchUpInside)
    button.frame = CGRect(x: 60, y: 200, width: self.view.bounds.width - 120, height: 80)
    self.view.addSubview(button)
    
    payloadLabel = UILabel(frame: button.frame.offsetBy(dx: 0, dy: 300))
    payloadLabel.numberOfLines = 10
    payloadLabel.text = "Scan an NFC Tag"
    self.view.addSubview(payloadLabel)
  }
    
    override func viewDidAppear(_ animated: Bool) {
        let meURL = "https://api.wink.com/users/me/wink_devices"
        let url = URL(string:meURL)!
        var request = URLRequest(url: url)
        request.addValue("Bearer "+(self.token), forHTTPHeaderField: "Authorization")
        let session = URLSession.shared;
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            var deviceData = [String]()
            print(response)
            do {
                var counter = 0
                
                if let data = data,
                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                    let devices = json["data"] as? [[String: Any]] {
                    
                    for device in devices {
                        if let lightBulbId = device["light_bulb_id"] as? String {
                            if let name = device["name"] as? String {
                                if let desiredState = device["desired_state"] as? NSDictionary {
                                    
                                    self.deviceCollection.append(deviceStruct(id:lightBulbId, name: name, isPowered: (desiredState.value(forKey: "powered") as? Bool)!))
                                    
                                    counter += 1
                                }
                            }
                            
                        }
                    }
                }
            } catch {
                print("Error deserializing JSON: \(error)")
            }
            
            
            
            
        }
        task.resume()
    }
    
    func messageContainsId(message: String) -> Bool {
        return message.lowercased().contains("id:")
    }
    
    func onNFCResult(success: Bool, msg: String) {
        DispatchQueue.main.async {
            if (self.messageContainsId(message: msg)) {
                self.payloadLabel.text = "\(self.payloadLabel.text!)\n\(msg)"
                self.turnOnLight(name: "Plug", id: "3035644")
            }
        }
    }
  
  @objc func didTapReadNFC() {
    print("didTapReadNFC")
    
    
    self.payloadLabel.text = ""
    
    helper.onNFCResult = onNFCResult(success:msg:)
    helper.restartSession()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

    
    func turnOnLight(name:String,id:String) -> Void {
        print("toggle called")
        let turnOnLightURL = "https://api.wink.com/light_bulbs/"+id+"/desired_state"
        let url = URL(string:turnOnLightURL)!
        var request = URLRequest(url: url)
        request.addValue("Bearer "+(self.token), forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        
        
        
        var json: [String: Any] = ["desired_state": ["powered": true]]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
       
        request.httpBody = jsonData
        
        request.httpMethod = "PUT"
        
        let session = URLSession.shared;
        
        let task = session.dataTask(with: request)
        task.resume()
    }
    


}

/*print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
 winkLogin.loadRequest(URLRequest(url: url))
 if let request = winkLogin.request{
 if let resp = URLCache.shared.cachedResponse(for: request){
 if let response = resp.response as? HTTPURLResponse {
 print(response.allHeaderFields)
 }
 }
 print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
 }*/

