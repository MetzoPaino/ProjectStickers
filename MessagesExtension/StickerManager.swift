//
//  StickerManager.swift
//  StickerTest
//
//  Created by William Robinson on 25/09/2016.
//  Copyright © 2016 William Robinson. All rights reserved.
//

import Foundation
import Messages

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
        
        createSticker(asset: "Vamp0", localizedDescription: "Vampire")
        createSticker(asset: "Wolf0", localizedDescription: "Wolf")
        createSticker(asset: "Medusa0", localizedDescription: "Medusa")
        createSticker(asset: "SkullKid0", localizedDescription: "Skull")
        createSticker(asset: "Swamp0", localizedDescription: "Swamp")
        
        createSticker(asset: "Vamp1", localizedDescription: "Vampire")
        createSticker(asset: "Wolf1", localizedDescription: "Wolf")
        createSticker(asset: "Medusa1", localizedDescription: "Medusa")
        createSticker(asset: "SkullKid1", localizedDescription: "Skull")
        createSticker(asset: "Swamp1", localizedDescription: "Swamp")
        
        createSticker(asset: "Vamp2", localizedDescription: "Vampire")
        createSticker(asset: "Wolf2", localizedDescription: "Wolf")
        createSticker(asset: "Medusa2", localizedDescription: "Medusa")
        createSticker(asset: "SkullKid2", localizedDescription: "Skull")
        createSticker(asset: "Swamp2", localizedDescription: "Swamp")
        
        createSticker(asset: "Vamp3", localizedDescription: "Vampire")
        createSticker(asset: "Wolf3", localizedDescription: "Wolf")
        createSticker(asset: "Medusa3", localizedDescription: "Medusa")
        createSticker(asset: "SkullKid3", localizedDescription: "Skull")
        createSticker(asset: "Swamp3", localizedDescription: "Swamp")
        
        createSticker(asset: "Vamp4", localizedDescription: "Vampire")
        createSticker(asset: "Wolf4", localizedDescription: "Wolf")
        createSticker(asset: "Medusa4", localizedDescription: "Medusa")
        createSticker(asset: "SkullKid4", localizedDescription: "Skull")
        createSticker(asset: "Swamp4", localizedDescription: "Swamp")
        
        createSticker(asset: "Vamp5", localizedDescription: "Vampire")
        createSticker(asset: "Wolf5", localizedDescription: "Wolf")
        createSticker(asset: "Medusa5", localizedDescription: "Medusa")
        createSticker(asset: "SkullKid5", localizedDescription: "Skull")
        createSticker(asset: "Swamp5", localizedDescription: "Swamp")

    }
    
    func loadCustomStickers() {
        
        for url in customStickerFileURLS {
            
            createCustomSticker(fileURL: url)
        }
    }
    
    func createSticker(asset: String, localizedDescription: String) {
        
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
