//
//  NewItemController.swift
//  belajar-hokkian
//
//  Created by Andri Deng on 7/10/17.
//  Copyright © 2017 Andri Deng. All rights reserved.
//

import UIKit
import Firebase

class NewItemController: UIViewController {

    let cellId = "cellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        view.addSubview(btnBack)
        
        self.setupBackButton()
        self.setupContent()
        
//        tableView.register(<#T##cellClass: AnyClass?##AnyClass?#>, forCellReuseIdentifier: cellId)
    }
    
    let inputContainerView: UIView = {
        let view = UIView();
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }();
    
    let btnBack : UIButton = {
       let btn = UIButton()
        btn.backgroundColor = UIColor.black
        btn.setTitle("Back", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        
        return btn
    }()
    
    func setupBackButton() {
        //x,y,w,h
        btnBack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        btnBack.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        btnBack.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        btnBack.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    
    let indoTextField: UITextField = {
       let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Indonesian Word"
        
        return tf
    }()
    
    let indoSeparatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        
        return view
    }()
    
    let hokkianTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Hokkian Word"
        
        return tf
    }()
    
    let hokkianSeparatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        
        return view
    }()
    
    let btnAdd: UIButton = {
       let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Add", for: .normal)
        btn.backgroundColor = UIColor.gray
        btn.addTarget(self, action: #selector(handleAdd), for: .touchUpInside)
        
        return btn
    }()
    
    func handleAdd() {
        let ref = Database.database().reference().child("kamus")
        let childRef = ref.childByAutoId()
        
        let userId = Auth.auth().currentUser!.uid
        let timestamp: Int = Int(NSDate().timeIntervalSince1970)
        
        let values = ["userId": userId, "timestamp": timestamp, "indo": indoTextField.text!, "hokkian": hokkianTextField.text!] as [String : Any]
        
        childRef.updateChildValues(values) { (err, ref) in
            if err != nil {
                let alert = UIAlertController(title: "Error", message: err?.localizedDescription, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                return
            }
            
            self.indoTextField.text = nil
            self.hokkianTextField.text = nil
            
            let alert = UIAlertController(title: "Sucess", message: "Success Insert Kamus!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
    
        
    }
    
    func setupContent() {
        view.addSubview(indoTextField)
        view.addSubview(indoSeparatorView)
        
        //x,y,w,h
        indoTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indoTextField.topAnchor.constraint(equalTo: btnBack.bottomAnchor).isActive = true
        indoTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -12).isActive = true
        indoTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //x,y,w,h
        indoSeparatorView.leftAnchor.constraint(equalTo: indoTextField.leftAnchor).isActive = true
        indoSeparatorView.topAnchor.constraint(equalTo: indoTextField.bottomAnchor).isActive = true
        indoSeparatorView.widthAnchor.constraint(equalTo: indoTextField.widthAnchor).isActive = true
        indoSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        view.addSubview(hokkianTextField)
        view.addSubview(hokkianSeparatorView)
        
        //x,y,w,h
        hokkianTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        hokkianTextField.topAnchor.constraint(equalTo: indoSeparatorView.bottomAnchor).isActive = true
        hokkianTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -12).isActive = true
        hokkianTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //x,y,w,h
        hokkianSeparatorView.leftAnchor.constraint(equalTo: hokkianTextField.leftAnchor).isActive = true
        hokkianSeparatorView.topAnchor.constraint(equalTo: hokkianTextField.bottomAnchor).isActive = true
        hokkianSeparatorView.widthAnchor.constraint(equalTo: hokkianTextField.widthAnchor).isActive = true
        hokkianSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        view.addSubview(btnAdd)
        
        //x,y,w,h
        btnAdd.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        btnAdd.topAnchor.constraint(equalTo: hokkianSeparatorView.topAnchor, constant: 12).isActive = true
        btnAdd.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        btnAdd.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

}
