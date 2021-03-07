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
    
    var dataSources = [Comment]()
    var dataPost = Post()
    weak var commentDelegate: CommentViewControllerDelegate?
    
//MARK: ViewCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setViewKeyboard()
        setData()
    }
    
//MARK: SetData
    func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self
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
        if let keyboardFrame: NSValue = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.view.frame.origin.y = -keyboardHeight
        }
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0
    }

//MARK: IBAction
    @IBAction func saveComment(_ sender: Any) {
        let comment = Comment()
        comment.content = commentTextField.text
        comment.idPost = dataPost.id
        comment.idUser = DataManager.shared.user.id
        DataManager.shared.setDataComment(data: comment)
        DataManager.shared.getComment(idPost: dataPost.id!) { result in
            self.dataSources = result
            self.tableView.reloadData()
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

//MARK: UITableViewDelegate
extension CommentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 80))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = " Comments"
        label.font = .boldSystemFont(ofSize: 25)
        label.textColor = .black
        headerView.addSubview(label)
        
        return headerView
    }
}

//MARK: UITableViewDataSource
extension CommentViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as? CommentTableViewCell else { return CommentTableViewCell()
        }
        cell.setData(comment: dataSources[indexPath.row])
        return cell
    }
    
}
