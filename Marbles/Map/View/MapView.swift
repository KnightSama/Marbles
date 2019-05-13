//
//  MapView.swift
//  Marbles
//
//  Created by ZCW on 2019/5/10.
//  Copyright © 2019年 KnightSama. All rights reserved.
//

import UIKit

protocol MapViewDelegate {
    /// 所有砖块都消除了游戏结束
    func mapViewAllBlockDissmiss()
}

class MapView: UIView {
    /// 代理
    var delegate : MapViewDelegate?
    /// 当前显示的数据源
    var model : MapModel = MapModel() {
        willSet {
            self.statusArray = newValue.infoArr
        }
        didSet {
            self.prepareLayout()
        }
    }
    /// 当前的状态数组
    var statusArray = Array.init([[0]])
    /// 当前单个block的大小
    var blockSize = CGSize.zero
    /// 普通砖块的数量
    var normalBlockNum = 0
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    /// 重新布局
    func prepareLayout() {
        // 计算单个block的大小
        let width = self.frame.width / CGFloat(self.statusArray.first!.count)
        let height = self.model.height > 0 ? self.model.height : width
        self.blockSize = CGSize(width: width, height: height)
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        // 初始化砖块数量
        self.normalBlockNum = 0;
        // 绘制图形
        for (row , rowArray) in self.statusArray.enumerated() {
            for (col , status) in rowArray.enumerated() {
                if status == 1 {
                    // 普通砖块
                    let block = UIBezierPath(rect: CGRect(origin: CGPoint(x: CGFloat(col) * self.blockSize.width, y: CGFloat(row) * self.blockSize.height), size: self.blockSize))
                    UIColor.gray.setFill()
                    block.fill()
                    // 增加普通砖块的数量
                    self.normalBlockNum = self.normalBlockNum + 1
                }
            }
        }
        // 检查砖块数量
        if self.normalBlockNum == 0 {
            // 砖块全部消失，结束
            if let delegate = self.delegate {
                delegate.mapViewAllBlockDissmiss()
            }
        }
    }
    
    /// 检查指定点是否与block碰撞
    func CheckBlockCollision(point:CGPoint) -> Bool {
        // 检查指定点所在的行数
        let rowNum = NSInteger(ceil(point.y / self.blockSize.height)) - 1
        // 检查指定点所在的列数
        let colNum = NSInteger(ceil(point.x / self.blockSize.width)) - 1
        // 检查当前点是否在砖块显示范围内
        if rowNum < 0 || colNum < 0 || rowNum >= self.statusArray.count || colNum >= self.statusArray[rowNum].count {
            return false;
        }
        // 检查所在点的砖块状态
        let status = self.statusArray[rowNum][colNum]
        if status == 1 {
            // 该位置是砖块
            // 取消该砖块
            self.statusArray[rowNum][colNum] = 0
            self.setNeedsDisplay()
            return true
        }
        return false
    }
    
}
