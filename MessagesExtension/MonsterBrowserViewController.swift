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

    let feedbackGenerator = UINotificationFeedbackGenerator()
    
    weak var delegate: MonsterBrowserViewControllerDelegate?
    var stickerManager: StickerManager! = nil
    var editingCustomStickers = false
    var viewingStickerType = stickerType.emoji
    var viewingCellSize = cellSize.medium
    var animating = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedbackGenerator.prepare()
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
        
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
        
        collectionView.reloadData()
    }
    
    @IBAction func cellSizeButtonPressed(_ sender: UIButton) {
        
        switch sender.tag {
        case 7:
            viewingCellSize = .small
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
        case 8:
            viewingCellSize = .medium
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.prepare()
            generator.impactOccurred()
        case 9:
            viewingCellSize = .large
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.prepare()
            generator.impactOccurred()
        default:
            viewingCellSize = .medium
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.prepare()
            generator.impactOccurred()
        }
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.reloadData()
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {

        if sender.tag < 0 {
            print("Tried to delete before 0")
            return
        }
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.success)

        delegate?.deleteButtonPressedForCellAtIndex(index: sender.tag)
    }
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        
        editingCustomStickers = !editingCustomStickers
        
        if (editingCustomStickers == true) {
            
            sender.setImage(UIImage(named:"DoneHeader"), for: UIControlState.normal)
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(.warning)
        } else {
            sender.setImage(UIImage(named:"DeleteHeader"), for: UIControlState.normal)
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(.success)
        }
        collectionView.reloadData()
    }
    
    @IBAction func animatingButtonPressed(_ sender: UIButton) {
        
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
        
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
                cell.layer.shouldRasterize = true;
                cell.layer.rasterizationScale = UIScreen.main.scale
                cell.configureCell(sticker: stickerManager.customStickers[indexPath.row - 1], editing: editingCustomStickers)
                cell.deleteButton.tag = indexPath.row - 1

                return cell
            }
            
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StickerCell", for: indexPath as IndexPath) as! StickerCollectionViewCell
            cell.layer.shouldRasterize = true;
            cell.layer.rasterizationScale = UIScreen.main.scale
            
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
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.prepare()
            generator.impactOccurred()
            delegate?.addCellSelected()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! MonsterBrowserCollectionHeaderReusableView
            
            if indexPath.section == 0 {
                headerView.configureCell(type: .custom, editing: editingCustomStickers, animating: animating, stickerType: viewingStickerType, cellSize: viewingCellSize)
            } else {
                headerView.configureCell(type: .provided, editing: editingCustomStickers, animating: animating, stickerType: viewingStickerType, cellSize: viewingCellSize)
            }
            return headerView
            
        case UICollectionElementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer", for: indexPath) as! MonsterBrowserCollectionFooterReusableView
            
            if indexPath.section == 0 {
                footerView.configureCell(type: .topSlime)
            } else {
                footerView.configureCell(type: .twitter)
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
