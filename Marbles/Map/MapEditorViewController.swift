//
//  MapEditorViewController.swift
//  Marbles
//
//  Created by ZCW on 2019/5/13.
//  Copyright © 2019年 KnightSama. All rights reserved.
//

import UIKit

class MapEditorViewController: UIViewController, MapEditorMenuDelegate {
    
    /// 背景图
    private let backImageView: UIImageView = UIImageView(frame: CGRect.zero)
    /// 内容视图
    private let contentView: UIView = UIView(frame: CGRect.zero)
    /// 编辑按钮
    private let editMenuView: MapEditorMenuView = Bundle.main.loadNibNamed("MapEditorMenuView", owner: nil, options: nil)?.last as! MapEditorMenuView
    /// 地图编辑
    private let mapEditorView: MapEditorView = MapEditorView(rowNum: 10, colNum: 20, height: 0, frame: CGRect.zero)

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        self.loadSubviews()
    }
    
    func loadSubviews() {
        // 添加背景
        backImageView.frame = self.view.bounds
        backImageView.backgroundColor = .gray
        self.view.addSubview(backImageView)
        
        // 添加内容视图
        var contentEdge = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        if #available(iOS 11.0, *) {
            contentEdge = UIEdgeInsets(top: UIApplication.shared.keyWindow!.safeAreaInsets.top + 15, left: 15, bottom: UIApplication.shared.keyWindow!.safeAreaInsets.bottom + 15, right: 15)
        }
        contentView.frame = CGRect(x: contentEdge.left, y: contentEdge.top, width: self.view.frame.width - contentEdge.left - contentEdge.right, height: self.view.frame.height - contentEdge.top - contentEdge.bottom)
        contentView.backgroundColor = .white
        self.view.addSubview(contentView)
        
        // 添加地图
        mapEditorView.frame = contentView.bounds
        contentView.addSubview(mapEditorView)
        
        // 添加编辑面板
        editMenuView.frame = CGRect(x: 0, y: contentView.bounds.height - 200, width: contentView.bounds.width, height: 200)
        editMenuView.delegate = self
        contentView.addSubview(editMenuView)
    }
    
    func mapEditorMenuChange(rowNum: NSInteger, colNum: NSInteger, height: CGFloat) {
        mapEditorView.changeArea(rowNum: rowNum, colNum: colNum, height: height)
    }
    
    func mapEditorMenuSave() {
        let model = mapEditorView.model
        // 添加名称
        model.name = editMenuView.titleField.text ?? "NEW GAME"
        // 添加日期
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        model.createDate = dateFormatter.string(from: Date())
        // 添加截图
        editMenuView.isHidden = true
        mapEditorView.showGrid = false
        UIGraphicsBeginImageContextWithOptions(CGSize(width: self.view.frame.width, height: self.view.frame.height), true, 1)
        self.view.drawHierarchy(in: self.view.bounds, afterScreenUpdates: true)
        let snapImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        model.image = snapImage?.pngData()?.base64EncodedString() ?? ""
        mapEditorView.showGrid = true
        editMenuView.isHidden = false
        // 保存
        DispatchQueue.global().async {
            MapManager.share.saveMap(model: model)
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func mapEditorMenuCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func mapEditorMenuClear() {
        mapEditorView.clearArea()
    }
    
    func mapEditorDrawTypeChanged(type: Int) {
        switch type {
            case 1:
                mapEditorView.changeDrawType(type: .block)
            default:
                mapEditorView.changeDrawType(type: .blank)
        }
    }

}
