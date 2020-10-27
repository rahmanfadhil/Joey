//
//  SituationViewController.swift
//  Joey
//
//  Created by Setiawan Joddy on 26/10/20.
//

import UIKit

class SituationViewController: UIViewController, UITextViewDelegate {
    
    var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "page_background3")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    @IBOutlet weak var textViewSituationAnswer: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        textViewPlaceholder()

        // Do any additional setup after loading the view.
    }
    
    func setupUI(){
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.view.insertSubview(imageView, at: 0)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func textViewPlaceholder() {
        textViewSituationAnswer.delegate = self
        textViewSituationAnswer.text = "Type your answer here"
        textViewSituationAnswer.textColor = UIColor.lightGray
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
