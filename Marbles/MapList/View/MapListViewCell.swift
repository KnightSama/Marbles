//
//  MapListViewCell.swift
//  Marbles
//
//  Created by KnightSama on 2019/5/22.
//  Copyright © 2019 KnightSama. All rights reserved.
//

import UIKit

class MapListViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var model:MapModel? {
        didSet {
            self.setup()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .gray
    }
    
    func setup() {
        if let image = UIImage(data: Data(base64Encoded: model?.image ?? "") ?? Data()) {
            imageView.image = image
        }
        titleLabel.text = model?.name
        timeLabel.text = "创建日期:\(model?.createDate ?? "")"
    }
}
