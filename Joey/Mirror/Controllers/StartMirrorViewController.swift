//
//  StartMirrorViewController.swift
//  Joey
//
//  Created by Toriq Wahid Syaefullah on 28/10/20.
//

import UIKit
import ARKit

class StartMirrorViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var labelInstruction: UILabel!
    @IBOutlet weak var navBar: NavigationBar!
    @IBOutlet weak var labelPrepare: UILabel!
    @IBOutlet weak var imgMascot: UIImageView!
    @IBOutlet weak var imgNext: UIImageView!
    @IBOutlet weak var imgPrev: UIImageView!
    @IBOutlet weak var labelTextHint: UILabel!
    @IBOutlet weak var viewHint: RoundedView!
    @IBOutlet weak var imgBubble: UIImageView!
    var isSmile: Bool = false
    
    var arrayHint = ["I’m getting stronger every day",
                     "I know my worth",
                     "I have the courage to say “NO”"]
    
    var countdownTimer: Timer!
    var totalTime: Int?
    var prepareTime = 3
    
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
        startPrepareTimer()
        navBar.delegate = self
        sceneView.delegate = self
        self.view.insertSubview(imageView, at: 0)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        labelPrepare.font = labelPrepare.font.withSize(48)
        viewHint.isHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        sceneView.session.run(configuration)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        sceneView.session.pause()
        countdownTimer.invalidate()
    }
    
    func handleSmile(smileValue: CGFloat) {
        if smileValue > 0.2 {
            isSmile = true
        }
        else {
            isSmile = false
        }
    }
    
    
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
    }
    
    func startPrepareTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updatePrepareTime), userInfo: nil, repeats: true)
    }
    
    @objc func updatePrepareTime() {
        labelPrepare.text = "\(prepareTimeFormatted(prepareTime))"
        
        if prepareTime != 0 {
            labelInstruction.text = "Start in \(prepareTime).."
            prepareTime -= 1
        } else {
            endTimer()
            startTimer()
            updateUI()
        }
    }
    
    private func updateUI(){
        labelInstruction.isHidden = true
        navBar.buttonDone.isHidden = false
        navBar.buttonDone.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector(self.onClickButtonDone)))
        labelPrepare.text = ""
        imgMascot.isHidden = true
        imgBubble.isHidden = true
        viewHint.isHidden = false
        labelPrepare.isHidden = true
        labelTextHint.text = arrayHint[Int.random(in: 0..<arrayHint.count)]
        imgPrev.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector(self.randomHint)))
        imgNext.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector(self.randomHint)))

    }
    
    @objc func onClickButtonDone(sender : UITapGestureRecognizer){
        endTimer()
        performSegue(withIdentifier: "toAfterActivity", sender: nil)
    }

    @objc func randomHint() {
        labelTextHint.text = arrayHint[Int.random(in: 0..<arrayHint.count)]
    }
    
    @objc func updateTime() {
        navBar.labelTitle.text = "\(timeFormatted(totalTime!))"
        if totalTime != 0 {
            totalTime! -= 1
        } else {
            endTimer()
            performSegue(withIdentifier: "toAfterActivity", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AfterActivityViewController {
            vc.activityInstruction = activitiesInstructionArray[0]
        }
    }
    
    func endTimer() {
        countdownTimer.invalidate()
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func prepareTimeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%2d", seconds)
    }
    
}

// MARK: - ARSCNView Delegate

extension StartMirrorViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else {
            return
        }
        
        let data = FaceData(faceAnchor)
        
//        DispatchQueue.main.async {
//            self.handleSmile(smileValue: CGFloat((data.mouthSmileLeft + data.mouthSmileRight)/2.0))
//        }
//
//        let workItem = DispatchWorkItem {
//            self.handleSmile(smileValue: CGFloat((data.mouthSmileLeft + data.mouthSmileRight)/2.0))
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: workItem)
        
    }
}

