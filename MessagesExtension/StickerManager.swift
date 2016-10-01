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
        
        let fileManager = FileManager.default

        print(fileURL.absoluteString)
        
        do {
            
            try sticker = MSSticker(contentsOfFileURL: fileURL, localizedDescription: "Custom")
            customStickers.append(sticker)
            
        } catch {
            
            print(error)
            return
        }
        
//        if fileManager.fileExists(atPath: fileURL.absoluteString) {
//            print("FILE AVAILABLE")
//            
//            do {
//                
//                try sticker = MSSticker(contentsOfFileURL: fileURL, localizedDescription: "Custom")
//                customStickers.append(sticker)
//                
//            } catch {
//                
//                print(error)
//                return
//            }
//            
//        } else {
//            print("FILE NOT AVAILABLE")
//        }
    }
    
//    func createImageFrom(view: UIView) {
//        
//        view.backgroundColor = .clear
//        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
//        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        view.backgroundColor = .cyan
//        print("He")
//        resizeImage(image: image!)
//    }
//    
//    func resizeImage(image: UIImage) {
//        
//        let stickerSize = CGRect(x: 0, y: 0, width: 600, height: 600)
//        UIGraphicsBeginImageContextWithOptions(stickerSize.size, false, 1.0)
//        image.draw(in: stickerSize)
//        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        print("He")
//        saveImage(image: resizedImage!)
//    }

//    func saveImage(image: UIImage) {
//        
//        
//        
//        //http://stackoverflow.com/questions/25100262/save-data-to-plist-file-in-swift
//        
//        
//        
//        
//        
//        
//        
//        
//        //        let filename = "test.jpg"
//        //        let subfolder = "SubDirectory"
//        //
//        //        do {
//        //            let fileManager = FileManager.default
//        //            let documentsURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//        //            let folderURL = documentsURL.appendingPathComponent(subfolder)
//        //
//        //            do {
//        //
//        //                try folderURL.checkPromisedItemIsReachable()
//        //
//        //
//        //            }
//        //
//        //
//        //
//        //
//        //
//        //
//        //            if !folderURL.   checkPromisedItemIsReachableAndReturnError(nil) {
//        //                try fileManager.createDirectoryAtURL(folderURL, withIntermediateDirectories: true, attributes: nil)
//        //            }
//        //            let fileURL = folderURL.URLByAppendingPathComponent(filename)
//        //
//        //            try imageData.writeToURL(fileURL, options: .AtomicWrite)
//        //        } catch {
//        //            print(error)
//        //        }
//        
//        
//        do {
//            
//            let fileManager = FileManager.default
//            let documentsURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//            print(documentsURL)
//            
//            let folderURL = documentsURL.appendingPathComponent("Sticker")
//            
//            do {
//                let reachable = try folderURL.checkPromisedItemIsReachable()
//                print("reachable!")
//                
//                let fileURL = folderURL.appendingPathComponent("MyImageName1.png")
//                
//                let imageData: Data = UIImagePNGRepresentation(image)!
//                
//                try imageData.write(to: fileURL)
//                
//            } catch {
//                
//                print("error = \(error)")
//                do {
//                    try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
//                    print("must have made")
//                    
//                    let fileURL = folderURL.appendingPathComponent("MyImageName2.png")
//                    
//                    let imageData: Data = UIImagePNGRepresentation(image)!
//                    
//                    try imageData.write(to: fileURL)
//                    
//                } catch {
//                    
//                    print(error)
//                }
//            }
//            
//        } catch {
//            
//            print(error)
//        }
//        
//        // Below works, i don't know if above does
//        
//        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
//        
//        
//        let fileUrl = Foundation.URL(string: "file://\(paths[0])/\(UUID().uuidString).png")
//        
//        
//        do {
//            let imageData: Data = UIImagePNGRepresentation(image)!
//            
//            // try imageData.write(to: fileUrl!)
//            
//            
//            try UIImagePNGRepresentation(image)?.write(to: fileUrl!)
//            
//            print("wrote to \(fileUrl!)")
//                        
//        } catch {
//            
//            print("unable to write to \(fileUrl!)")
//            print(error)
//        }
//        
//        
//        
//        
//        //    UIImagePNGRepresentation(image)?.write(to: filePath) writeToFile(filePath, atomically: true)
//        
//        
//        
//        
//        
//        
//        
//        
//        //        let filePath = "\(paths[0])/MyImageName.png"
//        //
//        //        UIImagePNGRepresentation(image)?.write(to: filePath) writeToFile(filePath, atomically: true)
//    }

}
