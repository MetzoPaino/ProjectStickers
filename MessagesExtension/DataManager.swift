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

        loadURLSOfCreatedMonsters()
        stickerManager.loadStickers()
    }
    
    func dataFilePath() -> String {
        return documentsDirectory() + "/" + UUID().uuidString + ".png"
    }
    
    func documentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [String]
        return paths[0]
    }
    
    func saveImageToDisk(image: UIImage) {
        
       // let fileUrl = Foundation.URL(string: "file://\(paths[0])/\(UUID().uuidString).png")

        print("File path = \("file://" + dataFilePath())")
        
        let url = URL(string: "file://" + dataFilePath())
        if let data = UIImagePNGRepresentation(image) {
            
            do {
                try data.write(to: url!, options: Data.WritingOptions.atomic)
                print("We saved the file!")
                loadURLSOfCreatedMonsters()
            } catch {
                print(error.localizedDescription);
            }
            
        } else {
            
            print("Couldn't convert to data")
        }
    }
    
    func loadURLSOfCreatedMonsters() {
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        do {
            
            let urlContents = try FileManager.default.contentsOfDirectory(at: urls[0], includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions.skipsSubdirectoryDescendants)
            
            let pngURLArray = urlContents.filter{ $0.pathExtension == "png" }
            
            stickerManager.customStickers.removeAll()
            stickerManager.customStickerFileURLS = pngURLArray
            stickerManager.loadCustomStickers()
            
        } catch {
            
            print("No custom stickers")
        }
    }
}
