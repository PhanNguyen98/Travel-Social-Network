//
//  DetailImageViewController.swift
//  Travel Social
//
//  Created by Phan Nguyen on 01/02/2021.
//

import UIKit

class DetailImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var nameImage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataImage()
        setNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func loadDataImage() {
        DataImageManager.shared.downloadImage(path: "post", nameImage: nameImage ?? "") { result in
            self.imageView.image = result
        }
    }
    
    func setNavigationBar() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(popViewController))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    @objc func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }

}
