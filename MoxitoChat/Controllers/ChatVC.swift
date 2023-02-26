//
//  ChatVC.swift
//  MoxitoChat
//
//  Created by Mirsaidov Bekzod on 26/02/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


class ChatVC: UIViewController {
    
    @IBOutlet weak var chattingTF: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var messages: [Message] = []
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = K.appName
        setupLogOutBarButton()
        setupTableView()
        loadMessages()
    }
    
    
    //MARK: setup functions
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.messageTCV, bundle: nil), forCellReuseIdentifier: K.messageTCV)
    }
    
    //TODO: navigation items setup
    func setupLogOutBarButton() {
        navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out",
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(rightHandAction))
    }
    @objc func rightHandAction() {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    @IBAction func sendBtnPressed(_ sender: UIButton) {
        if let messageBody = chattingTF.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.senderField : messageSender,
                K.FStore.bodyField : messageBody,
                K.FStore.dataField : Date().timeIntervalSince1970
            ]) { (error) in
                if let e = error {
                    print("There was an issue saving data to firestore, \(e)")
                } else {
                    print("Successfully saved data☑️")
                    
                    DispatchQueue.main.async {
                        self.chattingTF.text = ""
                    }
                }
                
            }
        }
    }
    
    //MARK: - Saving Data functions
    
    func loadMessages() {
        db.collection(K.FStore.collectionName).order(by: K.FStore.dataField).addSnapshotListener { (querySnapshot, error) in
            self.messages = []
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String {
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
}
//MARK: - tableView Delegate and DataSource
extension ChatVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.messageTCV, for: indexPath) as! MessageTVC
        cell.label.text = message.body
        cell.selectionStyle = .none
        //this message from the current user
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBuble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        }
        //This message from another sender
        else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBuble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
        return cell
    }
    
    //MARK: - Swipe Actions
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Archieve") { [weak self] (action, view, competionHandler) in
            self?.handleMarkAsArchieve()
            competionHandler(true)
        }
        action.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .none
    }
    
    //MARK: - Handling swipe actions funcs
    
    private func handleMarkAsArchieve() {
        print("Moved to favourites")
    }
    private func handleMarkAsUnread() {
        print("Marked as unread")
    }
    private func handleMoveToTrash() {
        print("Moved to trash")
        
    }
    
    
}
