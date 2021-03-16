//
//  DetailImageViewController.swift
//  Travel Social
//
//  Created by Phan Nguyen on 15/03/2021.
//

import UIKit
import Kingfisher

class DetailImageViewController: UIViewController {

//MARK: Properties
    @IBOutlet weak var downLoadButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    var nameImage = String()
    
//MARK: View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
    }
    
    func setData() {
        DataImageManager.shared.downloadImage(path: "post", nameImage: nameImage) { result in
            DispatchQueue.main.async {
                self.imageView.kf.indicatorType = .activity
                self.imageView.kf.setImage(with: result)
            }
        }
    }

//MARK: IBAction
    @IBAction func downLoadImage(_ sender: Any) {
        if let image = imageView.image {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }
    
}
