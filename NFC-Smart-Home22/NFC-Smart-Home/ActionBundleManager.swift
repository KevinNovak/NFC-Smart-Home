//
//  ActionBundleManager.swift
//  NFC-Smart-Home
//
//  Created by Garage on 10/12/17.
//  Copyright © 2017 Garage. All rights reserved.
//

import Foundation

class ActionBundleManager {
    public var _actionBundles: Array<ActionBundle> = Array<ActionBundle>()
    
    init() {
        // toggle light
        let action_1 = Action(deviceId: "3032585", isToggle: true)
    
        // toggle plug
        let action_2 = Action(deviceId: "3035644", isToggle: true)
        
        // turn light on
        let action_3 = Action(deviceId: "3032585", powered: true)
        
        // turn light off
        let action_4 = Action(deviceId: "3032585", powered: false)
        
        // turn plug on
        let action_5 = Action(deviceId: "3035644", powered: true)
        
        // turn plug off
        let action_6 = Action(deviceId: "3035644", powered: false)
        
        let action_bundle_1 = ActionBundle(actionBundleId: 1, actions: [action_1])
        let action_bundle_2 = ActionBundle(actionBundleId: 2, actions: [action_2])
        let action_bundle_3 = ActionBundle(actionBundleId: 3, actions: [action_3, action_5])
        let action_bundle_4 = ActionBundle(actionBundleId: 4, actions: [action_4, action_6])
        
        _actionBundles = [action_bundle_1, action_bundle_2, action_bundle_3, action_bundle_4]
    }
    
    func callActionBundleWithId(id: Int) {
        for actionBundle in _actionBundles {
            if (actionBundle._actionBundleId == id) {
                actionBundle.executeActions()
            }
        }
    }
}

