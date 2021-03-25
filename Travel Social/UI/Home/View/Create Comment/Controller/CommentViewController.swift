//
//  CommentViewController.swift
//  Travel Social
//
//  Created by Phan Nguyen on 25/02/2021.
//

import UIKit
import FirebaseFirestore

protocol CommentViewControllerDelegate: class {
    func reloadComment(count: Int, post: Post)
}

class CommentViewController: UIViewController {

//MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewBottomConstraint: NSLayoutConstraint!
    
    weak var commentDelegate: CommentViewControllerDelegate?
    var dataSources = [Comment]()
    var dataPost = Post()
    
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
        commentTextField.becomeFirstResponder()
    }
    
//MARK: SetData
    func setTableView() {
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
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
        handleCommentChanges { [self] in
            tableView.reloadData()
            commentDelegate?.reloadComment(count: dataSources.count, post: dataPost)
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
            contentViewBottomConstraint.constant = keyboardSize.height
        }
    }

    @objc func keyboardWillHide(sender: NSNotification) {
        guard let heightTabbar = self.tabBarController?.tabBar.frame.height else { return }
        contentViewBottomConstraint.constant = 0 + heightTabbar
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
            
            if dataPost.idUser != DataManager.shared.user.id {
                let notify = Notify()
                notify.id = dataPost.idUser ?? ""
                notify.type = "comment"
                notify.idFriend = DataManager.shared.user.id ?? ""
                notify.idPost = dataPost.id ?? ""
                notify.content = commentTextField.text ?? ""
                DataManager.shared.setDataNotifyComment(data: notify)
            }
            self.commentTextField.text = ""
        }
    }
    
}

//MARK: UITableViewDelegate
extension CommentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 430
        } else {
            return 100
        }
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
            cell.cellDelegate = self
            cell.setdata(data: dataPost)
            cell.dataPost = dataPost
            cell.commentButton.isUserInteractionEnabled = false
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as? CommentTableViewCell else { return CommentTableViewCell()
            }
            cell.cellDelegate = self
            cell.setData(comment: dataSources[indexPath.row])
            cell.dataComment = dataSources[indexPath.row]
            cell.selectionStyle = .none
            return cell
        }
    }
    
}

//MARK: PostTableViewCellDelegate
extension CommentViewController: PostTableViewCellDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath, dataPost: Post) {
    }
    
    func showProfile(user: User) {
        DataManager.shared.getPostFromId(idUser: user.id!) { result in
            DataManager.shared.setDataUser()
            if user.id == DataManager.shared.user.id {
                let profileUserViewController = ProfileUserViewController()
                profileUserViewController.dataPost = result
                profileUserViewController.dataUser = user
                self.navigationController?.pushViewController(profileUserViewController, animated: true)
            } else {
                let friendViewController = FriendViewController()
                friendViewController.dataPost = result
                friendViewController.dataUser = user
                self.navigationController?.pushViewController(friendViewController, animated: true)
            }
        }
    }
    
    func showListUser(listUser: [String]) {
        let listUserViewController = ListUserViewController()
        DataManager.shared.getListUser(listId: listUser) { result in
            listUserViewController.dataSources = result
            self.navigationController?.pushViewController(listUserViewController, animated: true)
        }
    }
    
    func showListComment(dataPost: Post) {
    }
    
}

//MARK: CommentTableViewCellDelegate
extension CommentViewController: CommentTableViewCellDelegate {
}
