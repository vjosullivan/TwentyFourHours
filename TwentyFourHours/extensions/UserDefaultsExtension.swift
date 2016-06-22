//
//  UserDefaults.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 03/03/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    class func write(key: String, value: String) {
        let userDefaults = UserDefaults.standard()
        userDefaults.setValue(value, forKey: "vos.forecast." + key)
        userDefaults.synchronize()
    }

    class func writeInt(key: String, value: Int) {
        let userDefaults = UserDefaults.standard()
        userDefaults.setValue(value, forKey: "vos.forecast." + key)
        userDefaults.synchronize()
    }

    class func read(key: String, defaultValue: String) -> String {
        let userDefaults = UserDefaults.standard()
        return userDefaults.value(forKey: "vos.forecast." + key) as? String ?? defaultValue
    }

    class func readInt(key: String, defaultValue: Int) -> Int {
        let userDefaults = UserDefaults.standard()
        return userDefaults.value(forKey: "vos.forecast." + key) as? Int ?? defaultValue
    }
}
