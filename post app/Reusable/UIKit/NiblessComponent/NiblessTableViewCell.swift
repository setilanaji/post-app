//
//  NiblessTableViewCell.swift
//  post app
//
//  Created by Yudha Setyaji on 2022/7/24.
//

import UIKit

open class NiblessTableViewCell: UITableViewCell {
    
    public override init(style: UITableViewCell.CellStyle = .default, reuseIdentifier: String? = "NiblessTableViewCell") {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    @available(*, unavailable,
                message: "Load table view using nib is unsupported")
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Load table view using nib is unsupported")
    }
    
}
