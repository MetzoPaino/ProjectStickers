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
    case all
    case emoji
    case parts
    case accessories
    case text
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
    
    
//    var collectionViewTopConstraintCopy = NSLayoutConstraint()
//    var collectionViewTopLayoutConstraintCopy = NSLayoutConstraint()

    weak var delegate: MonsterBrowserViewControllerDelegate?
    var stickerManager: StickerManager! = nil
    var editingCustomStickers = false
    var viewingStickerType = stickerType.all
    var viewingCellSize = cellSize.medium

    override func viewDidLoad() {
        super.viewDidLoad()
        //let flow = collectionView.collectionViewLayout as! UICollectionViewFlowLayout

//        collectionViewTopConstraintCopy = collectionViewTopConstraint
//        collectionViewTopLayoutConstraintCopy = collectionViewTopLayoutConstraint

        styleView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
    }
    
    func styleView() {
        collectionView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
       // layout.itemSize = CGSize(width: view.frame.size.width / 2, height:  view.frame.size.width / 2)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
    }
    
    func reloadData() {
        
        collectionView.reloadData()
    }

    func transitioningSize(compact: Bool) {
        
//        if compact == true {
//            
//            collectionViewTopConstraint = collectionViewTopConstraintCopy
//            collectionViewTopLayoutConstraint = collectionViewTopLayoutConstraintCopy
//            
//            collectionViewTopConstraint.isActive = false
//            collectionViewTopLayoutConstraint.isActive = true
//            
//        } else {
//            
//            collectionViewTopConstraint = collectionViewTopConstraintCopy
//            collectionViewTopLayoutConstraint = collectionViewTopLayoutConstraintCopy
//            
//            collectionViewTopConstraint.isActive = true
//            collectionViewTopLayoutConstraint.isActive = false
//
//        }
//        
//        view.layoutIfNeeded()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - IBAction
    
    @IBAction func stickerTypeButtonPressed(_ sender: UIButton) {
        
        switch sender.tag {
        case 2:
            viewingStickerType = .all
        case 3:
            viewingStickerType = .emoji
        case 4:
            viewingStickerType = .parts
        case 5:
            viewingStickerType = .accessories
        case 6:
            viewingStickerType = .text
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
        collectionView.reloadData()
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        
        
        let buttonPosition = sender.convert(CGPoint.zero, to: collectionView)

        guard let selectedIndexPath = collectionView.indexPathForItem(at: buttonPosition) else {
                return
        }
        delegate?.deleteButtonPressedForCellAtIndex(index: selectedIndexPath.row - 1)
        
        print("Here")
    }
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        
        editingCustomStickers = !editingCustomStickers
        
        if (editingCustomStickers == true) {
            
            sender.setImage(UIImage(named:"Done"), for: UIControlState.normal)
        } else {
            sender.setImage(UIImage(named:"Delete"), for: UIControlState.normal)
        }
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1 + stickerManager.customStickers.count
        } else {
            
            switch viewingStickerType {
            case .all:
                return StickerManager().createAllStickerArray().count
            case .emoji:
                return StickerManager().createEmojiStickerArray().count
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
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath)
                
                let stickerView = cell.viewWithTag(1) as! MSStickerView
 
                stickerView.sticker = stickerManager.customStickers[indexPath.row - 1]
                
                let button = cell.viewWithTag(2) as! UIButton
                
                if editingCustomStickers == true {
                    button.isHidden = false

                } else {
                    button.isHidden = true
                }

                
                return cell
            }
            
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath)
            
            let stickerView = cell.viewWithTag(1) as! MSStickerView
            //let imageView = cell.viewWithTag(3) as! UIImageView
            
            switch viewingStickerType {
            case .all:
                stickerView.sticker = StickerManager().createAllStickerArray()[indexPath.row]
            case .emoji:
                stickerView.sticker = StickerManager().createEmojiStickerArray()[indexPath.row]
            case .parts:
                stickerView.sticker = StickerManager().createPartStickerArray()[indexPath.row]
            case .accessories:
                stickerView.sticker = StickerManager().createAccessoriesStickerArray()[indexPath.row]
            case .text:
                stickerView.sticker = StickerManager().createTextStickerArray()[indexPath.row]
            }
            
            let button = cell.viewWithTag(2) as! UIButton
            button.isHidden = true            
            
            return cell
        }
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        
        if indexPath.section == 0 && indexPath.row == 0 {
            
            delegate?.addCellSelected()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath)
            
            let button = headerView.viewWithTag(1) as! UIButton
            let allButton = headerView.viewWithTag(2) as! UIButton
            let emojiButton = headerView.viewWithTag(3) as! UIButton
            let partsButton = headerView.viewWithTag(4) as! UIButton
            let accessoriesButton = headerView.viewWithTag(5) as! UIButton
            let textButton = headerView.viewWithTag(6) as! UIButton
            let smallButton = headerView.viewWithTag(7) as! UIButton
            let mediumButton = headerView.viewWithTag(8) as! UIButton
            let largeButton = headerView.viewWithTag(9) as! UIButton

            if indexPath.section == 0 {
                
                button.isHidden = false
                smallButton.isHidden = false
                mediumButton.isHidden = false
                largeButton.isHidden = false
                
                allButton.isHidden = true
                emojiButton.isHidden = true
                partsButton.isHidden = true
                accessoriesButton.isHidden = true
                textButton.isHidden = true
                
                if (editingCustomStickers == true) {
                    
                    button.setImage(UIImage(named:"Done"), for: UIControlState.normal)
                } else {
                    button.setImage(UIImage(named:"Delete"), for: UIControlState.normal)
                }

            } else {
                button.isHidden = true
                smallButton.isHidden = true
                mediumButton.isHidden = true
                largeButton.isHidden = true
                
                allButton.isHidden = false
                emojiButton.isHidden = false
                partsButton.isHidden = false
                accessoriesButton.isHidden = false
                textButton.isHidden = false
            }
            
            return headerView
            
        default:
            return UICollectionReusableView()
        }
    }
    
//    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
//        
//        switch kind {
//            
//        case UICollectionElementKindSectionHeader:
//            
//            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Header", forIndexPath: indexPath) as! UICollectionReusableView
//
//            headerView.backgroundColor = UIColor.blueColor();
//            return headerView
//            
//        case UICollectionElementKindSectionFooter:
//            let footerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Footer", forIndexPath: indexPath) as! UICollectionReusableView
//            
//            footerView.backgroundColor = UIColor.greenColor();
//            return footerView
//            
//        default:
//            
//            assert(false, "Unexpected element kind")
//        }
//    }
}

extension MonsterBrowserViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch viewingCellSize {
        case .small:
            return CGSize(width: view.frame.size.width / 5, height: view.frame.size.width / 5)
        case .medium:
            return CGSize(width: view.frame.size.width / 4, height: view.frame.size.width / 4)
        case .large:
            return CGSize(width: view.frame.size.width / 3, height: view.frame.size.width / 3)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 48.0)
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
