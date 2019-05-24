//
//  MapEditorMenuView.swift
//  Marbles
//
//  Created by KnightSama on 2019/5/23.
//  Copyright © 2019 KnightSama. All rights reserved.
//

import UIKit

@objc protocol MapEditorMenuDelegate {
    func mapEditorMenuChange(rowNum: NSInteger,colNum: NSInteger,height: CGFloat)
    func mapEditorMenuSave()
    func mapEditorMenuCancel()
    func mapEditorMenuClear()
    func mapEditorDrawTypeChanged(type: Int)
}

class MapEditorMenuView: UIView {
    /// 标题
    @IBOutlet weak var titleField: UITextField!
    /// 选择行数
    @IBOutlet weak var rowNumSelectView: NumberSelectView!
    /// 选择列数
    @IBOutlet weak var colNumSelectView: NumberSelectView!
    /// 选择高度
    @IBOutlet weak var heightSelectView: NumberSelectView!
    /// 选择画笔
    @IBOutlet weak var drawTypeSelectView: UISegmentedControl!
    
    weak var delegate: MapEditorMenuDelegate?
    
    /// 数据变更
    @IBAction func selectViewChanged(_ sender: NumberSelectView) {
        delegate?.mapEditorMenuChange(rowNum: rowNumSelectView.currentValue, colNum: colNumSelectView.currentValue, height: CGFloat(heightSelectView.currentValue))
    }
    
    /// 保存
    @IBAction func save(_ sender: UIButton) {
        sender.isEnabled = false
        delegate?.mapEditorMenuSave()
    }
    
    /// 取消
    @IBAction func cancel(_ sender: Any) {
        delegate?.mapEditorMenuCancel()
    }
    
    /// 清空
    @IBAction func clear(_ sender: Any) {
        delegate?.mapEditorMenuClear()
    }
    
    /// 画笔变更
    @IBAction func drawTypeChanged(_ sender: Any) {
        delegate?.mapEditorDrawTypeChanged(type: drawTypeSelectView.selectedSegmentIndex)
    }
}
