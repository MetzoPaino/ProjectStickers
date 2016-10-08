//
//  BrowserLayout.swift
//  projectstickers
//
//  Created by William Robinson on 08/10/2016.
//  Copyright © 2016 William Robinson. All rights reserved.
//

import UIKit

class BrowserLayout: UICollectionViewLayout {
    
//    var horizontalInset = 0.0 as CGFloat
//    var verticalInset = 0.0 as CGFloat
//    
//    var minimumItemWidth = 0.0 as CGFloat
//    var maximumItemWidth = 0.0 as CGFloat
//    var itemHeight = 0.0 as CGFloat
//    var numberOfColumns = 2
//
//    
//    override func prepare() {
//        // 1. Only calculate once
//            
//            // 2. Pre-Calculates the X Offset for every column and adds an array to increment the currently max Y Offset for each column
//            let columnWidth = maximumItemWidth / CGFloat(numberOfColumns)
//            var xOffset = [CGFloat]()
//            for column in 0 ..< numberOfColumns {
//                xOffset.append(CGFloat(column) * columnWidth )
//            }
//            var column = 0
//            var yOffset = [CGFloat](repeatedValue: 0, count: numberOfColumns)
//            
//            // 3. Iterates through the list of items in the first section
//            for item in 0 ..< collectionView!.numberOfItems(inSection: 0) {
//                
//                let indexPath = NSIndexPath(forItem: item, inSection: 0)
//                
//                // 4. Asks the delegate for the height of the picture and the annotation and calculates the cell frame.
//                let width = columnWidth - cellPadding*2
//                let photoHeight = delegate.collectionView(collectionView!, heightForPhotoAtIndexPath: indexPath , withWidth:width)
//                let annotationHeight = delegate.collectionView(collectionView!, heightForAnnotationAtIndexPath: indexPath, withWidth: width)
//                let height = cellPadding +  photoHeight + annotationHeight + cellPadding
//                let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
//                let insetFrame = CGRectInset(frame, cellPadding, cellPadding)
//                
//                // 5. Creates an UICollectionViewLayoutItem with the frame and add it to the cache
//                let attributes = PinterestLayoutAttributes(forCellWithIndexPath: indexPath)
//                attributes.photoHeight = photoHeight
//                attributes.frame = insetFrame
//                cache.append(attributes)
//                
//                // 6. Updates the collection view content height
//                contentHeight = max(contentHeight, CGRectGetMaxY(frame))
//                yOffset[column] = yOffset[column] + height
//                
//                column = column >= (numberOfColumns - 1) ? 0 : ++column
//            }
//    }
    
    
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        
//        switch viewingCellSize {
//        case .small:
//            return CGSize(width: view.frame.size.width / 5, height: view.frame.size.width / 5)
//        case .medium:
//            return CGSize(width: view.frame.size.width / 4, height: view.frame.size.width / 4)
//        case .large:
//            return CGSize(width: view.frame.size.width / 3, height: view.frame.size.width / 3)
//        }
//    }
    
    
//    - (id)init
//    {
//        self = [super init];
//        if (self)
//        {
//            self.scrollDirection = UICollectionViewScrollDirectionVertical;
//            self.itemSize = (CGSize){170, 197};
//            self.sectionInset = UIEdgeInsetsMake(4, 10, 14, 10);//UIEdgeInsetsMake(54, 60, 64, 60);
//            self.headerReferenceSize = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad? (CGSize){50, 50} : (CGSize){43, 43}; // 100
//            self.footerReferenceSize = (CGSize){44, 44}; // 88
//            self.minimumInteritemSpacing = 10; // 40;
//            self.minimumLineSpacing = 10;//40;
//            [self registerClass:[ShelfView class] forDecorationViewOfKind:[ShelfView kind]];
//        }
//        return self;
//    }

}
