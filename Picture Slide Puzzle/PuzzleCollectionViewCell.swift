//
//  PuzzleCollectionViewCell.swift
//  Picture Slide Puzzle
//
//  Created by Mohamed Mohsen on 4/24/18.
//  Copyright © 2018 Mohamed Mohsen. All rights reserved.
//

import UIKit

class PuzzleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellView: UIView!{
        didSet{
            self.cellView.layer.borderWidth = 0.3
            self.cellView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
}
