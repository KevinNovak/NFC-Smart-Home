//
//  ViewController.swift
//  NFC-Smart-Home
//
//  Created by Garage on 10/12/17.
//  Copyright © 2017 Garage. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    
    
    @IBOutlet weak var actionCompletedLabel: UILabel!
    @IBOutlet weak var scanButton: UIImageView!
    @IBOutlet weak var scanButtonTitle: UILabel!
    
    let helper = NFCHelper()
    let actionBundleManager = ActionBundleManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func messageContainsId(message: String) -> Bool {
        return message.lowercased().contains("id:")
    }
    
    func getIdFromMessage(message: String) -> Int {
        let index = message.index(message.startIndex, offsetBy: 6)
        let id = Int(message[index...])
        return id ?? -1
    }
    
    func callActionWithId(id: Int) {
        actionBundleManager.callActionBundleWithId(id: id)
    }
    
    func showActionCompletedLabel(show: Bool) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear, animations: {
            if (show) {
                self.actionCompletedLabel.alpha = 1.0
            } else {
                self.actionCompletedLabel.alpha = 0.0
            }
        })
    }
    
    @objc func setReadyForRead(ready: Bool) {
        if (ready) {
            self.showActionCompletedLabel(show: false)
            scanButton.image = #imageLiteral(resourceName: "nfc_button.png")
            scanButtonTitle.textColor = UIColor.black
        } else {
            self.showActionCompletedLabel(show: true)
            scanButton.image = #imageLiteral(resourceName: "nfc_button_gray.png")
            scanButtonTitle.textColor = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1.0)
        }
    }
    
    func onNFCResult(success: Bool, msg: String) {
        DispatchQueue.main.async {
            if (self.messageContainsId(message: msg)) {
                let id = self.getIdFromMessage(message: msg)
                
                // Call smart device
                self.callActionWithId(id: id)
                
                // Set not ready to read
                self.setReadyForRead(ready: false)
                
                // After 5 seconds, set ready to read
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                    self.setReadyForRead(ready: true)
                })
            }
        }
    }
    
    @objc func didTapReadNFC() {
        if (self.actionCompletedLabel.alpha == 0) {
            helper.onNFCResult = onNFCResult(success:msg:)
            helper.restartSession()
        }
    }
    
    @IBAction func startImageClicked(_ sender: Any) {
        didTapReadNFC()
    }
}
