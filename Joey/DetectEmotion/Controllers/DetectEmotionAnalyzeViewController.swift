//
//  DetectEmotionAnalyzeViewController.swift
//  Joey
//
//  Created by Rahman Fadhil on 19/10/20.
//

import UIKit
import ARKit

class DetectEmotionAnalyzeViewController: UIViewController {

    @IBOutlet weak var navBar: NavigationBar!
    var emotion: FollowUp.EmotionType?
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        navBar.delegate = self
        
        let backgroundTapGesture = UITapGestureRecognizer(target: self, action: #selector(sceneViewTapped))
        view.addGestureRecognizer(backgroundTapGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let configuration = ARFaceTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        sceneView.session.pause()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DetectEmotionValidateViewController, let emotion = emotion {
            vc.data = FollowUp(emotion: emotion)
        }
    }

    // MARK: - Gesture Recognizer
    
    @objc func sceneViewTapped() {
        if emotion == nil {
            let alert = AlertHelper.createAlert(title: "Analyzing failed!", message: "Please put your face on the frame properly.", onComplete: nil)
            present(alert, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "toQuestions", sender: nil)
        }
    }
}

// MARK: - ARSCNView Delegate

extension DetectEmotionAnalyzeViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }

        let data = FaceData(faceAnchor)

        if data.browDownRight > 0.3 && data.browDownLeft > 0.3 {
            emotion = .angry
        } else if data.mouthFrownRight > 0.3 && data.mouthFrownLeft > 0.3 {
            emotion = .sad
        } else if data.mouthSmileRight > 0.3 && data.mouthSmileLeft > 0.3 {
            emotion = .happy
        } else {
            emotion = .neutral
        }
    }
}
