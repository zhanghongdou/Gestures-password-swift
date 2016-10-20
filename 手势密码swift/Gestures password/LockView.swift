//
//  LockView.swift
//  手势密码
//
//  Created by haohao on 16/7/14.
//  Copyright © 2016年 haohao. All rights reserved.
//
/// 在这里我不想使用懒加载，因为懒加载虽然节省资源，但是效率太低，所以在资源足够的情况下，我有限考虑不使用懒加载

import UIKit
//闭包传递数组
typealias SendGestureBtnArray = (_ btnArray : Array<UIButton>) -> Void
//闭包在设置手势结束之后告诉小窗口清楚
typealias SmallWindowShouldClear = () -> Void
protocol LockVIewDeleagate : class {
    func aboutPasswordNotice(_ notice: String) -> Void
}
extension LockVIewDeleagate {
    func aboutPasswordNotice(_ notice: String) -> Void {}
}
class LockView: UIView {
    /**
     *  保存所有的按钮
     */
    var buttons : Array<UIButton> = []
    var selectButtons : Array<UIButton> = []
    var lineColor : UIColor?
    var currentPoint : CGPoint?
    
    let lineCount : CGFloat = 3
    var Aloc = CGPoint()
    var Bloc = CGPoint()
    var markBtn = Int()
    weak var delegate : LockVIewDeleagate?
    //设置一个变量用来区分是小窗口还是大窗口
    var isSamllWindow = Bool()
    var sendGestureBtnArray : SendGestureBtnArray?
    var smallWindowShouldClear : SmallWindowShouldClear?
    

    /**
     创建btn9个
     */
    func creatBtnArray() {
        if self.buttons.count == 0 {
            for index in 0..<9 {
                let btn = UIButton()
                btn.tag = index
                btn.isUserInteractionEnabled = false
                btn.setBackgroundImage(UIImage(named: "patternround_normal.png"), for: UIControlState())
                btn.setBackgroundImage(UIImage(named: "patternround_clicked.png"), for: .selected)
                btn.setBackgroundImage(UIImage(named: "patternround_error.png"), for: .disabled)
                self.addSubview(btn)
                self.buttons.append(btn)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var width : CGFloat = 0
        var height : CGFloat = 0
        if self.isSamllWindow == false {
            width = 74
            height = 74
        }else{
            width = 20
            height = 20
        }
        self.lineColor = UIColor.white
        let marginX = (self.frame.size.width - self.lineCount * width) / (self.lineCount + 1)
        let marginY = (self.frame.size.height - self.lineCount * height) / (self.lineCount + 1)
        self.creatBtnArray()
        var index : CGFloat = 0
        
        for index1 in 0..<self.buttons.count {
            let row = Int(index / self.lineCount)
            let col = index.truncatingRemainder(dividingBy: self.lineCount)
            let x = marginX + col * (width + marginX)
            let y = marginY + CGFloat(row) * (height + marginY)
            self.buttons[index1].frame = CGRect(x: x, y: y, width: width, height:height)
            index += 1
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint : UITouch = touches.first!
        let loc = touchPoint.location(in: touchPoint.view)
        for index in 0..<self.buttons.count {
            let btn = self.buttons[index]
            if btn.frame.contains(loc) && !btn.isSelected {
                btn.isSelected = true
                self.Aloc = btn.frame.origin
                if self.Aloc.x == self.Bloc.x && self.Aloc.y > self.Bloc.y {
                    btn.setBackgroundImage(UIImage(named: "patternround_clicked.png"), for: .selected)
                }
                self.markBtn = index
                self.selectButtons.append(btn)
            }
        }
        self.Bloc = self.Aloc
        if self.sendGestureBtnArray != nil{
            self.sendGestureBtnArray!(self.selectButtons)
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint : UITouch = touches.first!
        let loc = touchPoint.location(in: touchPoint.view)
        self.currentPoint = loc
        for index in 0..<self.buttons.count {
            let btn = self.buttons[index]
            if btn.frame.contains(loc) && !btn.isSelected {
                btn.isSelected = true
                self.Aloc = btn.frame.origin
                if self.Aloc.x == self.Bloc.x && self.Aloc.y > self.Bloc.y {
                    btn.setBackgroundImage(UIImage(named: "patternround_clicked.png"), for: .selected)
                    self.buttons[self.markBtn].setBackgroundImage(UIImage(named: "patternround_clicked_down.png"), for: .selected)
                }else if self.Aloc.x == self.Bloc.x && self.Aloc.y < self.Bloc.y {
                    btn.setBackgroundImage(UIImage(named: "patternround_clicked.png"), for: .selected)
                    self.buttons[self.markBtn].setBackgroundImage(UIImage(named: "patternround_clicked_up.png"), for: .selected)
                }else if self.Aloc.y == self.Bloc.y && self.Aloc.x > self.Bloc.x {
                    btn.setBackgroundImage(UIImage(named: "patternround_clicked.png"), for: .selected)
                    self.buttons[self.markBtn].setBackgroundImage(UIImage(named: "patternround_clicked_right.png"), for: .selected)
                }else if self.Aloc.y == self.Bloc.y && self.Aloc.x < self.Bloc.x {
                    btn.setBackgroundImage(UIImage(named: "patternround_clicked.png"), for: .selected)
                    self.buttons[self.markBtn].setBackgroundImage(UIImage(named: "patternround_clicked_left.png"), for: .selected)
                }else if self.Aloc.x > self.Bloc.x && self.Aloc.y > self.Bloc.y {
                    btn.setBackgroundImage(UIImage(named: "patternround_clicked.png"), for: .selected)
                    self.buttons[self.markBtn].setBackgroundImage(UIImage(named: "patternround_clicked_Dright.png"), for: .selected)
                }else if self.Aloc.x < self.Bloc.x && self.Aloc.y < self.Bloc.y {
                    btn.setBackgroundImage(UIImage(named: "patternround_clicked.png"), for: .selected)
                    self.buttons[self.markBtn].setBackgroundImage(UIImage(named: "patternround_clicked_Tleft.png"), for: .selected)
                }else if self.Aloc.x > self.Bloc.x && self.Aloc.y < self.Bloc.y {
                    btn.setBackgroundImage(UIImage(named: "patternround_clicked.png"), for: .selected)
                    self.buttons[self.markBtn].setBackgroundImage(UIImage(named: "patternround_clicked_Tright.png"), for: .selected)
                }else if self.Aloc.x < self.Bloc.x && self.Aloc.y > self.Bloc.y {
                    btn.setBackgroundImage(UIImage(named: "patternround_clicked.png"), for: .selected)
                    self.buttons[self.markBtn].setBackgroundImage(UIImage(named: "patternround_clicked_Dleft.png"), for: .selected)
                }
                self.markBtn = index
                self.selectButtons.append(btn)
            }
        }
        if self.sendGestureBtnArray != nil{
            self.sendGestureBtnArray!(self.selectButtons)
        }
        self.Bloc = self.Aloc
        self.setNeedsDisplay()
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.smallWindowShouldClear != nil {
            self.smallWindowShouldClear!()
        }
        var password = String()
        for btn in self.selectButtons {
            password = password + "\(btn.tag)"
        }
        let passwordOne = UserDefaults.standard.object(forKey: "passwordOne")
        let passwordLock = UserDefaults.standard.object(forKey: "passwordLock")
        if passwordLock != nil {
        //如果手势密码直接就是存在的话，进直接把用户的手势和之前设置的密码进行比较，决定用户是否通过验证
            self.comparePassword(password)
        }else{
            if passwordOne != nil {
                //如果第一次设置的手势密码已经存在的话，就直接同第一次设置的手势密码进行比对，同时保存第二次设置的手势密码
                UserDefaults.standard.set(password, forKey: "passwordTwo")
                UserDefaults.standard.synchronize()
                self.comparePassword(password)
            }else{
                //没有第一个密码的时候
                if password.characters.count >= 4 {
                     //保存第一次设置的密码
                    UserDefaults.standard.set(password, forKey: "passwordOne")
                    UserDefaults.standard.synchronize()
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
            btn.isSelected = false
            btn.isEnabled = true
            btn.setBackgroundImage(UIImage(named: "patternround_clicked.png"), for: .selected)
        }
        self.lineColor = UIColor.white
        self.selectButtons.removeAll()
        self.setNeedsDisplay()
    }
    //把第一次的密码和第二次的密码进行比对
    func comparePassword(_ password: String) {
        let passwordOne = UserDefaults.standard.object(forKey: "passwordOne")
        let passwordTwo = UserDefaults.standard.object(forKey: "passwordTwo")
        let passwordLock = UserDefaults.standard.object(forKey: "passwordLock")
        if self.delegate != nil {
            if let passwordLock1 = passwordLock {
                //如果之前已经设置过密码的话
                if password == passwordLock1 as! String{
                    self.delegate?.aboutPasswordNotice("解锁成功")
                    self.clear()
                }else{
                    self.delegate?.aboutPasswordNotice("解锁失败")
                    for btn in self.selectButtons {
                        btn.isSelected = false
                        btn.isEnabled = false
                    }
                    //两次密码比对错误的时候，吧线的颜色改为红色进行重新绘图
                    self.lineColor = UIColor.red
                    self.setNeedsDisplay()
                    self.isUserInteractionEnabled = false
                    DelayObject().delay(0.5, closure: {
                        self.clear()
                        self.isUserInteractionEnabled = true
                    })
                }
                
            }else{
                //两次密码进行比对
                if (passwordTwo as! String).isEqual(passwordOne) == true {
                    self.delegate?.aboutPasswordNotice("密码设置成功")
                    UserDefaults.standard.set(password, forKey: "passwordLock")
                    UserDefaults.standard.removeObject(forKey: "passwordOne")
                    UserDefaults.standard.removeObject(forKey: "passwordTwo")
                    UserDefaults.standard.synchronize()
                    //设置成功之后要对本类里面的数据进行清楚
                    self.clear()
                }else{
                    self.delegate?.aboutPasswordNotice("两次密码设置不一致，请您重新设置密码")
                    UserDefaults.standard.removeObject(forKey: "passwordOne")
                    UserDefaults.standard.removeObject(forKey: "passwordTwo")
                    UserDefaults.standard.synchronize()
                    for btn in self.selectButtons {
                        btn.isSelected = false
                        btn.isEnabled = false
                    }
                    //两次密码比对错误的时候，吧线的颜色改为红色进行重新绘图
                    self.lineColor = UIColor.red
                    self.setNeedsDisplay()
                    self.isUserInteractionEnabled = false
                    DelayObject().delay(0.5, closure: { 
                        self.clear()
                        self.isUserInteractionEnabled = true
                    })
                }
            }
        }
        
    }
    
    
    override func draw(_ rect: CGRect) {
        if self.selectButtons.count == 0 {
            return
        }
        let path = UIBezierPath()
        
        //画线的时候，如果是小窗口的话，通过tag值找到对应的btn画线
        if self.isSamllWindow == true {
            path.lineWidth = 2.0
            for index in 0..<self.selectButtons.count {
                let btn = self.buttons[self.selectButtons[index].tag]
                if index == 0 && self.selectButtons.count != 1 {
                    path.move(to: btn.center)
                }else if self.selectButtons.count == 1 {
                    return
                }else{
                    path.addLine(to: btn.center)
                }
            }
        }else{
            path.lineWidth = 5.0
            for index in 0..<self.selectButtons.count {
                let btn = self.selectButtons[index]
                if index == 0 && self.selectButtons.count != 1 {
                    path.move(to: btn.center)
                }else if self.selectButtons.count == 1 {
                    return
                }else{
                    path.addLine(to: btn.center)
                }
            }
        }
        
        if self.isSamllWindow == false {
            path.addLine(to: self.currentPoint!)
        }
        self.lineColor?.set()
        path.stroke()
        
    }
}






















