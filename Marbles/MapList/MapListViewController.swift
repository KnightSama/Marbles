//
//  MapListViewController.swift
//  Marbles
//
//  Created by KnightSama on 2019/5/16.
//  Copyright © 2019 KnightSama. All rights reserved.
//

import UIKit

class MapListViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {

    private lazy var mapListView:UICollectionView = {
        // 计算顶部距离
        var top:CGFloat = self.navigationController?.navigationBar.frame.height ?? 0.0
        if #available(iOS 11.0, *) {
            top = top + UIApplication.shared.keyWindow!.safeAreaInsets.top
        }
        
        let frame = CGRect(x: 0, y: top, width: self.view.frame.width, height: self.view.frame.height - top)
        // 设置布局
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10.0
        layout.minimumLineSpacing = 10.0
        let width = (self.view.frame.width - 50) / 3.0
        let height = width * (frame.height / frame.width)
        layout.itemSize = CGSize(width:width, height: height)
        // 初始化collectionView
        let mapListView = UICollectionView(frame: frame, collectionViewLayout: layout)
        mapListView.backgroundColor = .white
        if #available(iOS 11.0, *) {
            mapListView.contentInset = UIEdgeInsets(top: 15, left: 15, bottom: UIApplication.shared.keyWindow!.safeAreaInsets.top, right: 15)
        } else {
            mapListView.contentInset = UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 15)
        }
        mapListView.delegate = self
        mapListView.dataSource = self
        // 注册cell
        mapListView.register(MapListViewCell.self, forCellWithReuseIdentifier: "MapListViewCell")
        
        return mapListView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.createSubViews()

        if #available(iOS 11.0, *) {
            self.mapListView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    /// 创建布局视图
    private func createSubViews() {
        self.view.addSubview(self.mapListView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MapListViewCell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.backgroundColor = .orange
    }
    
}
