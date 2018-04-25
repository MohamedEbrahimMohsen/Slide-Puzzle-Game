//
//  SlidePuzzleViewController.swift
//  Picture Slide Puzzle
//
//  Created by Mohamed Mohsen on 4/24/18.
//  Copyright © 2018 Mohamed Mohsen. All rights reserved.
//

import UIKit

class SlidePuzzleViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: variables
    var game: slidePuzzle?
    var rows: Int = 7
    var cols: Int = 7
    var puzzleImageName: String?{
        didSet{
            puzzleImage = UIImage(named: puzzleImageName!)
            puzzleImagePieces = puzzleImage?.matrix(rows, cols)
        }
    }
    var lastIndexInPuzzleToHide: Int?
    var puzzleImage: UIImage?
    var puzzleImagePieces: [UIImage]?
    var puzzleTextRange: Range<Int>{
        return 0..<(rows * cols)
    }
    var playingMode: PlayingMode = .images
    enum PlayingMode{
        case numerical
        case images //default
    }
    
    
    @IBOutlet weak var puzzleCollectionView: UICollectionView!{
        didSet{
            puzzleCollectionView.delegate = self
            puzzleCollectionView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        puzzleImageName = "OnePiece-Luffy"
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Puzzle Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rows * cols
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "puzzleCell", for: indexPath) as! PuzzleCollectionViewCell
        if playingMode == .numerical{
            cell.cellImageView.isHidden = true
        }else{
            cell.cellImageView.image = puzzleImagePieces?[indexPath.item]
            cell.cellLabel.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: puzzleCollectionView.bounds.width / CGFloat(rows) - Constants.minSpacingBetweenCells,
                      height: puzzleCollectionView.bounds.height / CGFloat(cols) - Constants.minSpacingBetweenLines)
    }
    
    
    
    //MARK: Constants
    private struct Constants{
        static let minSpacingBetweenCells: CGFloat = 1
        static let minSpacingBetweenLines: CGFloat = 1
    }
}

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
}
