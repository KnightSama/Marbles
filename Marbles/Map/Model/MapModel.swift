//
//  MapModel.swift
//  Marbles
//
//  Created by ZCW on 2019/5/10.
//  Copyright © 2019年 KnightSama. All rights reserved.
//

import UIKit
import WCDBSwift

/// 在数据库中将 CGFloat 映射为 Double
extension CGFloat: ColumnCodable {
    public init?(with value: FundamentalValue) {
        self = CGFloat(value.doubleValue)
    }
    
    public func archivedValue() -> FundamentalValue {
        return FundamentalValue(Double(self))
    }
    
    public static var columnType: ColumnType {
        return .float
    }
}

class MapModel: TableCodable {
    /// 编码
    var code = ""
    /// 名称
    var name = ""
    /// 创建时间
    var createDate = ""
    /// 高度
    var height:CGFloat = 0.0
    /// 位置状态
    var infoArr = Array.init([[0]])
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = MapModel
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case code
        case name
        case createDate
        case height
        case infoArr
        
        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                code: ColumnConstraintBinding(isPrimary: true)
            ]
        }
    }
    
    
}

