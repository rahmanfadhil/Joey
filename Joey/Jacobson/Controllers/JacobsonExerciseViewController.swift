//
//  JacobsonExerciseViewController.swift
//  Joey
//
//  Created by Rahman Fadhil on 29/10/20.
//

import UIKit

class JacobsonExerciseViewController: UIViewController {

    @IBOutlet weak var instructionImage: UIImageView!
    @IBOutlet weak var exerciseLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    var delegate: JacobsonExerciseDelegate?
    var timer: Timer?
    var count = 300
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let exercise = delegate?.getExercise() {
            instructionImage.image = exercise.image
            exerciseLabel.text = exercise.name
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if count > 0 {
            let minutes = String(format: "%02d", count / 60)
            let seconds = String(format: "%02d", count % 60)
            timerLabel.text = "\(minutes):\(seconds)"
            count -= 1
        } else {
            timerLabel.text = "Time's up!"
        }
    }
    
    @IBAction func onBackButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onDoneButtonTapped(_ sender: Any) {
        delegate?.nextExercise()
        navigationController?.popViewController(animated: true)
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