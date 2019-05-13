//
//  MapEditorView.swift
//  Marbles
//
//  Created by ZCW on 2019/5/13.
//  Copyright © 2019年 KnightSama. All rights reserved.
//

import UIKit

class MapEditorView: UIView {
    /// 设置当前绘制的类型
    private var drawType = 1
    /// 砖块的大小
    private var blockSize = CGSize(width: 0, height: 0)
    /// 砖块的范围
    private var blockArea = CGRect(x: 0, y: 0, width: 0, height: 0)
    /// 数据源
    var model: MapModel = MapModel()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    convenience init(rowNum: NSInteger, colNum: NSInteger, height: CGFloat, frame: CGRect) {
        self.init(frame: frame)
        self.model.height = height
        self.model.infoArr = Array(repeating: Array(repeating: 0, count: colNum), count: rowNum)
    }
    
    convenience init(model: MapModel, frame: CGRect) {
        self.init(frame: frame)
        self.model = model
    }
    
    func prepareForEdit() {
        // 计算单个block的大小
        let width = self.frame.width / CGFloat(self.model.infoArr.first!.count)
        let height = self.model.height > 0 ? self.model.height : width
        self.blockSize = CGSize(width: width, height: height)
        // 计算block的范围
        self.blockArea = CGRect(x: 0, y: 0, width: self.frame.width, height: height * CGFloat(self.model.infoArr.count))
        self.setNeedsDisplay()
    }
    
    // 绘制某个点
    private func draw(point: CGPoint) {
        // 检查当前点所在的位置是否在砖块范围内
        if self.blockArea.contains(point) {
            // 检查指定点所在的行数
            let rowNum = NSInteger(ceil(point.y / self.blockSize.height)) - 1
            // 检查指定点所在的列数
            let colNum = NSInteger(ceil(point.x / self.blockSize.width)) - 1
            // 检查当前点的类型与当前类型一致
            if self.model.infoArr[rowNum][colNum] != self.drawType {
                // 变更
                self.model.infoArr[rowNum][colNum] = self.drawType
                // 重绘
                self.setNeedsDisplay()
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        for (row , rowArray) in self.model.infoArr.enumerated() {
            for (col , status) in rowArray.enumerated() {
                switch status {
                    case 1:
                        // 普通砖块
                        let block = UIBezierPath(rect: CGRect(origin: CGPoint(x: CGFloat(col) * self.blockSize.width, y: CGFloat(row) * self.blockSize.height), size: self.blockSize))
                        UIColor.gray.setFill()
                        UIColor.black.setStroke()
                        block.fill()
                        block.stroke()
                    default:
                        // 没有砖块
                        let block = UIBezierPath(rect: CGRect(origin: CGPoint(x: CGFloat(col) * self.blockSize.width, y: CGFloat(row) * self.blockSize.height), size: self.blockSize))
                        UIColor.black.setStroke()
                        block.stroke()
                }
            }
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.draw(point: touches.first!.location(in: self))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.draw(point: touches.first!.location(in: self))
    }

}
