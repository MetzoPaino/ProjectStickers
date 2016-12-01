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
        let accessoriesArray = createAccessoriesStickerArray(animated: animated)
        let textArray = createTextStickerArray()
        
        var allArray = [MSSticker]()
        
        let date = DateManager().detectMonth()
        if date == .december {
            let christmasArray = createChristmasStickerArray(animated: animated)
            allArray.append(contentsOf: christmasArray)
        }
        
        allArray.append(contentsOf: emojiArray)
        allArray.append(contentsOf: headArray)
        allArray.append(contentsOf: eyeArray)
        allArray.append(contentsOf: mouthArray)
        allArray.append(contentsOf: accessoriesArray)
        allArray.append(contentsOf: textArray)
        
        return allArray
    }
    
    func createChristmasStickerArray(animated: Bool) -> [MSSticker] {
        
        let christmasArray = createAnimatedStickerArray(animated: animated, fileName: "Christmas")
        
        return christmasArray
    }
    
    func createEmojiStickerArray(animated: Bool) -> [MSSticker] {
        
        let vampArray = createAnimatedStickerArray(animated: animated, fileName: "Vamp")
        let skullArray = createAnimatedStickerArray(animated: animated, fileName: "Skull")
        let swampArray = createAnimatedStickerArray(animated: animated, fileName: "Swamp")
        let wolfArray = createAnimatedStickerArray(animated: animated, fileName: "Wolf")
        let medusaArray = createAnimatedStickerArray(animated: animated, fileName: "Snake")
        let yetiArray = createAnimatedStickerArray(animated: animated, fileName: "Yeti")
        
        let date = DateManager().detectMonth()
        if date == .december {
            let christmasArray = createChristmasStickerArray(animated: animated)

            return christmasArray + yetiArray + vampArray + skullArray + swampArray + wolfArray + medusaArray

        } else {
            return yetiArray + vampArray + skullArray + swampArray + wolfArray + medusaArray
        }
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
    
    func createAccessoriesStickerArray(animated: Bool) -> [MSSticker] {
        
        let date = DateManager().detectMonth()
        if date == .december {
            let christmasArray = createAnimatedStickerArray(animated: animated, fileName: "AccessoriesChristmas")
            let accessoriesArray = createAnimatedStickerArray(animated: animated, fileName: "Accessories")
            
            return christmasArray + accessoriesArray
            
        } else {
            return createAnimatedStickerArray(animated: animated, fileName: "Accessories")
        }
        
    }
    
    func createTextStickerArray() -> [MSSticker] {
        
        let date = DateManager().detectMonth()
        if date == .december {
            let christmasArray = createAnimatedStickerArray(animated: false, fileName: "TextChristmas")
            let textArray = createAnimatedStickerArray(animated: false, fileName: "Text")
            
            return christmasArray + textArray
            
        } else {
            return createAnimatedStickerArray(animated: false, fileName: "Text")
        }
        
    }
    
    // MARK: - UIImage Arrays
    
    func createAllArray() -> [UIImage] {
        
        let emojiArray = createEmojiArray()
        let headArray = createArray(fileName: "Head", optimised: false)
        let eyeArray = createArray(fileName: "Eye", optimised: false)
        let mouthArray = createArray(fileName: "Mouth", optimised: false)
        let accessoriesArray = createArray(fileName: "Accessories", optimised: false)
        let textArray = createArray(fileName: "Text", optimised: false)
        
        return emojiArray + headArray + eyeArray + mouthArray + accessoriesArray + textArray
    }
    
    func createChristmasArray() -> [UIImage] {
        
        let christmasArray = createArray(fileName: "Christmas", optimised: false)
        
        return christmasArray
    }
    
    func createEmojiArray() -> [UIImage] {
        
        let vampArray = createArray(fileName: "Vamp", optimised: false)
        let skullArray = createArray(fileName: "Skull", optimised: false)
        let swampArray = createArray(fileName: "Swamp", optimised: false)
        let wolfArray = createArray(fileName: "Wolf", optimised: false)
        let medusaArray = createArray(fileName: "Snake", optimised: false)
        
        return vampArray + skullArray + swampArray + wolfArray + medusaArray
    }
    
    func createPartArray() -> [UIImage] {
        
        let headArray = createArray(fileName: "Head", optimised: false)
        let eyeArray = createArray(fileName: "Eye", optimised: false)
        let mouthArray = createArray(fileName: "Mouth", optimised: false)
        
        return headArray + eyeArray + mouthArray
    }

    func createHeadArray(optimised: Bool) -> [UIImage] {
        
        return createArray(fileName: "Head", optimised: optimised)
    }

    func createEyeArray(optimised: Bool) -> [UIImage] {
        
        return createArray(fileName: "Eye", optimised: optimised)
    }
    
    func createMouthArray(optimised: Bool) -> [UIImage] {
        
        return createArray(fileName: "Mouth", optimised: optimised)
    }
    
    func createAccessoriesArray(optimised: Bool) -> [UIImage] {
        
        let date = DateManager().detectMonth()
        if date == .december {
            let christmasArray = createArray(fileName: "AccessoriesChristmas", optimised: optimised)
            let accessoriesArray = createArray(fileName: "Accessories", optimised: optimised)
            return christmasArray + accessoriesArray
        } else {
            return createArray(fileName: "Accessories", optimised: optimised)
        }
    }
    
    func createTextArray(optimised: Bool) -> [UIImage] {
        
        let date = DateManager().detectMonth()
        if date == .december {
            let christmasArray = createArray(fileName: "TextChristmas", optimised: optimised)
            let textArray = createArray(fileName: "Text", optimised: optimised)
            
            return christmasArray + textArray
        } else {
            return createArray(fileName: "Text", optimised: optimised)
        }
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
    
    func createArray(fileName: String, optimised: Bool) -> [UIImage] {
        
        var index = 0
        var foundImage = false
        var array = [UIImage]()
        
        repeat {
            
            let optimisedFileName = fileName + "Optimised" + String(index)
            let fileName = fileName + String(index)
            
            var name = fileName
            
            if optimised == true {
                
                name = optimisedFileName
            }
            
            if let image = UIImage(named: name) {
                
                image.accessibilityLabel = NSLocalizedString(fileName, comment: "")
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
                    let sticker = try createSticker(asset: fileName, localizedDescription: NSLocalizedString(fileName, comment: fileName))
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
}
