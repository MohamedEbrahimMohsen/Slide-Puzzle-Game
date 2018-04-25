//
//  PopOverViewController.swift
//  Picture Slide Puzzle
//
//  Created by Mohamed Mohsen on 4/26/18.
//  Copyright © 2018 Mohamed Mohsen. All rights reserved.
//

import UIKit

class PopOverViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var previewImage: UIImage?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewAspectRatio: NSLayoutConstraint!
    
    @IBOutlet var popOverView: UIView!
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        imageView.image = previewImage
        imageView.removeConstraint(imageViewAspectRatio)
        imageViewAspectRatio = NSLayoutConstraint(
            item: imageView,
            attribute: .width,
            relatedBy: .equal,
            toItem: imageView,
            attribute: .height,
            multiplier: (previewImage?.size.width)! / (previewImage?.size.height)!,
            constant: 0
        )
        imageView.addConstraint(imageViewAspectRatio)
        imageView.image = previewImage
        popOverView.backgroundColor = .clear
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
