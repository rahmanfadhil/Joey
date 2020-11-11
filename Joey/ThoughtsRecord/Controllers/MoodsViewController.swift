//
//  MoodsViewController.swift
//  Joey
//
//  Created by Setiawan Joddy on 27/10/20.
//

import UIKit

class MoodsViewController: UIViewController {
    
    var data: ThoughtsRecordTemp?
    
    var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "page_background3")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    @IBOutlet weak var navBar: NavigationBar!
    @IBOutlet weak var otherButton: RoundedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickContinueButton(_ sender: Any) {
        if data?.moods.isEmpty == true {
            let alert = AlertHelper.createAlert(title: "Oops!", message: "Please tell me what's on your mind before we go on", onComplete: nil)
            alert.view.tintColor = #colorLiteral(red: 0.3529411765, green: 0.7607843137, blue: 0.7411764706, alpha: 1)
            present(alert, animated: true, completion: nil)
        }
        else {
            performSegue(withIdentifier: "toAutoThoughts", sender: nil)
        }
    }
    
    @IBAction func othersTapped(_ sender: Any) {
        let alert = UIAlertController(title: "How do you feel about that?", message: "Tell me what you feel :)", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = ""
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            self.data?.moods.append((textField?.text)!)
            self.otherButton.backgroundColor = #colorLiteral(red: 0.4125145674, green: 0.7986539006, blue: 0.7881773114, alpha: 1)
            self.otherButton.setTitleColor(.white, for: .normal)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func answerTapped(_ sender: UIButton) {
        if !sender.isSelected {
            sender.backgroundColor = #colorLiteral(red: 0.3529411765, green: 0.7607843137, blue: 0.7411764706, alpha: 1)
            sender.setTitleColor(.white, for: .normal)
            sender.tintColor = .clear
            sender.isSelected = true
            data?.moods.append(sender.titleLabel!.text!)
        }
        else {
            sender.backgroundColor = .white
            sender.setTitleColor(.black, for: .normal)
            sender.isSelected = false
            if let index = data?.moods.firstIndex(of: sender.titleLabel!.text!) {
                data?.moods.remove(at: index)
            }
        }
        print(data?.moods)
    }
    
    func setupUI(){
        navBar.delegate = self
        navBar.labelIndicator.text = "2/7"
        self.view.insertSubview(imageView, at: 0)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AutomaticThoughtsViewController {
            vc.data = data
        }
    }
    
    
}
