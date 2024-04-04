//
//  SnapVC.swift
//  SnapchatClone
//
//  Created by Alican TARIM on 1.04.2024.
//

import UIKit
import ImageSlideshow

class SnapVC: UIViewController {

    //MARK: - UI Elements
    @IBOutlet weak var timeLabel: UILabel!
    
    //MARK: - Properties
    var selectedSnap: Snap?
    //var selectedTime: Int?
    var inputArray = [KingfisherSource]()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*if let time = selectedTime {
            timeLabel.text = "Time Left: \(time)"
        }*/
        
        if let snap = selectedSnap {
            
            timeLabel.text = "Time Left: \(snap.timeDifference)"
            
            for imageUrl in snap.imageUrlArray {
                inputArray.append(KingfisherSource(urlString: imageUrl)!)
            }
            // imageSlideShow u oluşturmak
            let imageSlideShow = ImageSlideshow(frame: CGRect(x: 10, y: 10, width: self.view.frame.width * 0.95, height: self.view.frame.height * 0.9))
            imageSlideShow.backgroundColor = UIColor.white
            
            let pageIndicator = UIPageControl()
            // Güncel hangi sayfadaysak onu gösteren indicator
            pageIndicator.currentPageIndicatorTintColor = UIColor.black
            // Geri kalanları gösteren indicator
            pageIndicator.pageIndicatorTintColor = UIColor.lightGray
            imageSlideShow.pageIndicator = pageIndicator
            
            // Resmi fit olarak orjinalini göstermek için
            imageSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFit
            imageSlideShow.setImageInputs(inputArray)
            self.view.addSubview(imageSlideShow)
            // Seçtiğimiz görünüm hep önde gösterilir.
            self.view.bringSubviewToFront(timeLabel)
            
        }

        
    }
    



}
