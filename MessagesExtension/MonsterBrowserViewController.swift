//
//  MonsterBrowserViewController.swift
//  StickerTest
//
//  Created by William Robinson on 25/09/2016.
//  Copyright © 2016 William Robinson. All rights reserved.
//

import UIKit
import Messages

protocol MonsterBrowserViewControllerDelegate: class {
    func addCellSelected()
    func deleteButtonPressedForCellAtIndex(index: Int)
}

enum stickerType {
    case emoji
    case parts
    case accessories
    case text
    case all
}

enum cellSize {
    case small
    case medium
    case large
}

class MonsterBrowserViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var collectionViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionViewTopLayoutConstraint: NSLayoutConstraint!

    weak var delegate: MonsterBrowserViewControllerDelegate?
    var stickerManager: StickerManager! = nil
    var editingCustomStickers = false
    var viewingStickerType = stickerType.emoji
    var viewingCellSize = cellSize.medium
    var animating = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleView()
        view.layoutIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
    }
    
    func styleView() {
        collectionView.backgroundColor = .white
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
    }
    
    func reloadData() {
        
        collectionView.reloadData()
    }
    
    // MARK: - IBAction
    
    @IBAction func stickerTypeButtonPressed(_ sender: UIButton) {
        
        switch sender.tag {
        case 2:
            viewingStickerType = .emoji
        case 3:
            viewingStickerType = .parts
        case 4:
            viewingStickerType = .accessories
        case 5:
            viewingStickerType = .text
        case 6:
            viewingStickerType = .all
        default:
            viewingStickerType = .all
        }
        collectionView.reloadData()
    }
    
    @IBAction func cellSizeButtonPressed(_ sender: UIButton) {
        
        switch sender.tag {
        case 7:
            viewingCellSize = .small
        case 8:
            viewingCellSize = .medium
        case 9:
            viewingCellSize = .large
        default:
            viewingCellSize = .medium
        }
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.reloadData()
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {

        if sender.tag < 0 {
            print("Tried to delete before 0")
            return
        }
        
        delegate?.deleteButtonPressedForCellAtIndex(index: sender.tag)
    }
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        
        editingCustomStickers = !editingCustomStickers
        
        if (editingCustomStickers == true) {
            
            sender.setImage(UIImage(named:"DoneHeader"), for: UIControlState.normal)
        } else {
            sender.setImage(UIImage(named:"DeleteHeader"), for: UIControlState.normal)
        }
        collectionView.reloadData()
    }
    
    @IBAction func animatingButtonPressed(_ sender: UIButton) {
        
        animating = !animating
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.reloadData()
    }
    
    
    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1 + stickerManager.customStickers.count
        } else {
            
            switch viewingStickerType {
            case .all:
                return StickerManager().createAllStickerArray(animated: animating).count
            case .emoji:
                return StickerManager().createEmojiStickerArray(animated: animating).count
            case .parts:
                return StickerManager().createPartStickerArray().count
            case .accessories:
                return StickerManager().createAccessoriesArray().count
            case .text:
                return StickerManager().createTextArray().count
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddCell", for: indexPath as IndexPath)
                
                return cell
                
            } else {
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StickerCell", for: indexPath as IndexPath) as! StickerCollectionViewCell
                cell.configureCell(sticker: stickerManager.customStickers[indexPath.row - 1], editing: editingCustomStickers)
                cell.deleteButton.tag = indexPath.row - 1

                
                return cell
            }
            
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StickerCell", for: indexPath as IndexPath) as! StickerCollectionViewCell
            
            switch viewingStickerType {
            case .all:
            cell.configureCell(sticker: StickerManager().createAllStickerArray(animated: animating)[indexPath.row], editing: false)
            case .emoji:
            cell.configureCell(sticker: StickerManager().createEmojiStickerArray(animated: animating)[indexPath.row], editing: false)
            case .parts:
                cell.configureCell(sticker: StickerManager().createPartStickerArray()[indexPath.row], editing: false)
            case .accessories:
                cell.configureCell(sticker: StickerManager().createAccessoriesStickerArray(animated: animating)[indexPath.row], editing: false)
            case .text:
                cell.configureCell(sticker: StickerManager().createTextStickerArray()[indexPath.row], editing: false)
            }
            return cell
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        
//        if indexPath.section == 1 {
//            
//            if let cell = collectionView.cellForItem(at: indexPath) as? StickerCollectionViewCell {
//                
//                cell.stickerView.stopAnimating()
//                cell.stickerView.sticker = nil
//            }
//        }
//    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            
            delegate?.addCellSelected()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath)
            headerView.backgroundColor = .clear
            
            let view = headerView.viewWithTag(10)
            view?.backgroundColor = .clear
            let imageView = headerView.viewWithTag(11) as! UIImageView

            let button = headerView.viewWithTag(1) as! UIButton
            let emojiButton = headerView.viewWithTag(2) as! UIButton
            let partsButton = headerView.viewWithTag(3) as! UIButton
            let accessoriesButton = headerView.viewWithTag(4) as! UIButton
            let textButton = headerView.viewWithTag(5) as! UIButton
            let allButton = headerView.viewWithTag(6) as! UIButton
            let smallButton = headerView.viewWithTag(7) as! UIButton
            let mediumButton = headerView.viewWithTag(8) as! UIButton
            let largeButton = headerView.viewWithTag(9) as! UIButton
            let animatingButton = headerView.viewWithTag(20) as! UIButton

            if indexPath.section == 0 {
                
                imageView.isHidden = false
                button.isHidden = false
                smallButton.isHidden = false
                mediumButton.isHidden = false
                largeButton.isHidden = false
                animatingButton.isHidden = false
                
                //allButton.isHidden = true
                emojiButton.isHidden = true
                partsButton.isHidden = true
                accessoriesButton.isHidden = true
                textButton.isHidden = true
                
                
                if (editingCustomStickers == true) {
                    
                    button.setImage(UIImage(named:"DoneHeader"), for: UIControlState.normal)
                } else {
                    button.setImage(UIImage(named:"DeleteHeader"), for: UIControlState.normal)
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
                                
                switch viewingCellSize {
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
                
            } else {
                
                imageView.isHidden = true

                button.isHidden = true
                smallButton.isHidden = true
                mediumButton.isHidden = true
                largeButton.isHidden = true
                animatingButton.isHidden = true

                //allButton.isHidden = false
                emojiButton.isHidden = false
                partsButton.isHidden = false
                accessoriesButton.isHidden = false
                textButton.isHidden = false
                
                allButton.setImage(UIImage(named:"All"), for: UIControlState.normal)
                allButton.setImage(UIImage(named:"All")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.highlighted)
                allButton.setImage(UIImage(named:"All")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.selected)
                allButton.tintColor = .white
                
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
                
                switch viewingStickerType {
                case .all:
                    allButton.isSelected = true
                    emojiButton.isSelected = false
                    partsButton.isSelected = false
                    accessoriesButton.isSelected = false
                    textButton.isSelected = false
                case .emoji:
                    allButton.isSelected = false
                    emojiButton.isSelected = true
                    partsButton.isSelected = false
                    accessoriesButton.isSelected = false
                    textButton.isSelected = false
                case .parts:
                    allButton.isSelected = false
                    emojiButton.isSelected = false
                    partsButton.isSelected = true
                    accessoriesButton.isSelected = false
                    textButton.isSelected = false
                case .accessories:
                    allButton.isSelected = false
                    emojiButton.isSelected = false
                    partsButton.isSelected = false
                    accessoriesButton.isSelected = true
                    textButton.isSelected = false
                case .text:
                    allButton.isSelected = false
                    emojiButton.isSelected = false
                    partsButton.isSelected = false
                    accessoriesButton.isSelected = false
                    textButton.isSelected = true
                }
            }
            
            return headerView
        case UICollectionElementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer", for: indexPath)
            footerView.backgroundColor = .clear
            let imageView = footerView.viewWithTag(1) as! UIImageView
            let twitterImageView = footerView.viewWithTag(2) as! UIImageView

            if indexPath.section == 0 {
                imageView.isHidden = false
                twitterImageView.isHidden = true
            } else {
                imageView.isHidden = true
                twitterImageView.isHidden = false
            }
            
            return footerView
        default:
            return UICollectionReusableView()
        }
    }
}

extension MonsterBrowserViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var smallDivision = 5.0 as CGFloat
        var mediumDivision = 4.0 as CGFloat
        var largeDivision = 3.0 as CGFloat

        let horizontalClass = self.traitCollection.horizontalSizeClass;
        let verticalClass = self.traitCollection.verticalSizeClass;
        
        if horizontalClass == UIUserInterfaceSizeClass.regular && verticalClass == UIUserInterfaceSizeClass.regular {
            
            smallDivision = 6
            mediumDivision = 5
            largeDivision = 4
        }
        
        switch viewingCellSize {
        case .small:
            return CGSize(width: view.frame.size.width / smallDivision, height: view.frame.size.width / smallDivision)
        case .medium:
            return CGSize(width: view.frame.size.width / mediumDivision, height: view.frame.size.width / mediumDivision)
        case .large:
            return CGSize(width: view.frame.size.width / largeDivision, height: view.frame.size.width / largeDivision)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 58.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        if section == 0 {
            return CGSize(width: view.frame.width, height: 16.0)
        } else {
            return CGSize(width: view.frame.width, height: 26.0)
        }
    }

    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        
//        print("Inset")
//        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
//    }
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
//        return sectionInsets
//    }
}
