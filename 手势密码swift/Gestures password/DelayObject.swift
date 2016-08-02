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
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }


}


