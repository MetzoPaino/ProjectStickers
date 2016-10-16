//
//  StickerManager.swift
//  StickerTest
//
//  Created by William Robinson on 25/09/2016.
//  Copyright © 2016 William Robinson. All rights reserved.
//

import Foundation
import Messages

enum StickerCreationError: Error {
    case noPath
    case noFileAtPath
}

class StickerManager: NSObject, NSCoding {
    
    fileprivate let customStickerFileURLSKey = "customStickerFileURLS"

    var stickers = [MSSticker]()
    var customStickers = [MSSticker]()
    var customStickerFileURLS = [URL]()

    override init() {
        super.init()
        //loadStickers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        if let decodedcustomStickerFileURLS = aDecoder.decodeObject(forKey: customStickerFileURLSKey) as? [URL] {
            
            customStickerFileURLS = decodedcustomStickerFileURLS
        }
        
       // loadStickers()
        
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(customStickerFileURLS, forKey: customStickerFileURLSKey)
    }
    
    // MARK: - Sticker Arrays
    
    func createAllStickerArray(animated: Bool) -> [MSSticker] {
                
        let emojiArray = createEmojiStickerArray(animated: animated)
        let headArray = createHeadStickerArray()
        let eyeArray = createEyeStickerArray()
        let mouthArray = createMouthStickerArray()
        let accessoriesArray = createAccessoriesStickerArray()
        let textArray = createTextStickerArray()
        
        var allArray = [MSSticker]()
        allArray.append(contentsOf: emojiArray)
        allArray.append(contentsOf: headArray)
        allArray.append(contentsOf: eyeArray)
        allArray.append(contentsOf: mouthArray)
        allArray.append(contentsOf: accessoriesArray)
        allArray.append(contentsOf: textArray)
        
        return allArray
    }
    
    func createEmojiStickerArray(animated: Bool) -> [MSSticker] {
        
        let vampArray = createAnimatedStickerArray(animated: animated, fileName: "Vamp")
        let skullArray = createAnimatedStickerArray(animated: animated, fileName: "Skull")
        let swampArray = createAnimatedStickerArray(animated: animated, fileName: "Swamp")
        let wolfArray = createAnimatedStickerArray(animated: animated, fileName: "Wolf")
        let medusaArray = createAnimatedStickerArray(animated: animated, fileName: "Snake")
        
        return vampArray + skullArray + swampArray + wolfArray + medusaArray
    }
    
    func createPartStickerArray() -> [MSSticker] {
        
        let headArray = createAnimatedStickerArray(animated: false, fileName: "Head")
        let eyeArray = createAnimatedStickerArray(animated: false, fileName: "Eye")
        let mouthArray = createAnimatedStickerArray(animated: false, fileName: "Mouth")
        
        return headArray + eyeArray + mouthArray
    }
    
    func createHeadStickerArray() -> [MSSticker] {
        
        return createAnimatedStickerArray(animated: false, fileName: "Head")
    }
    
    func createEyeStickerArray() -> [MSSticker] {
        
        return createAnimatedStickerArray(animated: false, fileName: "Eye")
    }
    
    func createMouthStickerArray() -> [MSSticker] {
        
        return createAnimatedStickerArray(animated: false, fileName: "Mouth")
    }
    
    func createAccessoriesStickerArray() -> [MSSticker] {
        
        return createAnimatedStickerArray(animated: false, fileName: "Accessories")
    }
    
    func createTextStickerArray() -> [MSSticker] {
        
        return createAnimatedStickerArray(animated: false, fileName: "Text")
    }
    
    // MARK: - UIImage Arrays
    
    func createAllArray() -> [UIImage] {
        
        let emojiArray = createEmojiArray()
        let headArray = createArray(fileName: "Head")
        let eyeArray = createArray(fileName: "Eye")
        let mouthArray = createArray(fileName: "Mouth")
        let accessoriesArray = createArray(fileName: "Accessories")
        let textArray = createArray(fileName: "Text")
        
        return emojiArray + headArray + eyeArray + mouthArray + accessoriesArray + textArray
    }
    
    func createEmojiArray() -> [UIImage] {
        
        let vampArray = createArray(fileName: "Vamp")
        let skullArray = createArray(fileName: "Skull")
        let swampArray = createArray(fileName: "Swamp")
        let wolfArray = createArray(fileName: "Wolf")
        let medusaArray = createArray(fileName: "Snake")
        
        return vampArray + skullArray + swampArray + wolfArray + medusaArray
    }
    
    func createPartArray() -> [UIImage] {
        
        let headArray = createArray(fileName: "Head")
        let eyeArray = createArray(fileName: "Eye")
        let mouthArray = createArray(fileName: "Mouth")
        
        return headArray + eyeArray + mouthArray
    }

    func createHeadArray() -> [UIImage] {
        
        return createArray(fileName: "Head")
    }

    func createEyeArray() -> [UIImage] {
        
        return createArray(fileName: "Eye")
    }
    
    func createMouthArray() -> [UIImage] {
        
        return createArray(fileName: "Mouth")
    }
    
    func createAccessoriesArray() -> [UIImage] {
        
        return createArray(fileName: "Accessories")
    }
    
    func createTextArray() -> [UIImage] {
        
        return createArray(fileName: "Text")
    }
    
    
    func loadStickers() {
        
        stickers.removeAll()
        
        createStickerOld(asset: "Vamp0", localizedDescription: "Vampire")
        createStickerOld(asset: "Snake0", localizedDescription: "Medusa")
        createStickerOld(asset: "Skull0", localizedDescription: "Skull")
        createStickerOld(asset: "Swamp0", localizedDescription: "Swamp")
        createStickerOld(asset: "Wolf0", localizedDescription: "Wolf")
        createStickerOld(asset: "Skull2", localizedDescription: "Skull")

        createStickerOld(asset: "Vamp1", localizedDescription: "Vampire")
        createStickerOld(asset: "Wolf1", localizedDescription: "Wolf")
        createStickerOld(asset: "Skull1", localizedDescription: "Skull")
        createStickerOld(asset: "Vamp5", localizedDescription: "Vampire")

        createStickerOld(asset: "Swamp1", localizedDescription: "Swamp")
        createStickerOld(asset: "Wolf4", localizedDescription: "Wolf")
        createStickerOld(asset: "Skull3", localizedDescription: "Skull")

        createStickerOld(asset: "Wolf2", localizedDescription: "Wolf")
        createStickerOld(asset: "Snake2", localizedDescription: "Medusa")
        createStickerOld(asset: "Swamp3", localizedDescription: "Swamp")
        createStickerOld(asset: "Vamp2", localizedDescription: "Vampire")

        createStickerOld(asset: "Swamp2", localizedDescription: "Swamp")
        createStickerOld(asset: "Vamp4", localizedDescription: "Vampire")
        createStickerOld(asset: "Snake1", localizedDescription: "Medusa")
        createStickerOld(asset: "Wolf5", localizedDescription: "Wolf")
        createStickerOld(asset: "Skull4", localizedDescription: "Skull")

        createStickerOld(asset: "Vamp3", localizedDescription: "Vampire")
        createStickerOld(asset: "Wolf3", localizedDescription: "Wolf")
        createStickerOld(asset: "Snake3", localizedDescription: "Medusa")
        
        createStickerOld(asset: "Snake4", localizedDescription: "Medusa")
        createStickerOld(asset: "Swamp4", localizedDescription: "Swamp")
        
        createStickerOld(asset: "Snake5", localizedDescription: "Medusa")
        createStickerOld(asset: "Skull5", localizedDescription: "Skull")
        createStickerOld(asset: "Swamp5", localizedDescription: "Swamp")

    }
    
    func loadCustomStickers() {
        
        for url in customStickerFileURLS {
            
            createCustomSticker(fileURL: url)
        }
    }
    
    func createStickerOld(asset: String, localizedDescription: String) {
        
        guard let stickerPath = Bundle.main.path(forResource: asset, ofType:"png") else {
            
            print("Couldn't create the sticker path for", asset)
            return
        }
        let stickerURL = URL(fileURLWithPath: stickerPath)
        
        let sticker: MSSticker
        
        do {
            
            try sticker = MSSticker(contentsOfFileURL: stickerURL, localizedDescription: localizedDescription)
            stickers.append(sticker)
        } catch {
            
            print(error)
            return
        }
    }
    
    func createStickerGif(asset: String, localizedDescription: String) throws -> MSSticker {
        
        guard let stickerPath = Bundle.main.path(forResource: asset, ofType:"gif") else {
            
            //print("Couldn't create the sticker path for", asset)
            throw StickerCreationError.noPath
        }
        let stickerURL = URL(fileURLWithPath: stickerPath)
        let sticker: MSSticker
        
        do {
            
            try sticker = MSSticker(contentsOfFileURL: stickerURL, localizedDescription: localizedDescription)
            return sticker
            
        } catch {
            
            print(error)
            throw StickerCreationError.noFileAtPath
        }
    }
    
    func createSticker(asset: String, localizedDescription: String) throws -> MSSticker {
        
        guard let stickerPath = Bundle.main.path(forResource: asset, ofType:"png") else {
            
            //print("Couldn't create the sticker path for", asset)
            throw StickerCreationError.noPath
        }
        
        let stickerURL = URL(fileURLWithPath: stickerPath)
        let sticker: MSSticker
        
        do {
            
            try sticker = MSSticker(contentsOfFileURL: stickerURL, localizedDescription: localizedDescription)
            return sticker
            
        } catch {
            print(error)
            throw StickerCreationError.noFileAtPath
        }
    }
    
    func createCustomSticker(fileURL: URL) {
        
        let sticker: MSSticker
        
        do {
            
            try sticker = MSSticker(contentsOfFileURL: fileURL, localizedDescription: "Custom")
            customStickers.append(sticker)
            
        } catch {
            
            print(error)
            return
        }
    }
    
    func createArray(fileName: String) -> [UIImage] {
        
        var index = 0
        var foundImage = false
        var array = [UIImage]()
        
        repeat {
            
            let fileName = fileName + String(index)
            
            if let image = UIImage(named: fileName) {
                
                foundImage = true
                array.append(image)
                
            } else {
                
                foundImage = false
            }
            
            index = index + 1
            
        } while foundImage == true
        
        return array
    }
    
    func createStickerArray(fileName: String) -> [MSSticker] {
        
        var index = 0
        var foundImage = false
        var array = [MSSticker]()
        
        repeat {
            
            let fileName = fileName + String(index)
            
            do {
                let sticker = try createSticker(asset: fileName, localizedDescription: fileName)
                array.append(sticker)
                foundImage = true

            } catch {
                foundImage = false
            }
            
            index = index + 1
            
        } while foundImage == true
        
        return array
    }
    
    func createAnimatedStickerArray(animated: Bool, fileName: String) -> [MSSticker] {
        
        var index = 0
        var foundImage = false
        var array = [MSSticker]()
        
        repeat {
            
            let animatedFileName = fileName + "Animated" + String(index)
            let gifFileName = fileName + "Gif" + String(index)

            let fileName = fileName + String(index)
            
            if animated == true {
                
                do {
                    let sticker = try createSticker(asset: animatedFileName, localizedDescription: NSLocalizedString(fileName, comment: fileName))
                    
                    array.append(sticker)
                    foundImage = true
                    
                } catch {
                    
                    do {
                        let sticker = try createStickerGif(asset: gifFileName, localizedDescription: NSLocalizedString(fileName, comment: fileName))
                        array.append(sticker)
                        foundImage = true
                        
                    } catch {
                        
                        do {
                            let sticker = try createSticker(asset: fileName, localizedDescription: NSLocalizedString(fileName, comment: fileName))
                            array.append(sticker)
                            foundImage = true
                            
                        } catch {
                            foundImage = false
                        }
                    }
                }
                
            } else {
                
                do {
                    let sticker = try createSticker(asset: fileName, localizedDescription: fileName)
                    array.append(sticker)
                    foundImage = true
                    
                } catch {
                    foundImage = false
                }
            }
            
            index = index + 1
            
        } while foundImage == true
        
        return array
    }
   
//    var index = 0
//    var foundImage = false
//
//    repeat {
//    
//    let fileName = "SortingAnimation_" + String(index)
//    if let image = UIImage(named: fileName) {
//    
//    foundImage = true
//    
//    animationArray.append(image.cgImage!)
//    } else {
//    
//    foundImage = false
//
//    }
//    
//    //            if image != nil {
//    //                foundImage = true
//    //
//    //                animationArray.append(image!.CGImage!)
//    //            } else {
//    //                foundImage = false
//    //            }
//    index = index + 1
//    
//    } while foundImage
//    
    
//        //http://stackoverflow.com/questions/25100262/save-data-to-plist-file-in-swift
}
