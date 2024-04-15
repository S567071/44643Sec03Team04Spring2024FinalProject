//
//  HomeVC.swift
//  44643Sec03Team04Spring2024FinalProject
//
//  Created by Pranathi Reddy Jeedipally on 4/12/24.
//

import UIKit
import Lottie

class HomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("username: \(AppDelegate.username)")

        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var home: LottieAnimationView! {
        didSet{
            home.animation = LottieAnimation.named("Animation")
            home.loopMode = .loop
            home.alpha = 1.0
            home.play{ [weak self]  _ in
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: 1.0,
                    delay: 0.0,
                    options: [.curveEaseInOut]) {
                        self?.home.alpha = 0.0
                    }
            }
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
