//
//  BaseController.swift
//  ReportsX
//
//  Created by Mustafa MEDENi on 3.10.2020.
//

import UIKit

fileprivate extension Selector {
    static let endEditingForce = #selector(BaseController.endEditingForce)
}

class BaseController: UIViewController {

    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?{
        didSet{
            self.handleKeypadVisibility()
        }
    }


    var keyboardHeightSpace: CGFloat = 20
    let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: .endEditingForce)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackButton()

        tapGesture.cancelsTouchesInView = false // Fixes UICollectionView didSelect long press bug inside the views

        // Do any additional setup after loading the view.
    }


    
    /// Handles keypad visibility
    func handleKeypadVisibility() {
        self.view.addGestureRecognizer(tapGesture)

        // Add Notification to handle keyboard selections
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(_:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
    }

    /// Sets backbutton of general UINavigationController
    func setBackButton() {
        self.navigationController?.navigationBar.topItem?.title = ""
         self.navigationController?.navigationBar.backIndicatorImage = nil
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = nil
    }
    
    @IBAction func dismissAppend(){
        self.dismiss(animated: true, completion: nil)
    }

    /// Resigns first responders
    @objc @IBAction func endEditingForce() {
        self.view.endEditing(true)
    }

    // Deinitilaze notification
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    /// Notifies view that keyboard will change frame and sets sticky button's constraint's constants recording it.
    ///
    /// - Parameter notification: NSNotification.Name
    @objc func keyboardNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions().rawValue
            let animationCurve: UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                self.keyboardHeightLayoutConstraint?.constant = keyboardHeightSpace
            } else {
                self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 0.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.setNeedsLayout() },
                           completion: nil)
        }
    }

}


