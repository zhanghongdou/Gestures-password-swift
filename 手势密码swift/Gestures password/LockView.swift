//
//  LockView.swift
//  手势密码
//
//  Created by haohao on 16/7/14.
//  Copyright © 2016年 haohao. All rights reserved.
//
/// 在这里我不想使用懒加载，因为懒加载虽然节省资源，但是效率太低，所以在资源足够的情况下，我有限考虑不使用懒加载

import UIKit

protocol LockVIewDeleagate : class {
    func aboutPasswordNotice(notice: String) -> Void
}
extension LockVIewDeleagate {
    func aboutPasswordNotice(notice: String) -> Void {}
}
class LockView: UIView {
    /**
     *  保存所有的按钮
     */
    var buttons : Array<UIButton> = []
    var selectButtons : Array<UIButton> = []
    var lineColor : UIColor?
    var currentPoint : CGPoint?
    let width : CGFloat = 74
    let height : CGFloat = 74
    let lineCount : CGFloat = 3
    var Aloc = CGPoint()
    var Bloc = CGPoint()
    var markBtn = Int()
    weak var delegate : LockVIewDeleagate?
    
    

    /**
     创建btn9个
     */
    func creatBtnArray() {
//        let btnArray = NSMutableArray()
        if self.buttons.count == 0 {
            for index in 0..<9 {
                let btn = UIButton()
                btn.tag = index
                btn.userInteractionEnabled = false
                btn.setBackgroundImage(UIImage(named: "patternround_normal.png"), forState: .Normal)
                btn.setBackgroundImage(UIImage(named: "patternround_clicked.png"), forState: .Selected)
                btn.setBackgroundImage(UIImage(named: "patternround_error.png"), forState: .Disabled)
                self.addSubview(btn)
                self.buttons.append(btn)
//                btnArray.addObject(btn)
            }
//            self.buttons.addObjectsFromArray(btnArray as [AnyObject])
            
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.lineColor = UIColor.whiteColor()
        let marginX = (self.frame.size.width - self.lineCount * self.width) / (self.lineCount + 1)
        let marginY = (self.frame.size.height - self.lineCount * self.height) / (self.lineCount + 1)
        self.creatBtnArray()
        var index : CGFloat = 0
        
        for index1 in 0..<self.buttons.count {
            let row = Int(index / self.lineCount)
            let col = index % self.lineCount
            let x = marginX + col * (self.width + marginX)
            let y = marginY + CGFloat(row) * (self.height + marginY)
            self.buttons[index1].frame = CGRectMake(x, y, self.width, self.height)
            index += 1
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touchPoint : UITouch = touches.first!
        let loc = touchPoint.locationInView(touchPoint.view)
        for index in 0..<self.buttons.count {
            let btn = self.buttons[index]
            if CGRectContainsPoint(btn.frame, loc) && !btn.selected {
                btn.selected = true
                self.Aloc = btn.frame.origin
                if self.Aloc.x == self.Bloc.x && self.Aloc.y > self.Bloc.y {
                    btn.setBackgroundImage(UIImage(named: "patternround_clicked.png"), forState: .Selected)
                }
                self.markBtn = index
                self.selectButtons.append(btn)
            }
            
        }
        self.Bloc = self.Aloc
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touchPoint : UITouch = touches.first!
        let loc = touchPoint.locationInView(touchPoint.view)
        self.currentPoint = loc
        for index in 0..<self.buttons.count {
            let btn = self.buttons[index]
            if CGRectContainsPoint(btn.frame, loc) && !btn.selected {
                btn.selected = true
                self.Aloc = btn.frame.origin
                if self.Aloc.x == self.Bloc.x && self.Aloc.y > self.Bloc.y {
                    btn.setBackgroundImage(UIImage(named: "patternround_clicked.png"), forState: .Selected)
                    self.buttons[self.markBtn].setBackgroundImage(UIImage(named: "patternround_clicked_down.png"), forState: .Selected)
                }else if self.Aloc.x == self.Bloc.x && self.Aloc.y < self.Bloc.y {
                    btn.setBackgroundImage(UIImage(named: "patternround_clicked.png"), forState: .Selected)
                    self.buttons[self.markBtn].setBackgroundImage(UIImage(named: "patternround_clicked_up.png"), forState: .Selected)
                }else if self.Aloc.y == self.Bloc.y && self.Aloc.x > self.Bloc.x {
                    btn.setBackgroundImage(UIImage(named: "patternround_clicked.png"), forState: .Selected)
                    self.buttons[self.markBtn].setBackgroundImage(UIImage(named: "patternround_clicked_right.png"), forState: .Selected)
                }else if self.Aloc.y == self.Bloc.y && self.Aloc.x < self.Bloc.x {
                    btn.setBackgroundImage(UIImage(named: "patternround_clicked.png"), forState: .Selected)
                    self.buttons[self.markBtn].setBackgroundImage(UIImage(named: "patternround_clicked_left.png"), forState: .Selected)
                }else if self.Aloc.x > self.Bloc.x && self.Aloc.y > self.Bloc.y {
                    btn.setBackgroundImage(UIImage(named: "patternround_clicked.png"), forState: .Selected)
                    self.buttons[self.markBtn].setBackgroundImage(UIImage(named: "patternround_clicked_Dright.png"), forState: .Selected)
                }else if self.Aloc.x < self.Bloc.x && self.Aloc.y < self.Bloc.y {
                    btn.setBackgroundImage(UIImage(named: "patternround_clicked.png"), forState: .Selected)
                    self.buttons[self.markBtn].setBackgroundImage(UIImage(named: "patternround_clicked_Tleft.png"), forState: .Selected)
                }else if self.Aloc.x > self.Bloc.x && self.Aloc.y < self.Bloc.y {
                    btn.setBackgroundImage(UIImage(named: "patternround_clicked.png"), forState: .Selected)
                    self.buttons[self.markBtn].setBackgroundImage(UIImage(named: "patternround_clicked_Tright.png"), forState: .Selected)
                }else if self.Aloc.x < self.Bloc.x && self.Aloc.y > self.Bloc.y {
                    btn.setBackgroundImage(UIImage(named: "patternround_clicked.png"), forState: .Selected)
                    self.buttons[self.markBtn].setBackgroundImage(UIImage(named: "patternround_clicked_Dleft.png"), forState: .Selected)
                }
                self.markBtn = index
                self.selectButtons.append(btn)
            }
        }
        self.Bloc = self.Aloc
        self.setNeedsDisplay()
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        var password = String()
        for btn in self.selectButtons {
            password = password + "\(btn.tag)"
        }

        let passwordOne = NSUserDefaults.standardUserDefaults().objectForKey("passwordOne")
        let passwordLock = NSUserDefaults.standardUserDefaults().objectForKey("passwordLock")
        if let passwordLock1 = passwordLock {
        //如果手势密码直接就是存在的话，进直接把用户的手势和之前设置的密码进行比较，决定用户是否通过验证
            self.comparePassword(password)
        }else{
            if let passwordOne1 = passwordOne {
                //如果第一次设置的手势密码已经存在的话，就直接同第一次设置的手势密码进行比对，同时保存第二次设置的手势密码
                NSUserDefaults.standardUserDefaults().setObject(password, forKey: "passwordTwo")
                NSUserDefaults.standardUserDefaults().synchronize()
                self.comparePassword(password)
            }else{
                //没有第一个密码的时候
                if password.characters.count >= 4 {
                     //保存第一次设置的密码
                    NSUserDefaults.standardUserDefaults().setObject(password, forKey: "passwordOne")
                    NSUserDefaults.standardUserDefaults().synchronize()
                   //然后就是通过代理在视图控制器上面提醒用户再次输入密码
                    if self.delegate != nil {
                        self.delegate?.aboutPasswordNotice("请再次输入新密码")
                    }
                    //同时对本类里面的数据进行清楚
                    self.clear()
                }else if password.characters.count < 4 {
                    //通过代理，在试图控制器提示用户，最少设置四位手势密码
                    if self.delegate != nil {
                        self.delegate?.aboutPasswordNotice("最少设置四位手势密码")
                    }
                    //同时进行清楚本类数据
                    self.clear()
                }
            }
        }
    }
    
    //清楚本类里面的数据
    func clear() {
        for btn in self.selectButtons {
            btn.selected = false
            btn.enabled = true
            btn.setBackgroundImage(UIImage(named: "patternround_clicked.png"), forState: .Selected)
        }
        self.lineColor = UIColor.whiteColor()
        self.selectButtons.removeAll()
        self.setNeedsDisplay()
    }
    //把第一次的密码和第二次的密码进行比对
    func comparePassword(password: String) {
        let passwordOne = NSUserDefaults.standardUserDefaults().objectForKey("passwordOne")
        let passwordTwo = NSUserDefaults.standardUserDefaults().objectForKey("passwordTwo")
        let passwordLock = NSUserDefaults.standardUserDefaults().objectForKey("passwordLock")
        if self.delegate != nil {
            if let passwordLock1 = passwordLock {
                //如果之前已经设置过密码的话
                if password == passwordLock1  as! String{
                    self.delegate?.aboutPasswordNotice("解锁成功")
                    self.clear()
                }else{
                    self.delegate?.aboutPasswordNotice("解锁失败")
                    for btn in self.selectButtons {
                        btn.selected = false
                        btn.enabled = false
                    }
                    //两次密码比对错误的时候，吧线的颜色改为红色进行重新绘图
                    self.lineColor = UIColor.redColor()
                    self.setNeedsDisplay()
                    self.userInteractionEnabled = false
                    DelayObject().delay(0.5, closure: {
                        self.clear()
                        self.userInteractionEnabled = true
                    })
                }
                
            }else{
                //两次密码进行比对
                if passwordTwo?.isEqual(passwordOne) == true {
                    self.delegate?.aboutPasswordNotice("密码设置成功")
                    NSUserDefaults.standardUserDefaults().setObject(password, forKey: "passwordLock")
                    NSUserDefaults.standardUserDefaults().removeObjectForKey("passwordOne")
                    NSUserDefaults.standardUserDefaults().removeObjectForKey("passwordTwo")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    //设置成功之后要对本类里面的数据进行清楚
                    self.clear()
                }else{
                    self.delegate?.aboutPasswordNotice("两次密码设置不一致，请您重新设置密码")
                    NSUserDefaults.standardUserDefaults().removeObjectForKey("passwordOne")
                    NSUserDefaults.standardUserDefaults().removeObjectForKey("passwordTwo")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    for btn in self.selectButtons {
                        btn.selected = false
                        btn.enabled = false
                    }
                    //两次密码比对错误的时候，吧线的颜色改为红色进行重新绘图
                    self.lineColor = UIColor.redColor()
                    self.setNeedsDisplay()
                    self.userInteractionEnabled = false
                    DelayObject().delay(0.5, closure: { 
                        self.clear()
                        self.userInteractionEnabled = true
                    })
                }
            }
        }
        
    }
    
    
    override func drawRect(rect: CGRect) {
        if self.selectButtons.count == 0 {
            return
        }
        let path = UIBezierPath()
        path.lineWidth = 5.0
        for index in 0..<self.selectButtons.count {
            let btn = self.selectButtons[index]
            if index == 0 && self.selectButtons.count != 1 {
                path.moveToPoint(btn.center)
            }else if self.selectButtons.count == 1 {
                return
            }else{
                path.addLineToPoint(btn.center)
            }
        }
        path.addLineToPoint(self.currentPoint!)
        self.lineColor?.set()
        path.stroke()
        
    }
}






















