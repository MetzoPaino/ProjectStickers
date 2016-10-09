//
//  MonsterMakerViewController.swift
//  StickerTest
//
//  Created by William Robinson on 24/09/2016.
//  Copyright © 2016 William Robinson. All rights reserved.
//

import UIKit
import QuartzCore

protocol MonsterMakerViewControllerDelegate: class {
    func createdImage(image: UIImage)
    func cancelButtonPressed()
}

enum monsterParts {
    case heads
    case mouths
    case eyes
    case text
    case accessories
}

class MonsterMakerViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    var panGesture = UIPanGestureRecognizer()
    var longGesture = UILongPressGestureRecognizer()
    var pinchGesture = UIPinchGestureRecognizer()
    var rotationGesture = UIRotationGestureRecognizer()

    var startingGesturePoint: CGPoint?
    
    
    @IBOutlet weak var canvasImageView: UIImageView!
    @IBOutlet weak var shadowImageView: UIImageView!


    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var headsButton: UIButton!
    @IBOutlet weak var eyesButton: UIButton!
    @IBOutlet weak var mouthsButton: UIButton!
    @IBOutlet weak var accessoriesButton: UIButton!
    @IBOutlet weak var textButton: UIButton!
    
    @IBOutlet weak var doneButtonWidthConstraint: NSLayoutConstraint!
    
    weak var delegate: MonsterMakerViewControllerDelegate?
    
    var showingMonsterParts = monsterParts.heads
    
    var currentSelectedIndexPath: IndexPath?
    
    var images = [UIImage(named:"Boo"), UIImage(named:"Eyeball"), UIImage(named:"HappyHalloween"), UIImage(named:"KeepingItSpooky"), UIImage(named:"Mask"), UIImage(named:"Medusa0"), UIImage(named:"SkullKid0"), UIImage(named:"Swamp0"), UIImage(named:"Vamp0"), UIImage(named:"Wolf0"), UIImage(named:"Medusa1"), UIImage(named:"SkullKid1"), UIImage(named:"Swamp1"), UIImage(named:"Vamp1"), UIImage(named:"Wolf1"), ]

    
    var movingImage = UIImageView()
    var moving = false
    
    var createdImage = [UIImageView]()
    
    
    var imagesOnCanvasArray = [UIImageView]()
    
    var tryingToMoveOldImage = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //canvasImageView.backgroundColor = .clear
        styleView()
        
        longGesture = UILongPressGestureRecognizer(target: self, action: #selector(MonsterMakerViewController.handleLongPress(_:)))
        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(MonsterMakerViewController.handlePinch(recognizer:)))
        rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(MonsterMakerViewController.handleRotation(recognizer:)))
        
        longGesture.delegate = self
        //pinchGesture.delegate = self
        rotationGesture.delegate = self

        self.view.addGestureRecognizer(longGesture)
        self.view.addGestureRecognizer(pinchGesture)
        self.view.addGestureRecognizer(rotationGesture)

        longGesture.minimumPressDuration = 0.25
    }
    
    func styleView() {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
        
        canvasImageView.isOpaque = false
        canvasImageView.layer.isOpaque = false
        canvasImageView.isUserInteractionEnabled = false
        canvasImageView.clipsToBounds = true
        
        shadowImageView.layer.shadowColor = UIColor.black.cgColor
        shadowImageView.layer.shadowOpacity = 0.25
        //shadowImageView.layer.shadowOffset = CGSize.zero
        shadowImageView.layer.shadowOffset = CGSize(width: 0, height: -16)
        shadowImageView.layer.shadowRadius = 4
        //shadowImageView.layer.shouldRasterize = true
        
        headsButton.setImage(UIImage(named:"Emoji"), for: UIControlState.normal)
        headsButton.setImage(UIImage(named:"Emoji")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.highlighted)
        headsButton.setImage(UIImage(named:"Emoji")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.selected)
        headsButton.tintColor = .white
        
        eyesButton.setImage(UIImage(named:"Eye"), for: UIControlState.normal)
        eyesButton.setImage(UIImage(named:"Eye")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.highlighted)
        eyesButton.setImage(UIImage(named:"Eye")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.selected)
        eyesButton.tintColor = .white
        
        mouthsButton.setImage(UIImage(named:"Mouth"), for: UIControlState.normal)
        mouthsButton.setImage(UIImage(named:"Mouth")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.highlighted)
        mouthsButton.setImage(UIImage(named:"Mouth")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.selected)
        mouthsButton.tintColor = .white
        
        accessoriesButton.setImage(UIImage(named:"Accessories"), for: UIControlState.normal)
        accessoriesButton.setImage(UIImage(named:"Accessories")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.highlighted)
        accessoriesButton.setImage(UIImage(named:"Accessories")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.selected)
        accessoriesButton.tintColor = .white
        
        textButton.setImage(UIImage(named:"Text"), for: UIControlState.normal)
        textButton.setImage(UIImage(named:"Text")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.highlighted)
        textButton.setImage(UIImage(named:"Text")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.selected)
        textButton.tintColor = .white
        
        headsButton.isSelected = true
        
        doneButton.setImage(UIImage(named:"Done"), for: UIControlState.normal)
        doneButton.setImage(UIImage(named:"DoneInvert"), for: UIControlState.highlighted)
        doneButton.setImage(UIImage(named:"DoneInvert"), for: UIControlState.selected)
        doneButton.setImage(UIImage(named:"DoneDisabled"), for: UIControlState.disabled)

        undoButton.setImage(UIImage(named:"Undo"), for: UIControlState.normal)
        undoButton.setImage(UIImage(named:"UndoInvert"), for: UIControlState.highlighted)
        undoButton.setImage(UIImage(named:"UndoInvert"), for: UIControlState.selected)
        undoButton.setImage(UIImage(named:"UndoDisabled"), for: UIControlState.disabled)

        closeButton.setImage(UIImage(named:"Delete"), for: UIControlState.normal)
        closeButton.setImage(UIImage(named:"DeleteInvert"), for: UIControlState.highlighted)
        closeButton.setImage(UIImage(named:"DeleteInvert"), for: UIControlState.selected)
        closeButton.setImage(UIImage(named:"DeleteDisabled"), for: UIControlState.disabled)

        updateButtonStates()
    }
    
    func updateButtonStates() {
        
        if createdImage.count > 0 {
            
            undoButton.isEnabled = true
            doneButton.isEnabled = true
            
        } else {
            
            undoButton.isEnabled = false
            doneButton.isEnabled = false
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {

//        var gesture = ""
//        var otherGesture = ""
//
//        if gestureRecognizer == longGesture {
//            
//            gesture = "Long Gesture"
//            
//        } else if gestureRecognizer == pinchGesture {
//            
//            gesture = "Pinch Gesture"
//            
//        }  else if gestureRecognizer == rotationGesture {
//            
//            gesture = "Rotation Gesture"
//        }
//        
//        if otherGestureRecognizer == longGesture {
//            
//            otherGesture = "Long Gesture"
//            
//        } else if otherGestureRecognizer == pinchGesture {
//            
//            otherGesture = "Pinch Gesture"
//            
//        }  else if otherGestureRecognizer == rotationGesture {
//            
//            otherGesture = "Rotation Gesture"
//        }
//        
        //print("We have \(gesture) with \(otherGesture)")
        
        if moving == false {
            return true
            
        } else {
            
            if gestureRecognizer == longGesture && otherGestureRecognizer == pinchGesture || gestureRecognizer == pinchGesture && otherGestureRecognizer == longGesture || gestureRecognizer == longGesture && otherGestureRecognizer == rotationGesture {
                
                return true
                
            } else if gestureRecognizer == rotationGesture && otherGestureRecognizer == pinchGesture || gestureRecognizer == rotationGesture && otherGestureRecognizer == longGesture {
                
                return true
                
            } else if gestureRecognizer == rotationGesture {
                
                return true
                
            }  else if gestureRecognizer == pinchGesture {
                
                return true
                
            } else {
                
                return false
            }
        }
    }
    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {}
    
    // MARK: - Gestures
    
    func handlePan(_ sender: UIPanGestureRecognizer) {
        
//        let windowLocationPoint = sender.location(in: nil)
//        
//        if sender.state == .changed {
//            
//            let image = sender.view!
//            image.center = windowLocationPoint
//        }
    }
    
    func handlePinch(recognizer: UIPinchGestureRecognizer) {
        
        movingImage.transform = movingImage.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
        recognizer.scale = 1
        
        //print("Pinch!")

//        var scale = sender.scale
//        
//        if scale > 5.0 {
//            scale = 5.0
//        }
//        
//        if scale < 0.25 {
//            scale = 0.25
//        }
//        
//        movingImage.transform = CGAffineTransform(scaleX: scale, y: scale)
//        
//        if (sender.state == .ended) {
//            
//           // movingImage.bounds = movingImage.frame
//        }
    }

    func handleRotation(recognizer: UIRotationGestureRecognizer) {
        
        movingImage.transform = movingImage.transform.rotated(by: recognizer.rotation)
        recognizer.rotation = 0
//        print("Rotation!")
//        movingImage.transform = CGAffineTransform(rotationAngle: sender.rotation)
//        
//        if (sender.state == .ended) {
//            
//            movingImage.bounds = movingImage.frame
//        }
    }

    
    func handleLongPress(_ sender: UILongPressGestureRecognizer) {
        
        let locationPoint = sender.location(in: collectionView)
        //let windowLocationPoint = sender.location(in: nil) This broke on landscape
        let viewLocationPoint = sender.location(in: view)
        let canvasLocationPoint = sender.location(in: canvasImageView)
        
        let offsetedViewLocationPoint = CGPoint(x: viewLocationPoint.x, y: viewLocationPoint.y - 40)
        let offsetedCanvasLocationPoint = CGPoint(x: canvasLocationPoint.x, y: canvasLocationPoint.y - 40)
        
        if sender.state == .began {
            
            if canvasImageView.point(inside: canvasLocationPoint, with: nil)  {
                // This is to stop moving already placed views
                tryingToMoveOldImage = true
                return
            } else {
                tryingToMoveOldImage = false
            }
            
            guard let selectedIndexPath = collectionView.indexPathForItem(at: locationPoint),
                let cell = collectionView.cellForItem(at: selectedIndexPath) else {
                    moving = false
                    collectionView.isUserInteractionEnabled = true
                    
                    return
            }
            
            startingGesturePoint = viewLocationPoint
            moving = true
            collectionView.isUserInteractionEnabled = false
            
            let imageView = cell.viewWithTag(1) as! UIImageView
            
            movingImage = UIImageView(image: imageView.image)
            movingImage.alpha = 0.0
            movingImage.frame = cell.frame
            movingImage.center = viewLocationPoint   
            view.addSubview(movingImage)
        
            UIView.animate(withDuration: 0.1, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                self.movingImage.center = offsetedViewLocationPoint
            })

            movingImage.alpha = 1.0
            
            imageView.alpha = 0.0
            currentSelectedIndexPath = selectedIndexPath
            
            
            doneButtonWidthConstraint.constant = 36 / 2
            
            UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions(), animations: { () -> Void in
                
                self.view.layoutIfNeeded()
                
            }, completion: nil)

        } else if sender.state == .changed {
            
            if tryingToMoveOldImage == false {
                movingImage.center = offsetedViewLocationPoint
            }


        } else if sender.state == .ended {
            
            if tryingToMoveOldImage == true {
                return
            }
            
            sender.isEnabled = true
            //collectionView.reloadData()
            collectionView.isUserInteractionEnabled = true
            
            doneButtonWidthConstraint.constant = 36
            
            UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions(), animations: { () -> Void in
                
                self.view.layoutIfNeeded()
                
            }, completion: nil)
            
            //let image = self.captureMovingImage()

//            canvasImageView.addSubview(movingImage)
//            movingImage.center = canvasLocationPoint
            
            
            if canvasImageView.point(inside: offsetedCanvasLocationPoint, with: nil)  {
                
                canvasImageView.addSubview(movingImage)
                //movingImage.center = canvasLocationPoint
                movingImage.center = offsetedCanvasLocationPoint

                createdImage.append(movingImage)
                self.collectionView.reloadData()
//                canvasImageView.addSubview(image)
//                image.center = canvasLocationPoint
//                createdImage.append(image)
            } else {
                
                if let startingGesturePoint = startingGesturePoint {
                    
                    UIView.animate(withDuration: 0.1, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                        
                        self.movingImage.center = startingGesturePoint
                        
                        }, completion: { complete in
                            self.movingImage.removeFromSuperview()
                            self.startingGesturePoint = nil
                            self.collectionView.reloadData()
                    })
                
                } else {
                    
                    movingImage.removeFromSuperview()
                }


            }
            
            updateButtonStates()
            //movingImage.removeFromSuperview()
            moving = false
            currentSelectedIndexPath = nil
            //collectionView.reloadData()
        }
    }
    
    func captureMovingImage() -> UIImageView {
        
        var image = UIImageView()
        UIGraphicsBeginImageContextWithOptions(movingImage.bounds.size, movingImage.isOpaque, 0.0)
        
        print("movingImage Center = x: \(movingImage.bounds.size.width / 2), y: \(movingImage.bounds.size.height / 2)")
        
        if let context = UIGraphicsGetCurrentContext() {
            
            let zKeyPath = "layer.presentationLayer.transform.rotation.z"
            let imageRotation = (movingImage.value(forKeyPath: zKeyPath) as? NSNumber)?.floatValue ?? 0.0
            
            //                let scale = "layer.presentationLayer.transform.scale"
            //                let imageScale = (movingImage.value(forKeyPath: scale) as? NSNumber)?.floatValue ?? 0.0
            //                let scaleFloat = CGFloat(imageScale)
            
            context.translateBy(x: movingImage.bounds.size.width / 2, y: movingImage.bounds.size.height / 2)
            context.rotate(by: CGFloat(imageRotation))
            //context.scaleBy(x: scaleFloat, y: scaleFloat)
            context.translateBy(x: -movingImage.bounds.size.width / 2, y: -movingImage.bounds.size.height / 2)
        }
        
        movingImage.drawHierarchy(in: movingImage.bounds, afterScreenUpdates: true)
        let capturedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        image = UIImageView(image:capturedImage)
        //image.bounds = movingImage.bounds
        image.frame = movingImage.frame
        return image
    }
    
    func createImageFrom(view: UIView) -> UIImage {
        
        view.backgroundColor = .clear
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let resizedImage = resizeImage(image: image!)
        view.backgroundColor = .white
        return resizedImage
    }
    
    func resizeImage(image: UIImage) -> UIImage {
        
        let stickerSize = CGRect(x: 0, y: 0, width: 618, height: 618)
        UIGraphicsBeginImageContextWithOptions(stickerSize.size, false, 1.0)
        image.draw(in: stickerSize)
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
    
    // MARK: - IBActions
    
    @IBAction func monsterPartButtonPressed(_ sender: UIButton) {
        
        if sender == headsButton {
            showingMonsterParts = .heads
            
            headsButton.isSelected = true
            eyesButton.isSelected = false
            mouthsButton.isSelected = false
            accessoriesButton.isSelected = false
            textButton.isSelected = false
            
        } else if sender == eyesButton {
            showingMonsterParts = .eyes
            
            headsButton.isSelected = false
            eyesButton.isSelected = true
            mouthsButton.isSelected = false
            accessoriesButton.isSelected = false
            textButton.isSelected = false
            
        } else if sender == mouthsButton {
            showingMonsterParts = .mouths
            
            headsButton.isSelected = false
            eyesButton.isSelected = false
            mouthsButton.isSelected = true
            accessoriesButton.isSelected = false
            textButton.isSelected = false
            
        } else if sender == accessoriesButton {
            showingMonsterParts = .accessories
            
            headsButton.isSelected = false
            eyesButton.isSelected = false
            mouthsButton.isSelected = false
            accessoriesButton.isSelected = true
            textButton.isSelected = false
            
        } else if sender == textButton {
            showingMonsterParts = .text
            
            headsButton.isSelected = false
            eyesButton.isSelected = false
            mouthsButton.isSelected = false
            accessoriesButton.isSelected = false
            textButton.isSelected = true
        }
        
        collectionView.reloadData()
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        let image = createImageFrom(view: canvasImageView)
        
        delegate?.createdImage(image: image)
    }
    
    @IBAction func undoButtonPressed(_ sender: UIButton) {
        
        if let image = createdImage.last {
            createdImage.removeLast()
            image.removeFromSuperview()
        }
        updateButtonStates()
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        
        delegate?.cancelButtonPressed()
    }
}

// MARK: - UICollectionViewDelegate

extension MonsterMakerViewController: UICollectionViewDelegate {
    //    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
}

// MARK: - UICollectionViewDataSource

extension MonsterMakerViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if showingMonsterParts == .heads {
            
            return StickerManager().createHeadArray().count
            
        } else if showingMonsterParts == .eyes {
            
            return StickerManager().createEyeArray().count
            
        } else if showingMonsterParts == .mouths {
            
            return StickerManager().createMouthArray().count
            
        } else if showingMonsterParts == .accessories {
        
            return StickerManager().createAccessoriesArray().count
            
        } else if showingMonsterParts == .text {
            
            return StickerManager().createTextArray().count
            
        } else {
            
            return images.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath)
        
        let imageView = cell.viewWithTag(1) as! UIImageView
        
        if currentSelectedIndexPath == indexPath {
          
            imageView.alpha = 0.0
        } else {
            imageView.alpha = 1.0
        }
        
        if showingMonsterParts == .heads {
            
            imageView.image = StickerManager().createHeadArray()[indexPath.row]
            
        } else if showingMonsterParts == .eyes {
            
            imageView.image = StickerManager().createEyeArray()[indexPath.row]
            
        } else if showingMonsterParts == .mouths {
            
            imageView.image = StickerManager().createMouthArray()[indexPath.row]
            
        } else if showingMonsterParts == .accessories {
            
            imageView.image = StickerManager().createAccessoriesArray()[indexPath.row]
            
        } else if showingMonsterParts == .text {
            
            imageView.image = StickerManager().createTextArray()[indexPath.row]
            
        }else {
            
            imageView.image = images[indexPath.row]
        }
        
        
        
        cell.tag = indexPath.row * 10
        
        return cell
    }
}

extension MonsterMakerViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width / 3, height: view.frame.size.width / 3)
    }
}
