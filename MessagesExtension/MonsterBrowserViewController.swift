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

class MonsterBrowserViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var collectionViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionViewTopLayoutConstraint: NSLayoutConstraint!
    
//    var collectionViewTopConstraintCopy = NSLayoutConstraint()
//    var collectionViewTopLayoutConstraintCopy = NSLayoutConstraint()

    weak var delegate: MonsterBrowserViewControllerDelegate?
    var stickerManager: StickerManager! = nil
    var editingCustomStickers = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        collectionViewTopConstraintCopy = collectionViewTopConstraint
//        collectionViewTopLayoutConstraintCopy = collectionViewTopLayoutConstraint

        styleView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
    }
    
    func styleView() {
        collectionView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
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
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1 + stickerManager.customStickers.count
        } else {
            return stickerManager.stickers.count
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
            stickerView.sticker = stickerManager.stickers[indexPath.row]
            
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
            
            if indexPath.section == 0 {
                button.isHidden = false

            } else {
                button.isHidden = true
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
        return CGSize(width: view.frame.size.width / 4, height: view.frame.size.width / 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 20.0)
    }
    
    //3
//    func collectionView(collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
//        return sectionInsets
//    }
}
