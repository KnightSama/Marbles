//
//  MapManager.swift
//  Marbles
//
//  Created by ZCW on 2019/5/14.
//  Copyright © 2019年 KnightSama. All rights reserved.
//

import UIKit
import WCDBSwift

class MapManager: NSObject {
    /// 单例
    static let share = MapManager()
    /// 数据库
    private let database : Database
    /// 表名
    private let tableName = "MapInfo"
    /// 数据库地址
    private let databasePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0].appending("/MapData")
    
    /// 私有化初始化方法确保单例调用
    override private init() {
        self.database = Database(withPath: databasePath)
        print(databasePath)
        super.init()
        do {
            try self.database.create(table: tableName, of: MapModel.self)
        } catch let error {
            print("create table error \(error.localizedDescription)")
        }
    }
    
    /// 保存地图
    func saveMap(model:MapModel) {
        // 检查主键是否存在
        if model.code.count == 0 {
            // 不存在则创建主键
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMddHHmmss"
            model.code = formatter.string(from: Date())
        }
        // 保存
        do {
            try self.database.insertOrReplace(objects: model, intoTable: tableName)
        } catch let error {
            print("save data error \(error.localizedDescription)")
        }
    }
    
    /// 获取全部地图列表
    func loadMap() -> [MapModel]?? {
        return try? self.database.getObjects(on: MapModel.Properties.all, fromTable: tableName)
    }
    
    /// 通过名称获取地图
    func loadMap(name:String) -> MapModel?? {
        return try? self.database.getObject(on:MapModel.Properties.all, fromTable: tableName ,where: MapModel.Properties.name.match(name))
    }
    
    /// 通过id获取
    func loadMap(code:String) -> MapModel?? {
        return try? self.database.getObject(on: MapModel.Properties.all, fromTable: tableName ,where: MapModel.Properties.code.match(code))
    }
    
    /// 删除地图
    func deleteMap(model:MapModel) {
        do {
            try self.database.delete(fromTable: tableName, where: MapModel.Properties.code.match(model.code))
        } catch let error {
            print("data delete error \(error.localizedDescription)")
        }
    }
}
