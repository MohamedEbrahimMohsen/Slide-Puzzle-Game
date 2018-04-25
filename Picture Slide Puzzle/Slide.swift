//
//  Slide.swift
//  Picture Slide Puzzle
//
//  Created by Mohamed Mohsen on 4/24/18.
//  Copyright © 2018 Mohamed Mohsen. All rights reserved.
//

import Foundation

struct Slide: Codable, Hashable{
    var hashValue: Int{
        return identifier
    }
    
    var row: Int
    var column: Int
    var slideData: Data? //image Or textNumbers like 3x3 puzzle from 1..9
                         //let imageData: NSData = UIImagePNGRepresentation(myImage)    ----  from UIImage To Data
                         //UIImage(data:imageData,scale:1.0)   ---- from Data to UIImage
    var identifier: Int
    //var neigbours: [Neigbour]
    var isThisTheEmptySlide: Bool = false
}

struct Neigbour: Codable{
    var direction: Direction
    var isAccessible: Bool = false
    
    enum Direction: String, Codable{
        case up    = "U"
        case down  = "D"
        case left  = "L"
        case right = "R"
    }
}


//enum Direction: String, Codable{
//    case upperLeft    = "U-L"
//    case upperMiddle  = "U-M"
//    case upperRight   = "U-R"
//    case buttomLeft   = "B-L"
//    case buttomMiddle = "B-M"
//    case buttomRight  = "B-R"
//    case left  = "L"
//    case right = "R"
//}
