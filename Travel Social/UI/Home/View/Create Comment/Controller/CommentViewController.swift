//
//  CommentViewController.swift
//  Travel Social
//
//  Created by Phan Nguyen on 25/02/2021.
//

import UIKit
import FirebaseFirestore

//MARK: CommentViewControllerDelegate
protocol CommentViewControllerDelegate: class {
    func reloadCountComment()
}

class CommentViewController: UIViewController {

//MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var contentView: UIView!
    
    var dataSources = [Comment]()
    var dataPost = Post()
    weak var commentDelegate: CommentViewControllerDelegate?
    
//MARK: ViewCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setViewKeyboard()
        setData()
        setNavigationBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
//MARK: SetData
    func setTableView() {
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "PostTableViewCell")
        tableView.register(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentTableViewCell")
    }
    
    func setViewKeyboard() {
        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    func setData() {
        handleCommentChanges {
            self.tableView.reloadData()
            self.commentDelegate?.reloadCountComment()
        }
    }
    
    func setNavigationBar() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(popViewController))
        self.navigationItem.leftBarButtonItem = backButton
    }

//MARK: HandleCommentChanges
    func handleCommentChanges(completed: @escaping () -> ()) {
        let db = Firestore.firestore()
        db.collection("comments").whereField("idPost", isEqualTo: dataPost.id ?? "").addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return completed()
            }
            
            snapshot.documentChanges.forEach { diff in
                if (diff.type == .added) {
                    let newComment = Comment()
                    newComment.setData(withData: diff.document)
                    self.dataSources.append(newComment)
                }
                if (diff.type == .modified) {
                    let docId = diff.document.documentID
                    if let indexOfCommentToModify = self.dataSources.firstIndex(where: { $0.idComment == docId} ) {
                        let commentToModify = self.dataSources[indexOfCommentToModify]
                        commentToModify.updateComment(withData: diff.document)
                    }
                }
                if (diff.type == .removed) {
                    let docId = diff.document.documentID
                    if let indexOfCommentToRemove = self.dataSources.firstIndex(where: { $0.idComment == docId} ) {
                        self.dataSources.remove(at: indexOfCommentToRemove)
                    }
                }
            }
            completed()
        }
    }
    
//MARK: Objc Func
    @objc func keyboardWillShow(sender: NSNotification) {
        if let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.contentView.translatesAutoresizingMaskIntoConstraints = true
            self.contentView.frame.origin.y = self.view.bounds.height - keyboardSize.height - contentView.frame.height
        }
    }

    @objc func keyboardWillHide(sender: NSNotification) {
        self.contentView.frame.origin.y = self.view.bounds.height - contentView.frame.height
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }

//MARK: IBAction
    @IBAction func saveComment(_ sender: Any) {
        if commentTextField.text != "" {
            let comment = Comment()
            comment.content = commentTextField.text
            comment.idPost = dataPost.id
            comment.idUser = DataManager.shared.user.id
            DataManager.shared.getCountObject(nameCollection: "comments") { result in
                DataManager.shared.setDataComment(data: comment, id: result)
                DataManager.shared.getComment(idPost: self.dataPost.id!) { result in
                    self.dataSources = result
                    self.tableView.reloadData()
                }
            }
            self.commentDelegate?.reloadCountComment()
            
            if dataPost.idUser != DataManager.shared.user.id {
                let notify = Notify()
                notify.id = dataPost.idUser ?? ""
                notify.nameUser = DataManager.shared.user.name ?? ""
                notify.nameImageAvatar = DataManager.shared.user.nameImage ?? ""
                notify.content = commentTextField.text ?? ""
                DataManager.shared.setDataNotify(data: notify)
            }
            self.commentTextField.text = ""
        }
    }
    
}

//MARK: UITableViewDelegate
extension CommentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        default:
            return 10
        }
    }
    
}

//MARK: UITableViewDataSource
extension CommentViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return dataSources.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as? PostTableViewCell else {
                 return PostTableViewCell()
            }
            cell.selectionStyle = .none
            cell.setdata(data: dataPost)
            cell.dataPost = dataPost
            cell.commentButton.isEnabled = false
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as? CommentTableViewCell else { return CommentTableViewCell()
            }
            cell.setData(comment: dataSources[indexPath.row])
            cell.selectionStyle = .none
            return cell
        }
    }
    
}
