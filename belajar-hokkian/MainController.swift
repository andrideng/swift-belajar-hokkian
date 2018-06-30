//
//  ViewController.swift
//  belajar-hokkian
//
//  Created by Andri Deng on 7/7/17.
//  Copyright © 2017 Andri Deng. All rights reserved.
//

import UIKit
import Firebase

class MainController: UITableViewController {
    
    let cellId = "cellId"
    var kamuses = [Kamus]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        let img = UIImage(named: "add-icon")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: img, style: .plain, target: self, action: #selector(handleNewItem))
        
        self.checkIfUserLoggedIn()
        
        observeKamus()
        
        tableView.allowsMultipleSelectionDuringEditing = true
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let kamus = self.kamuses[indexPath.row]
        
        Database.database().reference().child("kamus").child(kamus.key!).removeValue { (err, ref) in
            if err != nil {
                
                return
            }
            
            // update the table
            self.kamuses.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            self.observeKamus()
        }
        
//        self.kamusDict.removeValueForKey
//        self.attemptReloadOfTable()
        
       
        
    }
    
    func observeKamus() {
        let ref = Database.database().reference().child("kamus")
        self.kamuses.removeAll()
        ref.observe(.childAdded, with: { (snapshot) in
            
            
            let value = snapshot.value as? NSDictionary
            
            let kamus = Kamus()
            kamus.key = snapshot.key
            kamus.indo = value?["indo"] as? String ?? ""
            kamus.hokkian = value?["hokkian"] as? String ?? ""
            
            self.kamuses.append(kamus)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }, withCancel: nil)
    }
    
    func handleNewItem() {
        let newItemCtrl = NewItemController()
//        let navCtrl = UINavigationController(rootViewController: newItemCtrl)
        present(newItemCtrl, animated: true, completion: nil)
    }
    
    
    func fetchUserAndSetupNavbarTitle() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
            let user = Users()
            user.name = value?["name"] as? String ?? ""
            
            self.navigationItem.title = user.name
        })
    }
    
    func setupNavbarWithUser(user: Users) {
        
    }
    
    func checkIfUserLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            performSelector(onMainThread: #selector(handleLogout), with: nil, waitUntilDone: false)
        } else {
            fetchUserAndSetupNavbarTitle()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kamuses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        
        let kamus = kamuses[indexPath.row]
        
        cell.textLabel?.text = kamus.hokkian
        cell.detailTextLabel?.text = kamus.indo
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let kamus = self.kamuses[indexPath.row]
        
        let alertCtrl = UIAlertController(title: kamus.indo, message: "Give a new value", preferredStyle: .alert)
        
        let updateAction = UIAlertAction(title: "Update", style: .default) { (_) in
            let key = kamus.key
            let indo = alertCtrl.textFields?[0].text
            let hokkian = alertCtrl.textFields?[1].text
            
            let kamus_value = [
                "indo": indo,
                "hokkian": hokkian
            ]
            Database.database().reference().child("kamus").child(key!).updateChildValues(kamus_value as Any as! [AnyHashable : Any], withCompletionBlock: { (err, snapshot) in
                if err != nil {
                    return
                }
                
                // update the table
                kamus.hokkian = kamus_value["hokkian"]!
                kamus.indo = kamus_value["indo"]!
                
                self.observeKamus()
            })
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (_) in }
        
        alertCtrl.addTextField { (textField) in textField.text = kamus.indo }
        alertCtrl.addTextField { (textField) in textField.text = kamus.hokkian }
        
        alertCtrl.addAction(cancelAction)
        alertCtrl.addAction(updateAction)
        
        
        present(alertCtrl, animated: true, completion: nil)
    }

}

