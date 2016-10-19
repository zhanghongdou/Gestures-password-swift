//
//  DelayObject.swift
//  手势密码
//
//  Created by haohao on 16/7/11.
//  Copyright © 2016年 haohao. All rights reserved.
//

import UIKit

class DelayObject: NSObject {
    //MARK: 延迟执行的方法
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }


}


