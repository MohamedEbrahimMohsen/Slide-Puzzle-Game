//
//  Extensions.swift
//  Picture Slide Puzzle
//
//  Created by Mohamed Mohsen on 4/25/18.
//  Copyright © 2018 Mohamed Mohsen. All rights reserved.
//

import Foundation
import UIKit


extension UIImage {
    func matrix(_ rows: Int, _ columns: Int) -> [UIImage] {
        let y = (size.height / CGFloat(rows)).rounded()
        let x = (size.width / CGFloat(columns)).rounded()
        var images: [UIImage] = []
        images.reserveCapacity(rows * columns)
        guard let cgImage = cgImage else { return [] }
        (0..<rows).forEach { row in
            (0..<columns).forEach { column in
                var width = Int(x)
                var height = Int(y)
                if row == rows-1 && size.height.truncatingRemainder(dividingBy: CGFloat(rows)) != 0 {
                    height = Int(size.height - size.height / CGFloat(rows) * (CGFloat(rows)-1))
                }
                if column == columns-1 && size.width.truncatingRemainder(dividingBy: CGFloat(columns)) != 0 {
                    width = Int(size.width - (size.width / CGFloat(columns) * (CGFloat(columns)-1)))
                }
                if let image = cgImage.cropping(to: CGRect(origin: CGPoint(x: column * Int(x), y:  row * Int(x)), size: CGSize(width: width, height: height))) {
                    images.append(UIImage(cgImage: image, scale: scale, orientation: imageOrientation))
                }
            }
        }
        return images
    }
    
    
    func splitImage(row : Int , column : Int) -> [UIImage]{
        let oImg = self
        let rows = column
        let cols = row
        let height =  (self.size.height) /  CGFloat (rows) //height of each image tile
        let width =  (self.size.width)  / CGFloat (cols)  //width of each image tile
        
        let scale = self.scale //scale conversion factor is needed as UIImage make use of "points" whereas CGImage use pixels.
        
        var imageArr = [UIImage]() // will contain small pieces of image
        
        for y in 0..<rows{
            for x in 0..<cols{
                
                UIGraphicsBeginImageContextWithOptions(
                    CGSize(width:width, height:height),
                    false, 0)
                let i =  oImg.cgImage?.cropping(to:  CGRect.init(x: CGFloat(x) * width * scale, y:  CGFloat(y) * height * scale  , width: width * scale  , height: height * scale) )
                
                let newImg = UIImage.init(cgImage: i!)
                
                imageArr.append(newImg)
                
                UIGraphicsEndImageContext();
                
            }
        }
        return imageArr
    }
    
}



extension Int{
    func convertToRowColIndicesInMatrixOf(rows: Int, cols: Int) -> (Int,Int){
        let row = Int(floor(Double(self / cols)))
        let col = self % cols
        return (row, col)
    }
    
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
    
    func incrementCicle (in number: Int)-> Int {
        return self == (number-1) ? 0: self+1
        //return (number - 1) > self ? self + 1: 0
    }
}

extension Array where Element : Equatable {
    mutating func remove(elementsOf: [Element]){
        self = self.filter{!elementsOf.contains($0)}
    }
    
    mutating func replace(elementsOf oldArray: [Element], with newArray:[Element]){
        guard newArray.count == oldArray.count else {return}
        for idx in newArray.indices{
            if let idxMatched = self.index(of: oldArray[idx]){
                self[idxMatched] = newArray[idx]
            }
        }
    }
    
    mutating func inOut(element: Element){
        if let idx = self.index(of: element){
            self.remove(at: idx)
        }else {
            self.append(element)
        }
    }
    
    mutating func shuffle(){
        if count < 2 {return}
        for _ in indices{
            let randomIndex1 = count.arc4random
            let randomIndex2 = count.arc4random
            swapAt(randomIndex1, randomIndex2)
        }
    }
}


extension UIViewController {
    var contents: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? navcon
        } else {
            return self
        }
    }
}

extension UIView {
    var snapshot: UIImage? {
        UIGraphicsBeginImageContext(bounds.size)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

























