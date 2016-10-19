//
//  LockViewController.swift
//  手势密码
//
//  Created by haohao on 16/7/14.
//  Copyright © 2016年 haohao. All rights reserved.
//

import UIKit

class LockViewController: UIViewController, LockVIewDeleagate, UIAlertViewDelegate{

    var reset = String()
    var resetIs = String()
    var skipBtn : UIButton?
    var warningLabel : UILabel?
    var countMark = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(patternImage: UIImage(named: "ios_pattern_bg")!)
    //避免有的时候因为程序的意外退出而保存了先前设置的密码
        UserDefaults.standard.removeObject(forKey: "passwordOne")
        UserDefaults.standard.removeObject(forKey: "passwordTwo")
        UserDefaults.standard.synchronize()
        
        let lockView = LockView()
        lockView.backgroundColor = UIColor.clear
        lockView.delegate = self
        lockView.frame = CGRect(x: (kScreenWidth - 590 * kScreenWidth / 750) / 2, y: 480 * kScreenHeight / 1350, width: 590 * kScreenWidth / 750, height: 590 * kScreenWidth / 750)
        self.view.addSubview(lockView)

        self.logoSet()
        self.showUserName()
        self.showUserName()
        self.skipBtnSet()
        self.warningPromptLabel()
    }
    
    //MARK:设置logo或者用户的头像
    func logoSet() {
        let logoImageView = UIImageView(image: UIImage(named: "logo"))
        logoImageView.frame = CGRect(x: 280 * kScreenWidth / 750, y: 140 * kScreenHeight / 1350, width: 200 * kScreenWidth / 750, height: 185 * kScreenHeight / 1350)
        self.view.addSubview(logoImageView)
    }
    
    //MARK:用户名
    func showUserName() {
        let nameLabel = UILabel.init(frame: CGRect(x: 230 * kScreenWidth / 750, y: 280 * kScreenHeight / 1350, width: 280 * kScreenWidth / 750, height: 55 * kScreenHeight / 1350))
        nameLabel.textColor = UIColor.init(colorLiteralRed: 25/255.0, green: 173/255.0, blue: 255/255.0, alpha: 1.0)
        nameLabel.text = "haohao"
        nameLabel.textAlignment = .center
        self.view.addSubview(nameLabel)
    }
    
    //MARK:设置跳过的按钮
    func skipBtnSet() {
        self.skipBtn = UIButton(type: .system)
        self.skipBtn?.setTitle("跳过", for: UIControlState())
        self.skipBtn?.setTitleColor(UIColor.white, for: UIControlState())
        self.skipBtn?.frame = CGRect(x: kScreenWidth * 2 / 3, y: 1150 * kScreenHeight / 1350, width: kScreenWidth * 1 / 3, height: 120)
        self.skipBtn?.titleLabel?.textAlignment = .center
        self.skipBtn?.addTarget(self, action: #selector(LockViewController.skipBtnJump(_:)), for: .touchUpInside)
        self.view.addSubview(self.skipBtn!)
        
    }
    //跳过按钮
    func skipBtnJump(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    //MARK: 警告提示栏
    func warningPromptLabel() {
        self.warningLabel = UILabel.init(frame: CGRect(x: (kScreenWidth - 570 * kScreenWidth / 750) / 2, y: 340 * kScreenHeight / 1350, width: 570 * kScreenWidth / 750, height: 120 * kScreenHeight / 1350))
        self.warningLabel?.textColor = UIColor.init(colorLiteralRed: 25/255.0, green: 173/255.0, blue: 255/255.0, alpha: 1.0)
        self.warningLabel?.adjustsFontSizeToFitWidth = true
        self.warningLabel?.numberOfLines = 0
        self.warningLabel?.textAlignment = .center
        self.view.addSubview(self.warningLabel!)
    }
    
    //MARK: LockViewDelegate的协议方法
    func aboutPasswordNotice(_ notice: String) {
        self.warningLabel?.text = notice
        self.warningLabel?.textColor = UIColor.init(colorLiteralRed: 25 / 255.0, green: 173 / 255.0, blue: 255 / 255.0, alpha: 1.0)
        if notice == "密码设置成功" {//第一次设置成功
            self.dismiss(animated: true, completion: nil)
        }else if notice == "解锁成功" {//解锁成功又分为两种
            //一： 重新设置密码验证成功
            if self.resetIs == "resetIs" {
                self.warningLabel?.text = "验证成功"
                UserDefaults.standard.removeObject(forKey: "passwordLock")
                UserDefaults.standard.synchronize()
            }else{
                //二：验证成功，允许登陆
                //调用登陆接口进行登陆，刷新单利数据
                self.dismiss(animated: true, completion: nil)
            }
            
        }else if notice == "两次密码设置不一致，请您重新设置密码"  || notice == "解锁失败"{
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.1)
            UIView.setAnimationRepeatCount(5)
            UIView.animate(withDuration: 0.01, animations: { 
                self.warningLabel?.frame = CGRect(x: (kScreenWidth - 575 * kScreenWidth / 750) / 2, y: 335 * kScreenHeight / 1350, width: 570 * kScreenWidth / 750, height: 120 * kScreenHeight / 1350)
                }, completion: { (finished) in
                    self.warningLabel?.frame = CGRect(x: (kScreenWidth - 570 * kScreenWidth / 750) / 2, y: 340 * kScreenHeight / 1350, width: 570 * kScreenWidth / 750, height: 120 * kScreenHeight / 1350)
                    UIView.commitAnimations()//结束动画
            })
            self.warningLabel?.textColor = UIColor.red
            if notice == "解锁失败" {
                self.countMark += 1
                if self.countMark == 1 {
                    self.warningLabel?.text = "您的解锁密码输入有误"
                }else if self.countMark == 5 {
                    self.warningLabel?.text = "您的解锁密码输入错误，累计已到\(self.countMark)次"
                    UIView.commitAnimations()
                    let alertView = UIAlertView.init(title: "温馨提示", message: "手势密码已失效，请您重新登陆", delegate: self, cancelButtonTitle: nil)
                    alertView.show()
                    
                DelayObject().delay(1.5, closure: { 
                    self.alertViewDissmissWithDelay(alertView)
                })
                }else{
                    self.warningLabel?.text = "您的解锁密码输入错误，累计已到\(self.countMark)次"
                }
            }
        }
    }
    
    //MARK: UIAlertView消失
    func alertViewDissmissWithDelay(_ alertView : UIAlertView){
        UserDefaults.standard.removeObject(forKey: "passwordLock")
        UserDefaults.standard.synchronize()
        alertView.dismiss(withClickedButtonIndex: 0, animated: true)
        self.dismiss(animated: false, completion: nil)//在这里不设置动画，然后从首页push到登陆页面
        //进行重新登陆跳转
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}






















