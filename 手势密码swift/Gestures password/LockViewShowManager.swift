//
//  LockViewShowManage.swift
//  手势密码swift
//
//  Created by haohao on 16/10/19.
//  Copyright © 2016年 haohao. All rights reserved.
//

import UIKit

class LockViewShowManager: NSObject {

    //用于记录app失去焦点的起始时间
    var startDate : Date?
    
    static let showManager = LockViewShowManager()
    class func shareManager() -> LockViewShowManager {
        return showManager
    }
    
    override init() {
        super.init()
    }
    
    //比较app失去焦点到重新获得焦点的时间间隔
    func whetherOrNotShowLockView(getActiveDate : Date?) -> Bool {
        let interval = getActiveDate?.timeIntervalSince(startDate!)
        //默认设置为五分钟
        if interval! > 5 * 60 {
            return true
        }else{
            return false
        }
    }
    
    //获取上一次的用户账号
    func getCurrentUserAccount() -> String {
        let lastUserAccount = UserDefaults.standard.object(forKey: "LastUserAccount")
        return lastUserAccount as! String
    }
    
    //保存登陆用户的头像，用户名,用户的账号
    func saveLastUserheaderImageAndName(headerImage : UIImage?, userName : String?, userAccount : String) {
        if headerImage != nil{
            let dataImage : NSData!
            if UIImagePNGRepresentation(headerImage!) == nil {
                dataImage = UIImageJPEGRepresentation(headerImage!, 1) as NSData!
            }else{
                dataImage = UIImagePNGRepresentation(headerImage!) as NSData!
            }
            UserDefaults.standard.set(dataImage, forKey: "\(userAccount)+userHeaderImage")
        }
        if userName != nil {
            UserDefaults.standard.set(userName!, forKey: "\(userAccount)+userName")
        }
        //同时保存用户的账号
        UserDefaults.standard.set(userAccount, forKey: "LastUserAccount")
        UserDefaults.standard.synchronize()
    }
    //获取上一次登陆用户的头像，用户名
    func getLastUserheaderImageAndName() -> (headerImage : UIImage, userName : String?){
        let lastUserAccount = self.getCurrentUserAccount
        
        let lastUserImage = UserDefaults.standard.object(forKey: "\(lastUserAccount)+userHeaderImage")
        let lastUserName = UserDefaults.standard.object(forKey: "\(lastUserAccount)+userName")
        if [lastUserImage == nil, lastUserName == nil].contains(true) == true {
            if lastUserImage == nil && lastUserName != nil {
                return (headerImage : UIImage.init(named: "defaultHeaderImage")!, userName : lastUserName as? String)
            }else{
                return (headerImage : (lastUserImage as! UIImage?)!, userName : nil)
            }
        }
        return (headerImage : (lastUserImage as! UIImage?)!, userName : lastUserName as! String?)
    }
    //根据用户输入的用户账号获取本地的头像，用户名，如果没有的话，显示默认头像，用户名
    func getLastUserheaderImageAndNameWithUserAccount(userAccount : String) -> (headerImage : UIImage, userName : String?){
        let lastUserImage = UserDefaults.standard.object(forKey: "\(userAccount)+userHeaderImage")
        let lastUserName = UserDefaults.standard.object(forKey: "\(userAccount)+userName")
        if [lastUserImage == nil, lastUserName == nil].contains(true) == true {
            if lastUserImage == nil && lastUserName != nil {
                return (headerImage : UIImage.init(named: "defaultHeaderImage")!, userName : lastUserName as? String)
            }else if lastUserImage != nil && lastUserName == nil{
                return (headerImage : (lastUserImage as! UIImage?)!, userName : nil)
            }else{
                return (headerImage : UIImage.init(named: "defaultHeaderImage")!, userName : nil)
            }
        }
        return (headerImage : UIImage.init(data: lastUserImage as! Data)!, userName : lastUserName as! String?)
    }
}
