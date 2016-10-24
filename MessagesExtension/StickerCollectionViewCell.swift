//
//  StickerCollectionViewCell.swift
//  projectstickers
//
//  Created by William Robinson on 09/10/2016.
//  Copyright © 2016 William Robinson. All rights reserved.
//

import UIKit
import Messages

class StickerCollectionViewCell: UICollectionViewCell {
 
    @IBOutlet weak var stickerView: MSStickerView!
    @IBOutlet weak var deleteButton: UIButton!

    func configureCell(sticker: MSSticker, editing: Bool) {
    
        backgroundColor = .white
        contentView.backgroundColor = .white
        stickerView.backgroundColor = .white

        stickerView.sticker = sticker
        stickerView.startAnimating()
        
        if editing == true {
            deleteButton.isHidden = false
            
        } else {
            deleteButton.isHidden = true
        }        
    }
}

class MonsterPartCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func configureCell(image: UIImage, currentlySelected: Bool) {
        
        layer.shouldRasterize = true;
        layer.rasterizationScale = UIScreen.main.scale
        backgroundColor = .white
        contentView.backgroundColor = .white
        
        imageView.image = image
        
        if currentlySelected == true {
            imageView.alpha = 0.0
        } else {
            imageView.alpha = 1.0
        }
    }
}
