//
//  FeedVC.swift
//  SnapchatClone
//
//  Created by Alican TARIM on 1.04.2024.
//

import UIKit
import Firebase
import SDWebImage

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: - UI Elements
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    let fireStoreDatabase = Firestore.firestore()
    var snapArray = [Snap]()
    var chosenSnap: Snap?
    //var timeLeft: Int?
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getSnapsFromFirebase()
        getUserInfo()
        
    }
    
    //MARK: - Functions
    func getSnapsFromFirebase() {
        // descending -> En güncel en üstte çıkması için
        fireStoreDatabase.collection("Snaps").order(by: "date", descending: true).addSnapshotListener { snapshot, error in
            if error != nil {
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
            } else {
                if snapshot?.isEmpty == false && snapshot != nil {
                    self.snapArray.removeAll(keepingCapacity: false)
                    for document in snapshot!.documents {
                        
                        let documentId = document.documentID
                        
                        if let username = document.get("snapOwner") as? String {
                            if let imageUrlArray = document.get("imageUrlArray") as? [String] {
                                if let date = document.get("date") as? Timestamp {
                                    // Kaydedilen date.dateValue() dan şu anki güncel zamanı Data().hour alıyor ve çıkartıyor.
                                    // ve kaç saat fark var aralarında onu veriyor.
                                    if let difference = Calendar.current.dateComponents([.hour], from: date.dateValue(), to: Date()).hour {
                                        if difference >= 24 {
                                            // Delete
                                            self.fireStoreDatabase.collection("Snaps").document(documentId).delete { error in
                                                
                                            }
                                        } else {
                                            print("difference: \(date.dateValue())")
                                            //TIMELEFT -> SNAPVC
                                            //self.timeLeft = 24 - difference
                                            
                                            let snap = Snap(username: username, imageUrlArray: imageUrlArray, date: date.dateValue(), timeDifference: 24 - difference)
                                            self.snapArray.append(snap)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
    func getUserInfo() {
        //
        fireStoreDatabase.collection("UserInfo").whereField("email", isEqualTo: Auth.auth().currentUser!.email!).getDocuments { snapshot, error in
            if error != nil {
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
            } else {
                if snapshot?.isEmpty == false && snapshot != nil {
                    for document in snapshot!.documents {
                        if let username = document.get("username") as? String {
                            UserSingleton.sharedUserInfo.email = Auth.auth().currentUser!.email!
                            UserSingleton.sharedUserInfo.username = username
                        }
                    }
                }
            }
        }
    }
    
    
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
                                      
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snapArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedTableViewCell
        cell.feedUserNameLabel.text = snapArray[indexPath.row].username
        cell.feedImageView.sd_setImage(with: URL(string: snapArray[indexPath.row].imageUrlArray[0]))
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSnapVC" {
            let destinationVC = segue.destination as! SnapVC
            destinationVC.selectedSnap = chosenSnap
            //destinationVC.selectedTime = self.timeLeft
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenSnap = self.snapArray[indexPath.row]
        performSegue(withIdentifier: "toSnapVC", sender: nil)
    }
    

 

}
