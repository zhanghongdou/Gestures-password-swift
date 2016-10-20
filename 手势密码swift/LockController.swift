//
//  LockController.swift
//  手势密码
//
//  Created by 爱利是 on 16/7/15.
//  Copyright © 2016年 爱利是. All rights reserved.
//

import UIKit

class LockController: UIViewController, UIAlertViewDelegate{

    @IBOutlet weak var albel: UILabel!
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.albel.textAlignment = .center
        self.albel.textColor = UIColor.orange
        self.textField.placeholder = "输入账户查找头像用户名"
        self.textField.addTarget(self, action: #selector(LockController.changedInput), for: .allEditingEvents)
    }

    //实时监测改变头像图片
    func changedInput() {
        let zuu = LockViewShowManager.shareManager().getLastUserheaderImageAndNameWithUserAccount(userAccount: textField.text!)
        self.albel.text = zuu.userName
        self.imageView.image = zuu.headerImage
    }
    
    @IBAction func setlockWord(_ sender: UIButton) {
        let passwordLock = UserDefaults.standard.object(forKey: "passwordLock")
        if  passwordLock != nil {
            let alertView = UIAlertView.init(title: "提示", message: "您已经设置了手势密码", delegate: nil, cancelButtonTitle: "确定")
            alertView.show()
        }else{
            let lockView = LockViewController()
            lockView.remindUserToSet = true
            self.present(lockView, animated: true, completion: nil)
        }
    }
    
    @IBAction func vertifyPassword(_ sender: UIButton) {
        
        let passwordLock = UserDefaults.standard.object(forKey: "passwordLock")
        if passwordLock != nil {
            let lockView = LockViewController()
            //下面这个参数是用来说明是验证密码
            lockView.validation = "validation"
            self.present(lockView, animated: true, completion: nil)
        }else{
            let alertView = UIAlertView.init(title: "提示", message: "您尚未设置手势密码", delegate: nil, cancelButtonTitle: "确定")
            alertView.show()
        }
    }
    
    @IBAction func resetPassWord(_ sender: UIButton) {
        let passwordLock = UserDefaults.standard.object(forKey: "passwordLock")
        if passwordLock != nil {
            let lockView = LockViewController()
            //下面这个参数是用来说明是重置密码
            lockView.resetIs = "resetIs"
            self.present(lockView, animated: true, completion: nil)
        }else{
            let alertView = UIAlertView.init(title: "提示", message: "您尚未设置手势密码", delegate: nil, cancelButtonTitle: "确定")
            alertView.show()
        }
    }
    
    @IBAction func ceshi(_ sender: UIButton) {
        //保存
        LockViewShowManager.shareManager().saveLastUserheaderImageAndName(headerImage: nil, userName: "haohao", userAccount: "18937103831")
    }

    @IBAction func get(_ sender: UIButton) {
        let zuu = LockViewShowManager.shareManager().getLastUserheaderImageAndNameWithUserAccount(userAccount: "18937103831")
        self.albel.text = zuu.userName
        self.imageView.image = zuu.headerImage
        
    }
}
