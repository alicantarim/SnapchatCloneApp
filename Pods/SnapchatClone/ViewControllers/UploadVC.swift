//
//  UploadVC.swift
//  SnapchatClone
//
//  Created by Alican TARIM on 1.04.2024.
//

import UIKit
import Firebase
import FirebaseStorage

class UploadVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: - UI Elementes
    @IBOutlet weak var uploadImageView: UIImageView!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // uploadImageView'in tıklanabilir özelliğini açıyoruz.
        uploadImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(choosePicture))
        uploadImageView.addGestureRecognizer(gestureRecognizer)

    }
    
    //MARK: - Functions
    @objc func choosePicture() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true)
    }
    
    // Seçildiğinde ne olacak..
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        uploadImageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Actions
    @IBAction func uploadButtonTapped(_ sender: Any) {
        
        // STORAGE
        
        let storage = Storage.storage()
        let storageReference = storage.reference()
        // Görselleri koyacağımız klasör
        let mediaFolder = storageReference.child("media")
        // ImageView'daki görseli alıp data'ya çevirme
        if let data = uploadImageView.image?.jpegData(compressionQuality: 0.5) {
            // Media'ya kaydederken UUID ismiyle kaydedeceğimiz için UUID oluşturuyoruz.
            let uuid = UUID().uuidString
            // ve sonuna jpeg ekliyoruz formatını belirtiyoruz.
            let imageReference = mediaFolder.child("\(uuid).jpg")
            
            imageReference.putData(data, metadata: nil) { metadata, error in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                } else {
                    imageReference.downloadURL { url, error in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                            
                            // FİRESTORE 'a kaydetmek
                            let fireStore = Firestore.firestore()
                            // Kullanıcının daha önce kaydettiği bir snap var mı onu aldık.
                            fireStore.collection("Snaps").whereField("snapOwner", isEqualTo: UserSingleton.sharedUserInfo.username).getDocuments { snapshot, error in
                                if error != nil {
                                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                                } else {
                                    if snapshot?.isEmpty == false && snapshot != nil {
                                        for document in snapshot!.documents {
                                            // Doküman Id alıyoruz. Daha önce oluşturduğumuz doküman varsa bunun üzerinde işlem yapacağız. Tekrar ayrı bir doküman açmamak için
                                            let documentId = document.documentID
                                            
                                            if var imageUrlArray = document.get("imageUrlArray") as? [String] {
                                                imageUrlArray.append(imageUrl!)
                                                // Tekrar o dokuman içerisine yeni dokumanı ekliyoruz.
                                                let additionalDictionary = ["imageUrlArray" : imageUrlArray] as [String : Any]
                                                // merge -> Eski değerleri tut üzerine ekle birleştir.
                                                fireStore.collection("Snaps").document(documentId).setData(additionalDictionary, merge: true) { error in
                                                    if error != nil {
                                                        self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                                                    } else {
                                                        self.tabBarController?.selectedIndex = 0
                                                        self.uploadImageView.image = UIImage(named: "selectImage.png")
                                                    }
                                                }
                                            }
                                        }
                                    } else { //Snapshot yoksa kullanıcı hiç bir şey koymamıştır. O yüzden yeni oluşturuyoruz.
                                        let snapDictionary = ["imageUrlArray" : [imageUrl!], "snapOwner" : UserSingleton.sharedUserInfo.username, "date" : FieldValue.serverTimestamp()] as [String : Any]
                                        
                                        fireStore.collection("Snaps").addDocument(data: snapDictionary) { error in
                                            if error != nil {
                                                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                                            } else {
                                                self.tabBarController?.selectedIndex = 0
                                                self.uploadImageView.image = UIImage(named: "selectImage.png")
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    

    
    
}
