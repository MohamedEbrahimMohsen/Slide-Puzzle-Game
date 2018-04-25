//
//  Slide.swift
//  Picture Slide Puzzle
//
//  Created by Mohamed Mohsen on 4/24/18.
//  Copyright © 2018 Mohamed Mohsen. All rights reserved.
//

import Foundation

struct Slide: Codable{
    var row: Int
    var column: Int
    var slideData: String //imagePath Or textNumbers like 3x3 puzzle from 1..9
    var neigbours: [Neigbour]
}

struct Neigbour: Codable{
    var direction: Direction
    var isAccessible: Bool
    
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
