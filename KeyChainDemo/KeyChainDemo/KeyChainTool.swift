//
//  KeyChainTool.swift
//  uchain
//
//  Created by Fxxx on 2017/12/6.
//  Copyright © 2017年 Fxxx. All rights reserved.
//

import UIKit

class KeyChainTool: NSObject {
    
    
    static let shared = KeyChainTool()
    
    private func keyChainQueryDictionaryWithKey(key: String) -> NSMutableDictionary {
        
        let dic = NSMutableDictionary()
        dic.setObject(kSecClassGenericPassword, forKey: kSecClass as! NSCopying)
        dic.setObject(kSecAttrAccessibleAfterFirstUnlock, forKey: kSecAttrAccessible as! NSCopying)
        dic.setObject(key, forKey: kSecAttrService as! NSCopying)
        dic.setObject(key, forKey: kSecAttrAccount as! NSCopying)
        return dic
        
    }
    
    func addToKeyChain(data: Any, key: String) -> Bool {
        
        let dic = self.keyChainQueryDictionaryWithKey(key: key)
        SecItemDelete(dic)
        dic.setObject(NSKeyedArchiver.archivedData(withRootObject: data), forKey: kSecValueData as! NSCopying)
        let status = SecItemAdd(dic, nil)
        if status == noErr {
            return true
        }
        return false
        
    }
    
    func updateData(data: Any, key: String) -> Bool {
        
        let oldDic = self.keyChainQueryDictionaryWithKey(key: key)
        guard SecItemCopyMatching(oldDic, nil) == noErr else {
            return false
        }
        let updateDic = NSMutableDictionary()
        updateDic.setObject(NSKeyedArchiver.archivedData(withRootObject: data), forKey: kSecValueData as! NSCopying)
        let status = SecItemUpdate(oldDic, updateDic)
        if status == errSecSuccess {
            return true
        }
        return false
        
    }
    
    func getDataForKey(key: String) -> Any? {
        
        var result: Any?
        let dic = self.keyChainQueryDictionaryWithKey(key: key)
        dic.setObject(kCFBooleanTrue, forKey: kSecReturnData as! NSCopying)
        dic.setObject(kSecMatchLimitOne, forKey: kSecMatchLimit as! NSCopying)
        var queryResult: CFTypeRef?
        if SecItemCopyMatching(dic, &queryResult) == noErr {
            
            if queryResult != nil {
                result = NSKeyedUnarchiver.unarchiveObject(with: queryResult! as! Data)
            }
            
        }
        return result
        
    }
    
    func removeDataForKey(key: String) -> Bool {
        
        let dic = self.keyChainQueryDictionaryWithKey(key: key)
        let status = SecItemDelete(dic)
        if status == noErr {
            return true
        }
        return false
        
    }
    
}

