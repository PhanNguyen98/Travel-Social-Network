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
        zoomImage()
        setNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.barTintColor = .black
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.tintColor = .black
    }
    
//MARK: SetData
    func setData() {
        DispatchQueue.main.async {
            self.imageView.kf.indicatorType = .activity
            self.imageView.kf.setImage(with: URL(string: self.nameImage))
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func zoomImage() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(gesture:)))
        imageView.addGestureRecognizer(pinchGesture)
    }
    
    @objc func handlePinch(gesture: UIPinchGestureRecognizer) {
        if gesture.state == UIGestureRecognizer.State.changed {
            let transform = CGAffineTransform(scaleX: gesture.scale, y: gesture.scale)
            imageView.transform = transform
        }
    }
    
    func setNavigation() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(popViewController))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }

//MARK: IBAction
    @IBAction func downLoadImage(_ sender: Any) {
        if let image = imageView.image {
            showAlert(message: "Save Image Successfully")
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }
    
}
