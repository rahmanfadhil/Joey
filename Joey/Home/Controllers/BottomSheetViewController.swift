//
//  BottomSheetViewController.swift
//  Joey
//
//  Created by Toriq Wahid Syaefullah on 18/10/20.
//

import UIKit
import Charts

class BottomSheetViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var bottomSheetScrollView: UIScrollView!
    @IBOutlet weak var activitiesCollectionView: UICollectionView!
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var labelUserName: UILabel!
    var listEmotion = [EmotionList]()
    var listEmotionByMonth = [EmotionList]()
    var emotionData: EmotionList!
    var listMonth = [String]()
    let emotionType = ["",
                       FollowUp.EmotionType.angry.description,
                       FollowUp.EmotionType.sad.description,
                       FollowUp.EmotionType.neutral.description,
                       FollowUp.EmotionType.happy.description]
    var selectedActivity: ActivitiesInstruction?
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        setupUI()
        getEmotionHistory()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        getEmotionHistory()
    }
    @IBAction func onClickButtonLogout(_ sender: UIButton) {
        UserDefaultsHelper.setData(value: false, key: .isLoggedIn)
        self.navigationController?.popViewController(animated: true)
        if let vc = UIStoryboard(name: "Onboarding", bundle: nil).instantiateViewController(withIdentifier: "InitialOnboarding") as? OnboardingViewController {
            if let navigator = navigationController {
                navigator.pushViewController(vc, animated: true)
            }
        }
    }
    func registerNib() {
        let nib = UINib(nibName: ActivitiesCollectionViewCell.nibName, bundle: nil)
        activitiesCollectionView?.register(nib, forCellWithReuseIdentifier: ActivitiesCollectionViewCell.reuseIdentifier)
        if let flowLayout = self.activitiesCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 109, height: 155)
        }
    }
    func setupUI(){
        self.sheetViewController?.handleScrollView(self.bottomSheetScrollView)
        labelUserName.text = UserDefaultsHelper.getData(type: String.self, forKey: .userName)
    }
    func getEmotionHistory(){
        EmotionHelper.list { (list: [Emotion], _: Error?) in
            list.forEach { emotion in
                let date = emotion.value(forKey: "testedAt") as! Date
                let emotionType = emotion.value(forKey: "emotion") as! Int
                let formatDate = date.getFormattedDate(format: "EEEE, MMMM d yyyy, h:mm a")
                let formatDay = date.getFormattedDate(format: "d")
                let formatMonth = date.getFormattedDate(format: "MMMM")

                self.listEmotion.append(EmotionList(
                                            emotion: FollowUp.EmotionType(rawValue: emotionType)!,
                                            reason: emotion.value(forKey: "reason") as! String,
                                            scale: emotion.value(forKey: "scale") as! Float,
                                            date: formatDate,
                                            day: Int(formatDay)!,
                                            month: formatMonth))
                
                self.listMonth.append(formatMonth)
            }
        }
        
        DispatchQueue.main.async {
            self.listMonth = self.listMonth.unique()
            self.setupChart(month: self.listMonth.last!)
            self.listEmotion.reverse()
        }
        
    }
    func setupChart(month: String){
        barChartView.delegate = self
        barChartView.chartDescription?.enabled = false
        barChartView.dragEnabled = true
        barChartView.setScaleEnabled(false)
        barChartView.pinchZoomEnabled = false
        
        barChartView.rightAxis.enabled = false
        barChartView.xAxis.enabled = true
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.leftAxis.drawGridLinesEnabled = false
        barChartView.legend.enabled = false
        
        barChartView.animate(xAxisDuration: 2.5)
        
        var barChartEntry = [BarChartDataEntry]()
        
        listEmotionByMonth.removeAll()
        for i in 0..<listEmotion.count {
            if listEmotion[i].month == month {
                listEmotionByMonth.append(listEmotion[i])
                let value = BarChartDataEntry(x: Double(listEmotion[i].day), y: Double(listEmotion[i].emotion.rawValue))
                barChartEntry.append(value)
            }
        }
        let barChart = BarChartDataSet(entries: barChartEntry)
        barChart.setColor(UIColor(red: 0.35, green: 0.76, blue: 0.74, alpha: 1.00))
        barChart.drawValuesEnabled = false
        
        let lineChartData = BarChartData()
        lineChartData.addDataSet(barChart)
        barChartView.leftAxis.valueFormatter = IndexAxisValueFormatter(values: emotionType)
        barChartView.xAxis.granularity = 5
        barChartView.xAxis.axisMinimum = 1
        barChartView.xAxis.axisMaximum = 31
        barChartView.leftAxis.granularity = 1
        barChartView.leftAxis.axisMinimum = 0
        barChartView.leftAxis.axisMaximum = 4

        barChartView.data = lineChartData
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? InstructionViewController {
            vc.activityInstruction = selectedActivity
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

extension BottomSheetViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return activitiesInstructionArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActivitiesCollectionViewCell.reuseIdentifier,
                                                         for: indexPath) as? ActivitiesCollectionViewCell {
            cell.configureCell(label: activitiesInstructionArray[indexPath.row].title, image: activitiesInstructionArray[indexPath.row].activityHomeImage)
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedActivity = activitiesInstructionArray[indexPath.row]
        performSegue(withIdentifier: "toInstruction", sender: nil)
    }
    
}
//extension BottomSheetViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        guard let cell: ActivitiesCollectionViewCell = Bundle.main.loadNibNamed(ActivitiesCollectionViewCell.nibName,
//                                                                      owner: self,
//                                                                      options: nil)?.first as? ActivitiesCollectionViewCell else {
//            return CGSize.zero
//        }
//        cell.configureCell(label: activityList[indexPath.row].label, image: activityList[indexPath.row].image)
//        cell.setNeedsLayout()
//        cell.layoutIfNeeded()
//        let size: CGSize = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
//        return CGSize(width: size.width, height: size.height)
//    }
//}
