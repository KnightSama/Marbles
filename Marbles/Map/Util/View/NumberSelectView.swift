//
//  NumberSelectView.swift
//  Marbles
//
//  Created by KnightSama on 2019/5/23.
//  Copyright © 2019 KnightSama. All rights reserved.
//

import UIKit
import Masonry

@IBDesignable class NumberSelectView: UIControl {
    private let numLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    private let reduceBtn: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    private let addBtn: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    /// 设置最小值
    @IBInspectable var minValue:Int = 0
    /// 设置最大值
    @IBInspectable var maxValue:Int = Int.max
    /// 设置当前值
    @IBInspectable var currentValue:Int = 0 {
        didSet {
            numLabel.text = "\(currentValue)"
        }
    }
    /// 设置字体大小
    @IBInspectable var fontSize:Double = 15 {
        didSet {
            numLabel.font = UIFont.systemFont(ofSize: CGFloat(fontSize))
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    private func setup() {
        self.addSubview(reduceBtn)
        reduceBtn.addTarget(self, action: #selector(reduce), for: .touchUpInside)
        reduceBtn.backgroundColor = .gray
        reduceBtn.isEnabled = currentValue > minValue
        reduceBtn.mas_makeConstraints { (make) in
            make?.top.mas_equalTo()(self)
            make?.left.mas_equalTo()(self)
            make?.bottom.mas_equalTo()(self)
            make?.width.mas_equalTo()(reduceBtn.mas_height)?.multipliedBy()(1)
        }
        
        self.addSubview(addBtn)
        addBtn.addTarget(self, action: #selector(add), for: .touchUpInside)
        addBtn.backgroundColor = .gray
        addBtn.isEnabled = currentValue < maxValue
        addBtn.mas_makeConstraints { (make) in
            make?.top.mas_equalTo()(self)
            make?.right.mas_equalTo()(self)
            make?.bottom.mas_equalTo()(self)
            make?.width.mas_equalTo()(addBtn.mas_height)?.multipliedBy()(1)
        }
        
        numLabel.textAlignment = .center
        numLabel.text = "\(currentValue)"
        self.addSubview(numLabel)
        numLabel.mas_makeConstraints { (make) in
            make?.top.mas_equalTo()(self)
            make?.left.mas_equalTo()(reduceBtn.mas_right)
            make?.bottom.mas_equalTo()(self)
            make?.right.mas_equalTo()(addBtn.mas_left)
        }
    }
    
    @objc private func reduce() {
        currentValue = currentValue - 1
        if currentValue <= minValue {
            reduceBtn.isEnabled = false
        }
        if currentValue < maxValue {
            addBtn.isEnabled = true
        }
        self.sendActions(for: .valueChanged)
    }
    
    @objc private func add() {
        currentValue = currentValue + 1
        if currentValue >= maxValue {
            addBtn.isEnabled = false
        }
        if currentValue > minValue {
            reduceBtn.isEnabled = true
        }
        self.sendActions(for: .valueChanged)
    }

}


