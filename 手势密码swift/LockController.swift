//
//  LockController.swift
//  手势密码
//
//  Created by 爱利是 on 16/7/15.
//  Copyright © 2016年 爱利是. All rights reserved.
//

import UIKit

class LockController: UIViewController, UIAlertViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func setlockWord(sender: UIButton) {
        let passwordLock = NSUserDefaults.standardUserDefaults().objectForKey("passwordLock")
        if let pass = passwordLock {
            let alertView = UIAlertView.init(title: "提示", message: "您已经设置了手势密码", delegate: nil, cancelButtonTitle: "确定")
            alertView.show()
        }else{
            let lockView = LockViewController()
            self.presentViewController(lockView, animated: true, completion: nil)
        }
        
        
    }
    
    
    @IBAction func vertifyPassword(sender: UIButton) {
        
        let passwordLock = NSUserDefaults.standardUserDefaults().objectForKey("passwordLock")
        if let pass = passwordLock {
            let lockView = LockViewController()
            //下面这个参数是用来说明是重置密码还是验证密码
//            lockView.resetIs = "resetIs"
            lockView.reset = "请输入原密码"
            self.presentViewController(lockView, animated: true, completion: nil)
        }else{
            
            let alertView = UIAlertView.init(title: "提示", message: "您尚未设置手势密码", delegate: nil, cancelButtonTitle: "确定")
            alertView.show()
        }
    }
    
    
}
