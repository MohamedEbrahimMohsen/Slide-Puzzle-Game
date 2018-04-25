//
//  SlidePuzzleViewController.swift
//  Picture Slide Puzzle
//
//  Created by Mohamed Mohsen on 4/24/18.
//  Copyright © 2018 Mohamed Mohsen. All rights reserved.
//

import UIKit

class SlidePuzzleViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIPopoverPresentationControllerDelegate {
    
    //MARK: variables
    private lazy var game = slidePuzzle(rows: rows, columns: cols)
    private var rows: Int = 5
    private var cols: Int = 5
    private var puzzleImageName: String?{
        didSet{
            puzzleImage = UIImage(named: puzzleImageName!)
            puzzleImagePieces = puzzleImage?.matrix(rows, cols)
//            puzzleImagePieces = puzzleImage?.slice(image: puzzleImage!, into: rows * cols)
//            puzzleImagePieces = puzzleImage?.splitImage(row: rows, column: cols)
            puzzleImagePieces![(puzzleImagePieces?.count)!-1] = UIImage(named: "Empty")!
            for index in game.slides.indices{
                game.slides[index].slideData = UIImagePNGRepresentation(puzzleImagePieces![index])
            }
            lastIndexInPuzzleToHide = game.slides.count - 1
            game.slides[lastIndexInPuzzleToHide].isThisTheEmptySlide = true
        }
    }
    private var lastIndexInPuzzleToHide: Int = 0
    private var puzzleImage: UIImage?
    private var puzzleImagePieces: [UIImage]?
    private var playingMode: PlayingMode = .images
    private enum PlayingMode{
        case numerical
        case images //default
    }
    private var isTheGameFinished:Bool = false{
        didSet{
            if isTheGameFinished{
                theGameIsFinished()
            }
        }
    }
    
    //MARK: Outlets
    @IBOutlet weak var collectionViewImageView: UIImageView!
    @IBOutlet weak var congratulationsLabel: UILabel!
    @IBOutlet weak var puzzleCollectionView: UICollectionView!{
        didSet{
            puzzleCollectionView.delegate = self
            puzzleCollectionView.dataSource = self
        }
    }
    
    //MARK: Functions
    private func theGameIsFinished(){
        congratulationsLabel.isHidden = false
        self.collectionViewImageView.image = UIImage(named: self.puzzleImageName!)
        self.collectionViewImageView.alpha = 0.0
        self.collectionViewImageView.transform = CGAffineTransform.identity.scaledBy(x: 0.01, y: 0.01)
        UIView.animate(withDuration: 5.0, delay: 0, options: [], animations: {
            self.puzzleCollectionView.alpha = 0.0
        }
            , completion: { finished in
            UIView.animate(withDuration: 3.0, delay: 0, options: .curveEaseOut, animations: {
                self.collectionViewImageView.alpha = 1.0
                self.collectionViewImageView.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
            })
        }
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        puzzleImageName = "OnePiece-Luffy"
        if playingMode == .numerical{
            for index in game.slides.indices{
                game.slides[index].slideData = String(index + 1).data(using: .utf8)
            }
            game.slides[lastIndexInPuzzleToHide].slideData = String("").data(using: .utf8)
            game.slides[lastIndexInPuzzleToHide].isThisTheEmptySlide = true
            lastIndexInPuzzleToHide = game.slides.count - 1
        }
        // Do any additional setup after loading the view.
    }
    
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Preview"{
            if let popOverVC = segue.destination.contents as? PopOverViewController{
                popOverVC.previewImage = UIImage(named: self.puzzleImageName!)
                if let ppc = popOverVC.popoverPresentationController{
                    ppc.delegate = self
                }
            }
        }
    }
    
    //MARK: Puzzle Collection View
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rows * cols
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "puzzleCell", for: indexPath) as! PuzzleCollectionViewCell
        
        if playingMode == .numerical{
            cell.cellLabel.text = String(data: game.slides[indexPath.item].slideData!, encoding: .utf8)
            cell.cellLabel.layer.borderColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
            cell.cellLabel.layer.borderWidth = 2.0
            cell.cellImageView.isHidden = true
        }else{
            //cell.cellImageView.image = puzzleImagePieces?[indexPath.item]
            cell.cellImageView.image = UIImage(data:game.slides[indexPath.item].slideData!,scale:1.0)
            cell.cellLabel.isHidden = true
        }
        if game.slides[indexPath.item].isThisTheEmptySlide { //indexPath.item == lastIndexInPuzzleToHide
            cell.cellLabel.isHidden = true
            cell.cellImageView.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: puzzleCollectionView.bounds.width / CGFloat(rows) - Constants.minSpacingBetweenCells,
                      height: puzzleCollectionView.bounds.height / CGFloat(cols) - Constants.minSpacingBetweenLines)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let(row, col) = indexPath.item.convertToRowColIndicesInMatrixOf(rows: rows, cols: cols)
        //print("Slide(\(row), \(col))")
        //print(game[row,col]?.identifier ?? -1)
        
        if let (emptySlideRow, emptySlideCol) = game.getCoordOfTheEmptySlideIFThisCoordNeighbourIt(row: row, col: col){
            //print("Empty Slide(\(emptySlideRow), \(emptySlideCol))")
            //print("indexPath.item: \(indexPath.item) , empty.item: \((self.rows * emptySlideRow + emptySlideCol))")
                var sourceIndexPath = indexPath
                let destinationIndexPath = IndexPath(item: (self.rows * emptySlideRow + emptySlideCol), section: 0)
                if let sourceCell = self.puzzleCollectionView.cellForItem(at: indexPath) as? PuzzleCollectionViewCell{
                    if let destinationCell = self.puzzleCollectionView.cellForItem(at: destinationIndexPath) as? PuzzleCollectionViewCell{
                        let sourceCenter = sourceCell.center
                        let destinationCenter = destinationCell.center
//                        swap(&sourceIndexPath, &destinationIndexPath)
                        UIView.animate(withDuration: 0.2, delay: 0, options:[], animations: {
                            //sourceCell.transform = CGAffineTransform.identity
                            sourceCell.center = destinationCenter
                            
                        }, completion: { finished in
                            self.lastIndexInPuzzleToHide = sourceIndexPath.item
                            destinationCell.center = sourceCenter
                            //self.puzzleCollectionView.reloadData()
                            UIView.performWithoutAnimation {
                                self.puzzleCollectionView.reloadItems(at: [destinationIndexPath])
                                self.puzzleCollectionView.reloadItems(at: [sourceIndexPath])
                                self.isTheGameFinished = self.game.isFinished()
                            }
                        }
                        )
                    }
                }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    // Enable cell reordering.
    
     func collectionViewAllowsReordering(collectionView: UICollectionView) -> Bool {
        return true
    }
    
    //MARK: Constants
    private struct Constants{
        static let minSpacingBetweenCells: CGFloat = 1
        static let minSpacingBetweenLines: CGFloat = 1
    }
}




























//            UIView.animate(withDuration: 4, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [], animations: {
//                self.puzzleCollectionView.reloadItems(at: [indexPath])
//            }//,
//                //completion: {finished in CATransaction.commit() }
//            )
