//
//  StickerCollectionViewCell.swift
//  projectstickers
//
//  Created by William Robinson on 09/10/2016.
//  Copyright © 2016 William Robinson. All rights reserved.
//

import UIKit
import Messages

class AddCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var addImageView: UIImageView!
    
    func configureCell(enabled: Bool) {
        
        backgroundColor = .white
        contentView.backgroundColor = .white
        
        let modifier: String
        let date = DateManager().detectMonth()
        if date == .december {
            modifier = "Christmas"
            
        } else {
            modifier = "Green"
        }
        
        if enabled == true {
            addImageView.image = UIImage(named: "AddInvert" + modifier)
            isUserInteractionEnabled = true
        } else {
            addImageView.image = UIImage(named: "AddDisabled" + modifier)
            isUserInteractionEnabled = false
        }
    }
}

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
    @IBOutlet weak var headerImageView: UIImageView!

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
        
        let date = DateManager().detectMonth()
        if date == .december {
            headerImageView.image = UIImage(named: "HeaderChristmas")
            
        } else {
            headerImageView.image = UIImage(named: "HeaderGreen")
        }
        
        let modifier: String
        let tintColor: UIColor
        
        if date == .december {
            modifier = "Christmas"
            tintColor = UIColor(red: 91/255, green: 142/255, blue: 196/255, alpha: 1.0)
        } else {
            modifier = "Green"
            tintColor = .white
        }
        
        switch type {
        case .custom:

            backgroundColor = .clear
            backgroundImageView.isHidden = false
            
            if date == .december {
                backgroundImageView.image = UIImage(named: "MakerBackgroundChristmas")
            } else {
                backgroundImageView.image = UIImage(named: "MakerBackgroundGreen")
            }
            
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
            
            smallButton.setImage(UIImage(named:"Small" + modifier), for: UIControlState.normal)
            smallButton.setImage(UIImage(named:"Small" + modifier)?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.highlighted)
            smallButton.setImage(UIImage(named:"Small" + modifier)?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.selected)
            smallButton.tintColor = tintColor
            
            mediumButton.setImage(UIImage(named:"Medium" + modifier), for: UIControlState.normal)
            mediumButton.setImage(UIImage(named:"Medium" + modifier)?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.highlighted)
            mediumButton.setImage(UIImage(named:"Medium" + modifier)?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.selected)
            mediumButton.tintColor = tintColor
            
            largeButton.setImage(UIImage(named:"Large" + modifier), for: UIControlState.normal)
            largeButton.setImage(UIImage(named:"Large" + modifier)?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.highlighted)
            largeButton.setImage(UIImage(named:"Large" + modifier)?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.selected)
            largeButton.tintColor = tintColor
            
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
            
            animatingButton.setImage(UIImage(named:"PlayDisabled" + modifier), for: UIControlState.normal)
            animatingButton.setImage(UIImage(named:"Play" + modifier), for: UIControlState.selected)
            animatingButton.setImage(UIImage(named:"PlayDisabled" + modifier)?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.highlighted)
            animatingButton.setImage(UIImage(named:"PlayDisabled" + modifier)?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.disabled)
            animatingButton.isSelected = animating
            
        case .provided:

            backgroundColor = .clear

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
            
            emojiButton.setImage(UIImage(named:"Emoji" + modifier), for: UIControlState.normal)
            emojiButton.setImage(UIImage(named:"Emoji" + modifier)?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.highlighted)
            emojiButton.setImage(UIImage(named:"Emoji" + modifier)?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.selected)
            emojiButton.tintColor = tintColor
            
            partsButton.setImage(UIImage(named:"Parts" + modifier), for: UIControlState.normal)
            partsButton.setImage(UIImage(named:"Parts" + modifier)?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.highlighted)
            partsButton.setImage(UIImage(named:"Parts" + modifier)?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.selected)
            partsButton.tintColor = tintColor
            
            accessoriesButton.setImage(UIImage(named:"Accessories" + modifier), for: UIControlState.normal)
            accessoriesButton.setImage(UIImage(named:"Accessories" + modifier)?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.highlighted)
            accessoriesButton.setImage(UIImage(named:"Accessories" + modifier)?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.selected)
            accessoriesButton.tintColor = tintColor
            
            textButton.setImage(UIImage(named:"Text" + modifier), for: UIControlState.normal)
            textButton.setImage(UIImage(named:"Text" + modifier)?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.highlighted)
            textButton.setImage(UIImage(named:"Text" + modifier)?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.selected)
            textButton.tintColor = tintColor
            
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
                
                let date = DateManager().detectMonth()
                if date == .december {
                    imageView.image = UIImage(named: "FooterChristmas")
                } else {
                    imageView.image = UIImage(named: "FooterGreen")
                }
                
                imageView.isHidden = false
                twitterImageView.isHidden = true
            case .twitter:
                imageView.isHidden = true
                twitterImageView.isHidden = false
        }
    }
}

