//
//  MapModel.swift
//  Marbles
//
//  Created by ZCW on 2019/5/10.
//  Copyright © 2019年 KnightSama. All rights reserved.
//

import UIKit

class MapModel: NSObject {
    /// 编码
    var code = ""
    /// 名称
    var name = ""
    /// 创建时间
    var createDate = ""
    /// 高度
    var height:CGFloat = 0.0
    /// 位置状态
    let infoArr = Array.init([[0]])
}

