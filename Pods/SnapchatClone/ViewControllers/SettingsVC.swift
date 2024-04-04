//
//  SettingsVC.swift
//  SnapchatClone
//
//  Created by Alican TARIM on 1.04.2024.
//

import UIKit
import Firebase

class SettingsVC: UIViewController {

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: - Actions
    @IBAction func logOutButtonTapped(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toSignInVC", sender: nil)
        } catch {
            
        }
    }
    

}
