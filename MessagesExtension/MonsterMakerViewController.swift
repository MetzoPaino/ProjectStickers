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
    @IBOutlet weak var tutorialContainerView: UIView!
    @IBOutlet weak var tutorialContainerViewTopLayoutConstraint: NSLayoutConstraint!
    


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
    
    @IBOutlet weak var undoButtonWidthConstraint: NSLayoutConstraint!
    
    weak var delegate: MonsterMakerViewControllerDelegate?
    
    var longGesture = UILongPressGestureRecognizer()
    var pinchGesture = UIPinchGestureRecognizer()
    var rotationGesture = UIRotationGestureRecognizer()
    
    var showingMonsterParts = monsterParts.heads
    
    var currentSelectedIndexPath: IndexPath?
    


    
    var movingImage: UIImageView?
    var moving = false
    
    var createdImage = [UIImageView]()
    
    
    var imagesOnCanvasArray = [UIImageView]()
    
    var tryingToMoveOldImage = false
    
    // MARK: - Set up ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //canvasImageView.backgroundColor = .clear
        styleView()
        
        longGesture = UILongPressGestureRecognizer(target: self, action: #selector(MonsterMakerViewController.handleLongPress(_:)))
        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(MonsterMakerViewController.handlePinch(recognizer:)))
        rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(MonsterMakerViewController.handleRotation(recognizer:)))
        
        longGesture.delegate = self
        //pinchGesture.delegate = self // Perhaps this will solve the occasional grabbing of collectionView?
        rotationGesture.delegate = self

        self.view.addGestureRecognizer(longGesture)
        self.view.addGestureRecognizer(pinchGesture)
        self.view.addGestureRecognizer(rotationGesture)

        longGesture.minimumPressDuration = 0.25
    }
    
    func colorAtPoint(point:CGPoint, imageView:UIImageView) -> UIColor
    {
        let pixels = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: pixels, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        context!.translateBy(x: -point.x, y: -point.y)
        
        imageView.layer.render(in: context!)
        
        
        let color:UIColor = UIColor(red: CGFloat(pixels[0])/255.0, green: CGFloat(pixels[1])/255.0, blue: CGFloat(pixels[2])/255.0, alpha: CGFloat(pixels[3])/255.0)
        
        pixels.deallocate(capacity: 4)
        
        return color
    }
    
    // MARK: - Style ViewController

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
    
    func handlePinch(recognizer: UIPinchGestureRecognizer) {
        
        if let movingImage = movingImage {
            movingImage.transform = movingImage.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
            recognizer.scale = 1
        }

    }

    func handleRotation(recognizer: UIRotationGestureRecognizer) {
        
        if let movingImage = movingImage {
            movingImage.transform = movingImage.transform.rotated(by: recognizer.rotation)
            recognizer.rotation = 0
        }
    }

    func handleLongPress(_ sender: UILongPressGestureRecognizer) {
        
        let collectionViewLocationPoint = sender.location(in: collectionView)
        let viewLocationPoint = sender.location(in: view)
        let canvasLocationPoint = sender.location(in: canvasImageView)
        
        let offsetedViewLocationPoint = CGPoint(x: viewLocationPoint.x, y: viewLocationPoint.y - 40)
        let offsetedCanvasLocationPoint = CGPoint(x: canvasLocationPoint.x, y: canvasLocationPoint.y - 40)
        
        if sender.state == .began {
            
            // Check if user is moving an already placed image
            
            for image in canvasImageView.subviews.reversed() {
                
                if image is UIImageView {
                    
                    let imageLocationPoint = sender.location(in: image)
                    
                    if image.point(inside: imageLocationPoint, with: nil) {
                        
                        // Need to construct own clear as Apple clear color is different colorModel
                        let color = colorAtPoint(point: imageLocationPoint, imageView: image as! UIImageView)
                        let clearColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)

                        if color == clearColor {
                            tryingToMoveOldImage = false
                            
                        } else {
                            tryingToMoveOldImage = true
                            canvasImageView.bringSubview(toFront: image)
                            movingImage = image as? UIImageView
                            return
                        }
                        
                    }  else {
                        tryingToMoveOldImage = false
                    }
                }
            }
        
            // Check if user is moving collectionView part
            
            guard let selectedIndexPath = collectionView.indexPathForItem(at: collectionViewLocationPoint),
                let cell = collectionView.cellForItem(at: selectedIndexPath) else {
                    moving = false
                    collectionView.isUserInteractionEnabled = true
                    return
            }
            
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.prepare()
            generator.impactOccurred()
            
            startingGesturePoint = viewLocationPoint
            moving = true
            collectionView.isUserInteractionEnabled = false
            
            let imageView = cell.viewWithTag(1) as! UIImageView
            
            movingImage = UIImageView(image: imageView.image)
            
            if let movingImage = movingImage {

                movingImage.image = getHDImage(index: selectedIndexPath.row)
                
                movingImage.alpha = 0.0
                movingImage.frame = cell.frame
                movingImage.center = viewLocationPoint
                view.addSubview(movingImage)
                
                UIView.animate(withDuration: 0.1, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                    self.movingImage?.center = offsetedViewLocationPoint
                })
                
                movingImage.alpha = 1.0
                
                imageView.alpha = 0.0
                movingImage.backgroundColor = UIColor.clear
                currentSelectedIndexPath = selectedIndexPath
                
                undoButtonWidthConstraint.constant = 36 / 2
                
                UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions(), animations: { () -> Void in
                    
                    self.view.layoutIfNeeded()
                    self.undoButton.isEnabled = false
                    self.doneButton.isEnabled = false
                    self.closeButton.isEnabled = false
                    
                }, completion: nil)
            }

        } else if sender.state == .changed {
            
            if let movingImage = movingImage {
                
                if tryingToMoveOldImage == true {
                    movingImage.center = canvasLocationPoint

                } else {
                    movingImage.center = offsetedViewLocationPoint

                }
            }

        } else if sender.state == .ended {
            
            if tryingToMoveOldImage == true {
                movingImage = nil
                return
            }
            
            sender.isEnabled = true
            //collectionView.reloadData()
            collectionView.isUserInteractionEnabled = true
            
            undoButtonWidthConstraint.constant = 36
            
            UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions(), animations: { () -> Void in
                
                self.view.layoutIfNeeded()
                self.undoButton.isEnabled = true
                self.doneButton.isEnabled = true
                self.closeButton.isEnabled = true
                
            }, completion: nil)
            
            if let movingImage = movingImage {
                
                if canvasImageView.point(inside: offsetedCanvasLocationPoint, with: nil)  {
                    
                    canvasImageView.addSubview(movingImage)
                    movingImage.center = offsetedCanvasLocationPoint
                    
                    createdImage.append(movingImage)
                    self.collectionView.reloadData()

                } else {
                    
                    if let startingGesturePoint = startingGesturePoint {
                        
                        UIView.animate(withDuration: 0.1, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                            
                            movingImage.center = startingGesturePoint
                            
                        }, completion: { complete in
                            movingImage.removeFromSuperview()
                            self.startingGesturePoint = nil
                            self.collectionView.reloadData()
                        })
                        
                    } else {
                        
                        movingImage.removeFromSuperview()
                    }
                }
            }

            movingImage = nil
            updateButtonStates()
            //movingImage.removeFromSuperview()
            moving = false
            currentSelectedIndexPath = nil
            //collectionView.reloadData()
        }
    }
    
    func captureMovingImage() -> UIImageView {
        
        var image = UIImageView()

        if let movingImage = movingImage {

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
        }
        

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
    
    func getHDImage(index: Int) -> UIImage {
        
        switch showingMonsterParts {
        case .heads:
            return StickerManager().createHeadArray()[index]
        case .eyes:
            return StickerManager().createEyeArray(optimised: false)[index]
        case .mouths:
            return StickerManager().createMouthArray(optimised: false)[index]
        case .accessories:
            return StickerManager().createAccessoriesArray()[index]
        case .text:
            return StickerManager().createTextArray()[index]
        }
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
        
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
        
        collectionView.reloadData()
        collectionView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.success)
        
        let image = createImageFrom(view: canvasImageView)
        delegate?.createdImage(image: image)
    }
    
    @IBAction func undoButtonPressed(_ sender: UIButton) {
        
        if let image = createdImage.last {
            createdImage.removeLast()
            image.removeFromSuperview()
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.prepare()
            generator.impactOccurred()
        }
        updateButtonStates()
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.warning)
        delegate?.cancelButtonPressed()
    }
    
    @IBAction func tutorialButtonPressed(_ sender: UIButton) {
        
        view.bringSubview(toFront: tutorialContainerView)
    }
}

// MARK: - UICollectionViewDelegate

extension MonsterMakerViewController: UICollectionViewDelegate {
    //    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
}

// MARK: - UICollectionViewDataSource

extension MonsterMakerViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch showingMonsterParts {
        case .heads:
            return StickerManager().createHeadArray().count
        case .eyes:
            return StickerManager().createEyeArray(optimised: true).count
        case .mouths:
            return StickerManager().createMouthArray(optimised: true).count
        case .accessories:
            return StickerManager().createAccessoriesArray().count
        case .text:
            return StickerManager().createTextArray().count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! MonsterPartCollectionViewCell
        
        var image: UIImage
        var currentlySelected: Bool
        
        switch showingMonsterParts {
        case .heads:
            image = StickerManager().createHeadArray()[indexPath.row]
        case .eyes:
            image = StickerManager().createEyeArray(optimised: true)[indexPath.row]
        case .mouths:
            image = StickerManager().createMouthArray(optimised: true)[indexPath.row]
        case .accessories:
            image = StickerManager().createAccessoriesArray()[indexPath.row]
        case .text:
            image = StickerManager().createTextArray()[indexPath.row]
        }
        
        if currentSelectedIndexPath == indexPath {
            currentlySelected = true
        } else {
            currentlySelected = false
        }
        
        cell.configureCell(image: image, currentlySelected: currentlySelected)
        cell.tag = indexPath.row * 10

        return cell
    }
}

extension MonsterMakerViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var division = 3.0 as CGFloat
        
        switch showingMonsterParts {
        case .heads, .accessories, .text:
            division = 3.0
        case .eyes, .mouths:
            division = 4.0
        }
        
        let horizontalClass = self.traitCollection.horizontalSizeClass;
        let verticalClass = self.traitCollection.verticalSizeClass;
        
        if horizontalClass == UIUserInterfaceSizeClass.regular && verticalClass == UIUserInterfaceSizeClass.regular {
            
            division = division + 1.0
        }
        
        return CGSize(width: view.frame.size.width / division, height: view.frame.size.width / division)
    }
}

