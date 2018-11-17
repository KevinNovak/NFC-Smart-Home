//
//  DeviceList.swift
//  NFC-Smart-Home
//
//  Created by Joey Cicero on 10/12/17.
//  Copyright © 2017 Garage. All rights reserved.
//

import Foundation
import UIKit

class DeviceController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
    @IBOutlet weak var deviceView: UITableView!
    
	private let requestServices = RequestServices()
	var deviceList: Array<Dictionary<String, String>> = []
    
	override func viewDidLoad() {
		deviceList = requestServices.getDeviceList()
		deviceView.delegate = self
		deviceView.dataSource = self
		self.deviceView.allowsMultipleSelection = true
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return deviceList.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = deviceView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
		cell.name.text = deviceList[indexPath.row]["key"]!
		return cell
	}
}
