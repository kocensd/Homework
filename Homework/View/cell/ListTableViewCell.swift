//
//  ListTableViewCell.swift
//  Homework
//
//  Created by SangDo on 2020/09/06.
//  Copyright © 2020 SangDo. All rights reserved.
//

import UIKit
import SDWebImage
//회사맥 테스트1
class ListTableViewCell: UITableViewCell {
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var typeNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var thumImageView: UIImageView!
    @IBOutlet weak var selectedView: UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setData(_ item: Search.ResponseData, _ urls: [String]) {
        self.typeLabel.text = item.cafename != "" ? "CAFE" : "BLOG"
        self.typeNameLabel.text = item.cafename != "" ? item.cafename : item.blogname
        self.titleLabel.text = checkValid(item.title)
        self.thumImageView.sd_setImage(with: URL(string: item.thumbnail), placeholderImage: UIImage(named: "no_img.gif"))
        self.dateLabel.text = dateBetween(item.datetime)
        if urls.contains(item.url) {
            selectedView.isHidden = false
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.typeLabel.text = ""
        self.typeNameLabel.text = ""
        self.titleLabel.text = ""
        self.dateLabel.text = ""
        self.thumImageView.image = nil
        self.selectedView.isHidden = true
    }
}
//test

