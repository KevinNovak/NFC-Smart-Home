//
//  RequestServices.swift
//  NFC-Smart-Home
//
//  Created by Garage on 10/12/17.
//  Copyright © 2017 Garage. All rights reserved.
//

import Foundation

class RequestServices {
    
    // Fill in with your Wink API Token:
    let TOKEN = ""
    
    func buildRequest(urlString: String, powered: Bool) -> URLRequest {
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.addValue("Bearer "+(TOKEN), forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var brightness: Decimal = 0
        if (powered == true) {
            brightness = 1
        }
        
        let json: [String: Any] = ["desired_state": ["powered": powered, "brightness": brightness]]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        request.httpMethod = "PUT"
        
        return request;
    }
    
    func buildToggleRequest(deviceId: String) -> URLRequest {
        let url = "https://api.wink.com/light_bulbs/" + deviceId + "/desired_state"
        let request = self.buildRequest(urlString: url, powered: !self.getDeviceState(deviceId: deviceId))
        return request
    }
    
    func executeRequest(request: URLRequest) {
        let session = URLSession.shared;
        let task = session.dataTask(with: request)
        task.resume()
    }
    
    func getDeviceState(deviceId: String) -> Bool {
        let meURL = "https://api.wink.com/users/me/wink_devices"
        let url = URL(string:meURL)!
        var request = URLRequest(url: url)
        request.addValue("Bearer "+(TOKEN), forHTTPHeaderField: "Authorization")

        var isPowered = false;
        
        let semaphore = DispatchSemaphore(value: 0)
        
        var data: Data? = nil
        
        URLSession.shared.dataTask(with: request) { (responseData, _, _) -> Void in
            data = responseData
            semaphore.signal()
            }.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        do {
            if let data = data,
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                let devices = json["data"] as? [[String: Any]] {
                
                for device in devices {
                    
                    if deviceId == device["light_bulb_id"] as? String {
                        if let name = device["name"] as? String {
                            if let desiredState = device["desired_state"] as? NSDictionary {
                                if let powered = desiredState["powered"] as? Bool {
                                    print("Name: \(name)  Powered: \(powered)")
                                    isPowered = powered
                                }
                            }
                        }
                        
                    }
                }
            }
        } catch {
            print("Error deserializing JSON: \(error)")
        }
        
        return isPowered
    }
    
    func buildGetDeviceRequest() -> URLRequest {
        let deviceURL = "https://api.wink.com/users/me/wink_devices"
        let url = URL(string:deviceURL)!
        var request = URLRequest(url: url)
        request.addValue("Bearer "+(TOKEN), forHTTPHeaderField: "Authorization")
        return request
    }
    
    func getDeviceList() -> Array<Dictionary<String, String>> {
        var deviceList = [[String:String]]()
        var deviceItem = [String: String]()
        let request = buildGetDeviceRequest()
        
        let semaphore = DispatchSemaphore(value: 0)
        
        var data: Data? = nil
        
        URLSession.shared.dataTask(with: request) { (responseData, _, _) -> Void in
            data = responseData
            semaphore.signal()
            }.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        do {
            
            if let data = data,
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                let devices = json["data"] as? [[String: Any]] {
                
                for device in devices {
                    
                    if let name = device["name"] as? String {
                        if let modelName = device["model_name"] as? String{
                            deviceItem["key"] = name
                            deviceItem["value"] = modelName
                            deviceList.append(deviceItem);
                        }
                        
                    }
                }
            }
        } catch {
            print("Error deserializing JSON: \(error)")
        }
        
        return deviceList
    }
}
