//
//  DataManager.swift
//  StickerTest
//
//  Created by William Robinson on 25/09/2016.
//  Copyright © 2016 William Robinson. All rights reserved.
//

import Foundation
import UIKit

protocol DataManagerDelegate: class {
    func dataManagerChanged()
}

class DataManager {
    
    weak var delegate: DataManagerDelegate?
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
            
            let properties = [URLResourceKey.localizedNameKey, URLResourceKey.creationDateKey, URLResourceKey.localizedTypeDescriptionKey]
            
            let urlContents = try FileManager.default.contentsOfDirectory(at: urls[0], includingPropertiesForKeys: properties, options: FileManager.DirectoryEnumerationOptions.skipsSubdirectoryDescendants)
            let pngURLArray = urlContents.filter{ $0.pathExtension == "png" }
            
            var dateArray = [Date]()
            
            for url in pngURLArray {
                
                do {
                    let attributes = try FileManager.default.attributesOfItem(atPath: url.path)
                    let creationDate = attributes[FileAttributeKey.creationDate] as! Date
                    print(creationDate)
                    dateArray.append(creationDate)
                } catch {
                    
                    print("problems")
                }
            }
            
          //  let combined = zip(pngURLArray, dateArray).sortedBy: {$0.1 < $1.1}
            
            let combined = zip(pngURLArray, dateArray).sorted(by: { (s1: (URL, Date), s2: (URL, Date)) -> Bool in
                return s1.1 > s2.1
            })
            
            let sortedByDate = combined.map {$0.0}
            
            stickerManager.customStickers.removeAll()
            stickerManager.customStickerFileURLS = sortedByDate
            stickerManager.loadCustomStickers()
            
        } catch {
            
            print("No custom stickers")
        }
    }
    
    func deleteURLAtIndex(index: Int) {
        
        do {
            
            try FileManager.default.removeItem(at: stickerManager.customStickerFileURLS[index])
            loadURLSOfCreatedMonsters()
            delegate?.dataManagerChanged()
            
        } catch {
            
            print("Failed to delete \(error.localizedDescription)")
        }
        
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
//        NSString *filePath = [documentsPath stringByAppendingPathComponent:@"image.png"];
//        NSError *error = nil;
//        
//        if (![fileManager removeItemAtPath:filePath error:&error]) {
//            NSLog(@"[Error] %@ (%@)", error, filePath);
//        }
    }
    
}
