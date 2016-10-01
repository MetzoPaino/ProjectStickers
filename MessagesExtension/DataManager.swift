//
//  DataManager.swift
//  StickerTest
//
//  Created by William Robinson on 25/09/2016.
//  Copyright © 2016 William Robinson. All rights reserved.
//

import Foundation
import UIKit

class DataManager {
    
    let stickerManager = StickerManager()
    
    required init() {
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [String]
        let path = paths[0] //+ "/"//+ "/ProjectStickers.plist"
        
        if FileManager.default.fileExists(atPath: path) == false {
            
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil)
                print("We made a directory at \(path)")

            } catch {
                print(error.localizedDescription)
                print("Failed to make a directory at \(path)")
            }
        }

        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        do {
            
            let urlContents = try FileManager.default.contentsOfDirectory(at: urls[0], includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions.skipsSubdirectoryDescendants)
            
            let pngURLArray = urlContents.filter{ $0.pathExtension == "png" }
            print(pngURLArray)
            
            stickerManager.customStickerFileURLS = pngURLArray
            stickerManager.loadCustomStickers()
            
            
//            do {
//                
//                let image = UIImage(data: try Data(contentsOf: mp3Files[0]))
//                print("Image = \(image)")
//            } catch {
//                
//                print("Failed to make file")
//            }
            
            
            
            
            // if you want to filter the directory contents you can do like this:
//            if let directoryUrls = try? NSFileManager.defaultManager().contentsOfDirectoryAtURL(documentsUrl, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions.SkipsSubdirectoryDescendants) {
//                print(directoryUrls)
//                ........
//            }
            
        } catch {
            
            print("total failure")
        }
        
        
        
        

        
//        do {
//            let directoryContents = try FileManager.default.contentsOfDirectory(atPath: path)
//            
//            for path in directoryContents {
//                print(path)
//                
//                
//                let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [String]
//                let path1 = paths[0] + "/" + path
//                
//                print(path1)
//
//                let url = Bundle.main.url(forResource: path1, withExtension: "png")
//                
//                print(url)
//                
////                if let audioFileURL = NSBundle.mainBundle().URLForResource(audioFileName, withExtension: "mp3", subdirectory: "audioFiles") {
////                    print(audioFileURL)
////                }
//            }
//            
//            print("Directory \(directoryContents)")
//
//        } catch {
//            print(error.localizedDescription);
//        }
//
//            guard let bundle = Bundle.main.path(forResource: "ProjectStickers", ofType: "plist") else {
//                
//                print("Couldn't find bundle")
//                return
//            }

            //FileManager.default.copyItemAtPath(bundle, toPath: path, error:nil)
            
         //   FileManager.default.copyItem(atPath: bundle, toPath: path)
            
            
            
            
//            do {
//                try FileManager.default.copyItem(atPath: bundle, toPath: path)
//                print("Success")
//            } catch {
//                print(error.localizedDescription);
//            }
        }
    
//            if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
//                let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
//                
//                if let decodedStickerManager = unarchiver.decodeObject(forKey: "StickerManager") as? StickerManager {
//                    
//                    stickerManager = decodedStickerManager
//                    
//                } else {
//                    
//                    stickerManager = StickerManager()
//                }
//                
//                unarchiver.finishDecoding()
//                
//            } else {
//                
//                // I don't know how i'd end up here, so should figure that out
//                stickerManager = StickerManager()
//            }
//            
//        } else {
//            
//            // Probably a first launch
//            stickerManager = StickerManager()
//        }
        
//        stickerManager.loadStickers()
//        stickerManager.loadCustomStickers()
//    }
    
    func dataFilePath() -> String {
        return documentsDirectory() + "/" + UUID().uuidString + ".png"
    }
    
    func documentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [String]
        return paths[0]
    }
    
    func saveData() {
        
        print("Saving Data")
        
//        let data = NSMutableData()
//        let archiver = NSKeyedArchiver(forWritingWith: data)
//        archiver.encode(stickerManager, forKey: "StickerManager")
//        
//        archiver.finishEncoding()
//        data.write(toFile: dataFilePath(), atomically: true)
    }
    
    func saveImageToDisk(image: UIImage) {
        
        
       // let fileUrl = Foundation.URL(string: "file://\(paths[0])/\(UUID().uuidString).png")

        print("File path = \("file://" + dataFilePath())")
        
        let url = URL(string: "file://" + dataFilePath())
        if let data = UIImagePNGRepresentation(image) {
            
            do {
                try data.write(to: url!, options: Data.WritingOptions.atomic)
                print("We saved the file!")
            } catch {
                print(error.localizedDescription);
            }
        } else {
            
            print("Couldn't convert to data")
        }
        
        
        
    }
}
