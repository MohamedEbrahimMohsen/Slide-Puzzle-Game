//
//  SlidePuzzle.swift
//  Picture Slide Puzzle
//
//  Created by Mohamed Mohsen on 4/24/18.
//  Copyright © 2018 Mohamed Mohsen. All rights reserved.
//

import Foundation

class slidePuzzle: Codable{
    let rows: Int //the higher rows/cols means higher difficulty and visa versa
    let columns: Int
    var slides: [Slide]
    var playerInfo: PlayerInfo?
    
    subscript(row: Int, column: Int) -> Slide? {
        get {
            if !indexIsValid(row: row, column: column) {return nil}
            //assert(indexIsValid(row: row, column: column), "Index out of range") //we don't need assert for getting
            return slides[(row * columns) + column]
        }
        set {
            assert(indexIsValid(row: row, column: column), "Index out of range") //here w need assert for setting
            slides[(row * columns) + column] = newValue!
        }
    }
    
    private func indexIsValid(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        slides = [Slide]()
        slidesInit()
    }
    
    private func slidesInit(){
        for row in 0..<rows{
            for col in 0..<columns{
                slides.append(Slide(row: row, column: col, slideData: nil , identifier: (rows * row + col), isThisTheEmptySlide: false))
            }
        }
    }
    
//    private func slidesInit(){
//        for row in 0..<rows{
//            for col in 0..<columns{
//                let slideNeighbours = getNeighboursOf(row: row, col: col)
//                slides.append(Slide(row: row, column: col, slideData: nil , neigbours: slideNeighbours, isThisTheEmptySlide: false))
//            }
//        }
//    }
    
//    private func getNeighboursOf(row: Int, col: Int) -> [Neigbour]{
//        var neighbours = [Neigbour]()
//        if indexIsValid(row: row - 1, column: col){neighbours.append(Neigbour(direction: .up, isAccessible: true))}
//        if indexIsValid(row: row + 1, column: col){neighbours.append(Neigbour(direction: .down, isAccessible: true))}
//        if indexIsValid(row: row , column: col - 1){neighbours.append(Neigbour(direction: .left, isAccessible: true))}
//        if indexIsValid(row: row , column: col + 1){neighbours.append(Neigbour(direction: .right, isAccessible: true))}
//        return neighbours
//    }
    
    private func canThisCoordSwapWithEmpty(row: Int, col: Int) -> Bool{
        if let slide = self[row,col]{
            return slide.isThisTheEmptySlide
        }else{
            return false
        }
    }
    
    private func getCoordOFTheEmptySlide() -> (Int, Int)?{
        for index in slides.indices{
            if slides[index].isThisTheEmptySlide == true {
                return index.convertToRowColIndicesInMatrixOf(rows: rows, cols: columns)
            }
        }
        return nil
    }
    
    func getCoordOfTheEmptySlideIFThisCoordNeighbourIt(row: Int, col: Int) -> (Int,Int)?{
        if let (emptyRow, emptyCol) = getCoordOFTheEmptySlide(){
            if  (row - 1 == emptyRow) && (col == emptyCol) ||
                (row + 1 == emptyRow) && (col == emptyCol) ||
                (row == emptyRow) && (col - 1 == emptyCol) ||
                (row == emptyRow) && (col + 1 == emptyCol)
            {
                swap(&self[row,col], &self[emptyRow,emptyCol])
                return (emptyRow, emptyCol)
            }
        }
        return nil
    }
    
    func shuffle(){
        slides.shuffle()
    }
    
    func isFinished() -> Bool{
        for index in slides.indices{
            if slides[index].identifier != index {
                return false
            }
        }
        return true
    }
}

//the player info that will saved for him/her
struct PlayerInfo: Codable{
    var name: String
    var score: Int
    var level: Int //max reached level
    var totalSecondsToFinishThePuzzle: Int
}









//    var difficult: Difficulty
//    enum Difficulty: String, Codable {
//        case Beginner = "Beginner"
//        case Intermediate = "Intermediate"
//        case Advanced = "Advanced"
//    }
