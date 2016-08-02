//
//  LockViewController.swift
//  手势密码
//
//  Created by haohao on 16/7/14.
//  Copyright © 2016年 haohao. All rights reserved.
//

import UIKit
 let aaa : CGFloat = 5
class LockViewController: UIViewController, LockVIewDeleagate, UIAlertViewDelegate{


    var reset = String()
    var resetIs = String()
    var skipBtn : UIButton?
    var warningLabel : UILabel?
    var countMark = Int()
    let fff = UIScreen.mainScreen().bounds.size.width - aaa * 22
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(patternImage: UIImage(named: "ios_pattern_bg")!)
    //避免有的时候因为程序的意外退出而保存了先前设置的密码
        NSUserDefaults.standardUserDefaults().removeObjectForKey("passwordOne")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("passwordTwo")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        let lockView = LockView()
        lockView.backgroundColor = UIColor.clearColor()
        lockView.delegate = self
        lockView.frame = CGRectMake((kScreenWidth - 590 * kScreenWidth / 750) / 2, 480 * kScreenHeight / 1350, 590 * kScreenWidth / 750, 590 * kScreenWidth / 750)
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
        logoImageView.frame = CGRectMake(280 * kScreenWidth / 750, 140 * kScreenHeight / 1350, 200 * kScreenWidth / 750, 185 * kScreenHeight / 1350)
        self.view.addSubview(logoImageView)
    }
    
    //MARK:用户名
    func showUserName() {
        let nameLabel = UILabel.init(frame: CGRectMake(230 * kScreenWidth / 750, 280 * kScreenHeight / 1350, 280 * kScreenWidth / 750, 55 * kScreenHeight / 1350))
        nameLabel.textColor = UIColor.init(colorLiteralRed: 25/255.0, green: 173/255.0, blue: 255/255.0, alpha: 1.0)
        nameLabel.text = "haohao"
        nameLabel.textAlignment = .Center
        self.view.addSubview(nameLabel)
    }
    
    //MARK:设置跳过的按钮
    func skipBtnSet() {
        self.skipBtn = UIButton(type: .System)
        self.skipBtn?.setTitle("跳过", forState: .Normal)
        self.skipBtn?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.skipBtn?.frame = CGRectMake(kScreenWidth * 2 / 3, 1150 * kScreenHeight / 1350, kScreenWidth * 1 / 3, 120)
        self.skipBtn?.titleLabel?.textAlignment = .Center
        self.skipBtn?.addTarget(self, action: #selector(LockViewController.skipBtnJump(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(self.skipBtn!)
        
    }
    //跳过按钮
    func skipBtnJump(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    //MARK: 警告提示栏
    func warningPromptLabel() {
        self.warningLabel = UILabel.init(frame: CGRectMake((kScreenWidth - 570 * kScreenWidth / 750) / 2, 340 * kScreenHeight / 1350, 570 * kScreenWidth / 750, 120 * kScreenHeight / 1350))
        self.warningLabel?.textColor = UIColor.init(colorLiteralRed: 25/255.0, green: 173/255.0, blue: 255/255.0, alpha: 1.0)
        self.warningLabel?.adjustsFontSizeToFitWidth = true
        self.warningLabel?.numberOfLines = 0
        self.warningLabel?.textAlignment = .Center
        self.view.addSubview(self.warningLabel!)
    }
    
    //MARK: LockViewDelegate的协议方法
    func aboutPasswordNotice(notice: String) {
        self.warningLabel?.text = notice
        self.warningLabel?.textColor = UIColor.init(colorLiteralRed: 25 / 255.0, green: 173 / 255.0, blue: 255 / 255.0, alpha: 1.0)
        if notice == "密码设置成功" {//第一次设置成功
            self.dismissViewControllerAnimated(true, completion: nil)
        }else if notice == "解锁成功" {//解锁成功又分为两种
            //一： 重新设置密码验证成功
            if self.resetIs == "resetIs" {
                self.warningLabel?.text = "验证成功"
                NSUserDefaults.standardUserDefaults().removeObjectForKey("passwordLock")
                NSUserDefaults.standardUserDefaults().synchronize()
            }else{
                //二：验证成功，允许登陆
                //调用登陆接口进行登陆，刷新单利数据
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
        }else if notice == "两次密码设置不一致，请您重新设置密码"  || notice == "解锁失败"{
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.1)
            UIView.setAnimationRepeatCount(5)
            UIView.animateWithDuration(0.01, animations: { 
                self.warningLabel?.frame = CGRectMake((kScreenWidth - 575 * kScreenWidth / 750) / 2, 335 * kScreenHeight / 1350, 570 * kScreenWidth / 750, 120 * kScreenHeight / 1350)
                }, completion: { (finished) in
                    self.warningLabel?.frame = CGRectMake((kScreenWidth - 570 * kScreenWidth / 750) / 2, 340 * kScreenHeight / 1350, 570 * kScreenWidth / 750, 120 * kScreenHeight / 1350)
                    UIView.commitAnimations()//结束动画
            })
            self.warningLabel?.textColor = UIColor.redColor()
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
    func alertViewDissmissWithDelay(alertView : UIAlertView){
        NSUserDefaults.standardUserDefaults().removeObjectForKey("passwordLock")
        NSUserDefaults.standardUserDefaults().synchronize()
        alertView.dismissWithClickedButtonIndex(0, animated: true)
        self.dismissViewControllerAnimated(false, completion: nil)//在这里不设置动画，然后从首页push到登陆页面
        //进行重新登陆跳转
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}






















