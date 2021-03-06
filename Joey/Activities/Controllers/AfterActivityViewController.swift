//
//  AfterActivityViewController.swift
//  Joey
//
//  Created by Toriq Wahid Syaefullah on 27/10/20.
//

import UIKit

class AfterActivityViewController: UIViewController {

    var data: FollowUp?
    var activityInstruction: ActivitiesInstruction?
    
    @IBOutlet weak var navBar: NavigationBar!
    @IBOutlet weak var suggestionLabel: UILabel!
    var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "page_background3")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI(){
        navBar.delegate = self
        suggestionLabel.text = activityInstruction?.acrivityAfterLabel
        self.view.insertSubview(imageView, at: 0)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    

    @IBAction func onStartButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "toInstruction", sender: nil)
    }
    
    @IBAction func onNoButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "toAnalyze", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? InstructionViewController {
            vc.activityInstruction = activityInstruction
        } else if let vc = segue.destination as? AnalyzingAfterActivityViewController {
            vc.data = data
        }
    }
    // MARK: - Navigation

}
