//
//  WheelViewContoller.swift
//  The Wheely Cool App
//
//  Created by Hasitha De Mel on 20/12/21.
//

import UIKit
import Combine
import SwiftFortuneWheel

class WheelViewContoller: UIViewController {

    var viewModel: WheelViewModel!
    private var cancellables: Set<AnyCancellable> = []
    
    @IBOutlet weak var congratzLabel: UILabel!
    
    @IBOutlet weak var centerView: UIView! {
        didSet {
            centerView.layer.cornerRadius = centerView.bounds.width / 2
            centerView.layer.borderColor = CGColor.init(srgbRed: CGFloat(256), green: CGFloat(256), blue: CGFloat(256), alpha: 1)
            centerView.layer.borderWidth = 7
        }
    }
    
    @IBOutlet weak var wheelControl: SwiftFortuneWheel! {
        didSet {
            wheelControl.configuration = .variousWheelSimpleConfiguration
            wheelControl.slices = slices
            wheelControl.pinImage = "redArrow"
            
            
            wheelControl.pinImageViewCollisionEffect = CollisionEffect(force: 8, angle: 20)
            
            wheelControl.edgeCollisionDetectionOn = true
        }
    }
    
    lazy var slices: [Slice] = {
        let slices = viewModel.options.map({ Slice.init(contents: [Slice.ContentType.text(text: $0, preferences: .variousWheelSimpleConfiguration)]) })
        return slices
    }()

    override func viewDidLoad() {
        congratzLabel.isHidden = true
        navigationItem.title = "The Wheel"
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        centerView.layer.cornerRadius = centerView.bounds.width / 2
    }
    
    @IBAction func rotateTap(_ sender: Any) {
        congratzLabel.isHidden = true
        let finishedIndex = Int.random(in: 0..<wheelControl.slices.count)
        wheelControl.startRotationAnimation(finishIndex: finishedIndex, continuousRotationTime: 1) { (finished) in
            self.congratzLabel.isHidden = false
            self.congratzLabel.text = "Congratulations " + self.viewModel.optionAt(index: finishedIndex)
            print(finished)
        }
    }
    
}
