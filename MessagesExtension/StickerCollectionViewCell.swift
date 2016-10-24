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

enum MonsterBrowserHeaderType {
    case custom
    case provided
}

class MonsterBrowserCollectionHeaderReusableView: UICollectionReusableView {
    
    @IBOutlet weak var backgroundImageView: UIImageView!

    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var animatingButton: UIButton!

    @IBOutlet weak var emojiButton: UIButton!
    @IBOutlet weak var partsButton: UIButton!
    @IBOutlet weak var accessoriesButton: UIButton!
    @IBOutlet weak var textButton: UIButton!
    
    @IBOutlet weak var smallButton: UIButton!
    @IBOutlet weak var mediumButton: UIButton!
    @IBOutlet weak var largeButton: UIButton!
    
    func configureCell(type: MonsterBrowserHeaderType, editing: Bool, animating: Bool, stickerType: stickerType, cellSize: cellSize) {
        
        switch type {
        case .custom:

            backgroundColor = .clear

            backgroundImageView.isHidden = false
            
            editButton.isHidden = false
            smallButton.isHidden = false
            mediumButton.isHidden = false
            largeButton.isHidden = false
            animatingButton.isHidden = false
            
            emojiButton.isHidden = true
            partsButton.isHidden = true
            accessoriesButton.isHidden = true
            textButton.isHidden = true
            
            if (editing == true) {
                
                editButton.setImage(UIImage(named:"DoneHeader"), for: UIControlState.normal)
            } else {
                editButton.setImage(UIImage(named:"DeleteHeader"), for: UIControlState.normal)
            }
            
            smallButton.setImage(UIImage(named:"Small"), for: UIControlState.normal)
            smallButton.setImage(UIImage(named:"Small")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.highlighted)
            smallButton.setImage(UIImage(named:"Small")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.selected)
            smallButton.tintColor = .white
            
            mediumButton.setImage(UIImage(named:"Medium"), for: UIControlState.normal)
            mediumButton.setImage(UIImage(named:"Medium")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.highlighted)
            mediumButton.setImage(UIImage(named:"Medium")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.selected)
            mediumButton.tintColor = .white
            
            largeButton.setImage(UIImage(named:"Large"), for: UIControlState.normal)
            largeButton.setImage(UIImage(named:"Large")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.highlighted)
            largeButton.setImage(UIImage(named:"Large")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.selected)
            largeButton.tintColor = .white
            
            switch cellSize {
            case .small:
                smallButton.isSelected = true
                mediumButton.isSelected = false
                largeButton.isSelected = false
            case .medium:
                largeButton.isSelected = false
                mediumButton.isSelected = true
                largeButton.isSelected = false
            case .large:
                smallButton.isSelected = false
                mediumButton.isSelected = false
                largeButton.isSelected = true
            }
            
            animatingButton.setImage(UIImage(named:"PlayDisabled"), for: UIControlState.normal)
            animatingButton.setImage(UIImage(named:"Play"), for: UIControlState.selected)
            animatingButton.setImage(UIImage(named:"PlayDisabled")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.highlighted)
            animatingButton.setImage(UIImage(named:"PlayDisabled")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.disabled)
            animatingButton.isSelected = animating
            
        case .provided:

            backgroundImageView.isHidden = true
            
            editButton.isHidden = true
            smallButton.isHidden = true
            mediumButton.isHidden = true
            largeButton.isHidden = true
            animatingButton.isHidden = true
            
            emojiButton.isHidden = false
            partsButton.isHidden = false
            accessoriesButton.isHidden = false
            textButton.isHidden = false
            
            emojiButton.setImage(UIImage(named:"Emoji"), for: UIControlState.normal)
            emojiButton.setImage(UIImage(named:"Emoji")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.highlighted)
            emojiButton.setImage(UIImage(named:"Emoji")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.selected)
            emojiButton.tintColor = .white
            
            partsButton.setImage(UIImage(named:"Parts"), for: UIControlState.normal)
            partsButton.setImage(UIImage(named:"Parts")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.highlighted)
            partsButton.setImage(UIImage(named:"Parts")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.selected)
            partsButton.tintColor = .white
            
            accessoriesButton.setImage(UIImage(named:"Accessories"), for: UIControlState.normal)
            accessoriesButton.setImage(UIImage(named:"Accessories")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.highlighted)
            accessoriesButton.setImage(UIImage(named:"Accessories")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.selected)
            accessoriesButton.tintColor = .white
            
            textButton.setImage(UIImage(named:"Text"), for: UIControlState.normal)
            textButton.setImage(UIImage(named:"Text")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.highlighted)
            textButton.setImage(UIImage(named:"Text")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.selected)
            textButton.tintColor = .white
            
            switch stickerType {
            case .all:
                emojiButton.isSelected = false
                partsButton.isSelected = false
                accessoriesButton.isSelected = false
                textButton.isSelected = false
            case .emoji:
                emojiButton.isSelected = true
                partsButton.isSelected = false
                accessoriesButton.isSelected = false
                textButton.isSelected = false
            case .parts:
                emojiButton.isSelected = false
                partsButton.isSelected = true
                accessoriesButton.isSelected = false
                textButton.isSelected = false
            case .accessories:
                emojiButton.isSelected = false
                partsButton.isSelected = false
                accessoriesButton.isSelected = true
                textButton.isSelected = false
            case .text:
                emojiButton.isSelected = false
                partsButton.isSelected = false
                accessoriesButton.isSelected = false
                textButton.isSelected = true
            }
        }
    }
}

enum MonsterBrowserFooterType {
    case topSlime
    case twitter
}

class MonsterBrowserCollectionFooterReusableView: UICollectionReusableView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var twitterImageView: UIImageView!

    func configureCell(type: MonsterBrowserFooterType) {
        backgroundColor = .clear
        
        switch type {
            case .topSlime:
                imageView.isHidden = false
                twitterImageView.isHidden = true
            case .twitter:
                imageView.isHidden = true
                twitterImageView.isHidden = false
        }
    }
}

