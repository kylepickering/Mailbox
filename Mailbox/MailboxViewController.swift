//
//  MailboxViewController.swift
//  Mailbox
//
//  Created by Kyle Pickering on 9/24/14.
//  Copyright (c) 2014 Kyle Pickering. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController {

    @IBOutlet weak var messageImage: UIImageView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var laterImage: UIImageView!
    @IBOutlet weak var archiveImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var feedImage: UIImageView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var optionsImage: UIImageView!
    @IBOutlet weak var navOptions: UISegmentedControl!
    @IBOutlet weak var listOptionsImage: UIImageView!
    @IBOutlet weak var navImage: UIImageView!
    @IBOutlet weak var composeView: UIView!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var composeImage: UIImageView!
    @IBOutlet weak var archiveScrollView: UIScrollView!
    @IBOutlet weak var laterScrollView: UIScrollView!
    
    var laterImageCenter: CGPoint!
    var archiveImageCenter: CGPoint!
    var imageCenter: CGPoint!
    var mainViewCenter: CGPoint!
    var panGesture: UIPanGestureRecognizer!
    
    //Colors
    let mailboxGreen: UIColor = UIColor(red: 136/255, green: 208/255, blue: 98/255, alpha: 1)
    let mailboxRed: UIColor = UIColor(red: 220/255, green: 97/255, blue: 49/255, alpha: 1)
    let mailboxYellow: UIColor = UIColor(red: 250/255, green: 207/255, blue: 61/255, alpha: 1)
    let mailboxBrown: UIColor = UIColor(red: 209/255, green: 166/255, blue: 122/255, alpha: 1)
    let mailboxGrey: UIColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1)
    let mailboxBlue: UIColor = UIColor(red: 112/255, green: 197/255, blue: 224/255, alpha: 1)
    
    //Images
    let archiveIconImage: UIImage = UIImage(named: "archive_icon")
    let deleteIconImage: UIImage = UIImage(named: "delete_icon")
    let laterIconImage: UIImage = UIImage(named: "later_icon")
    let listIconImage: UIImage = UIImage(named: "list_icon")
    let defaultNavImage: UIImage = UIImage(named: "nav")
    let composeNavImage: UIImage = UIImage(named: "compose_nav")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        scrollView.contentSize.height = feedImage.frame.size.height + messageImage.frame.size.height + 42
        
        var edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "onEdgePan:")
        edgeGesture.edges = UIRectEdge.Left
        mainView.addGestureRecognizer(edgeGesture)
        panGesture = UIPanGestureRecognizer(target: self, action: "onMainViewPan:")
        composeView.hidden = true
        composeView.frame.origin.x = 0
        
        archiveScrollView.contentSize.height = feedImage.frame.size.height
        archiveScrollView.frame.origin.x = 320
        
        laterScrollView.contentSize.height = feedImage.frame.size.height
        laterScrollView.frame.origin.x = -320
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onEdgePan(gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        var location = gestureRecognizer.locationInView(view)
        var translation = gestureRecognizer.translationInView(view)
        var velocity = gestureRecognizer.velocityInView(view)

        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            mainViewCenter = mainView.center
        } else if gestureRecognizer.state == UIGestureRecognizerState.Changed {
            mainView.center.x = translation.x + mainViewCenter.x
        } else if gestureRecognizer.state == UIGestureRecognizerState.Ended {
            if velocity.x > 0 {
                openDrawer()
            } else {
                closeDrawer()
            }
        }
    }
    
    func onMainViewPan(gestureRecognizer: UIPanGestureRecognizer) {
        var location = gestureRecognizer.locationInView(view)
        var translation = gestureRecognizer.translationInView(view)
        var velocity = gestureRecognizer.velocityInView(view)
        
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            mainViewCenter = mainView.center
        } else if gestureRecognizer.state == UIGestureRecognizerState.Changed {
            mainView.center.x = translation.x + mainViewCenter.x
        } else if gestureRecognizer.state == UIGestureRecognizerState.Ended {
            if velocity.x < 0 {
                closeDrawer()
            } else {
                openDrawer()
            }
        }
    }
    
    func openDrawer(){
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.mainView.frame.origin.x = 285
        }, completion: { (finished: Bool) -> Void in
            self.mainView.addGestureRecognizer(self.panGesture)
        })
    }
    
    func closeDrawer(){
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.mainView.frame.origin.x = 0
        }, completion: { (finished: Bool) -> Void in
            self.mainView.removeGestureRecognizer(self.panGesture)
        })
    }
    
    @IBAction func onHamburgerButton(sender: AnyObject) {
        openDrawer()
    }
    
    @IBAction func onSwipe(gestureRecognizer: UIPanGestureRecognizer) {
        
        var location = gestureRecognizer.locationInView(view)
        var translation = gestureRecognizer.translationInView(view)
        var velocity = gestureRecognizer.velocityInView(view)
        
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            imageCenter = messageImage.center
            
            archiveImage.alpha = 0
            archiveImage.frame.origin.x = 17
            archiveImageCenter = archiveImage.center
            
            laterImage.frame.origin.x = 280
            laterImage.alpha = 0
            laterImageCenter = laterImage.center
        } else if gestureRecognizer.state == UIGestureRecognizerState.Changed {
            messageImage.center.x = translation.x + imageCenter.x
            switch translation.x {
                case 0...60:
                    var iconAlpha = convertValue(Float(translation.x), r1Min: 30, r1Max: 60, r2Min: 0, r2Max: 1)
                    messageView.backgroundColor = mailboxGrey
                    archiveImage.alpha = CGFloat(iconAlpha)
                case 61...260:
                    messageView.backgroundColor = mailboxGreen
                    archiveImage.center.x = (translation.x - 60) + archiveImageCenter.x
                    archiveImage.image = archiveIconImage
                case 261...320:
                    messageView.backgroundColor = mailboxRed
                    archiveImage.image = deleteIconImage
                    archiveImage.center.x = (translation.x - 60) + archiveImageCenter.x
                case -60...0:
                    var iconAlpha = convertValue(Float(translation.x), r1Min: -30, r1Max: -60, r2Min: 0, r2Max: 1)
                    messageView.backgroundColor = mailboxGrey
                    laterImage.alpha = CGFloat(iconAlpha)
                case -260...(-61):
                    messageView.backgroundColor = mailboxYellow
                    laterImage.center.x = (translation.x + 60) + laterImageCenter.x
                    laterImage.image = laterIconImage
                case -320...(-261):
                    messageView.backgroundColor = mailboxBrown
                    laterImage.image = listIconImage
                    laterImage.center.x = (translation.x + 60) + laterImageCenter.x
                default:
                    messageView.backgroundColor = mailboxGrey
            }

        } else if gestureRecognizer.state == UIGestureRecognizerState.Ended {
            
            switch translation.x {
                case 0...60:
                    returnMessage()
                case 61...260:
                    archiveMessage()
                case 261...320:
                    archiveMessage()
                case -60...0:
                    returnMessage()
                case -260...(-61):
                    showLaterOptions()
                case -320...(-261):
                    showListOptions()
                default:
                    returnMessage()
            }
        }
    }
    
    func showLaterOptions() {
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.messageImage.frame.origin.x = -320
            self.laterImage.frame.origin.x = -320
            self.laterImage.alpha = 0
        }) { (finished:Bool) -> Void in
            self.optionsImage.alpha = 1
        }
    }
    
    @IBAction func onOptionsTap(sender: AnyObject) {
        laterMessage()
    }
    
    @IBAction func onListOptionsTap(sender: AnyObject) {
        listMessage()
    }
    
    func returnMessage() {
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.messageImage.frame.origin.x = 0
        })
    }
    
    func laterMessage() {
        optionsImage.alpha = 0
        removeMessage()
    }
    
    func listMessage() {
        listOptionsImage.alpha = 0
        removeMessage()
    }
    
    func archiveMessage() {
        self.laterImage.alpha = 0
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.messageImage.frame.origin.x = 320
            self.archiveImage.frame.origin.x = 320
            self.archiveImage.alpha = 0
            
        }) { (finished:Bool) -> Void in
            self.removeMessage()
        }
    }
    
    func showListOptions() {
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.messageImage.frame.origin.x = -320
            self.laterImage.frame.origin.x = -320
            self.laterImage.alpha = 0
            }) { (finished:Bool) -> Void in
                self.listOptionsImage.alpha = 1
        }
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: (UIEvent!)) {
        if(event.subtype == UIEventSubtype.MotionShake) {
            if scrollView.contentInset.top < 0 {
                undo()
            }
        }
    }
    
    func undo() {
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.messageImage.frame.origin.x = 0
            self.messageView.frame.origin.y = 0
            self.messageView.frame.origin.x = 0
            self.scrollView.contentInset.top += 86
            self.scrollView.contentOffset.y = 0
            self.archiveImage.alpha = 1
            self.messageView.alpha = 1
            self.laterImage.alpha = 1
        })
    }
    
    func removeMessage() {
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.messageView.alpha = 0
            self.scrollView.contentInset.top -= 86
        })
    }
    
    func convertValue(value: Float, r1Min: Float, r1Max: Float, r2Min:
        Float, r2Max: Float) -> Float {
            var ratio = (r2Max - r2Min) / (r1Max - r1Min)
            return value * ratio + r2Min - r1Min * ratio
    }

    @IBAction func onComposeButton(sender: AnyObject) {
        composeImage.alpha = 0
        composeImage.frame.origin.y += 300
        composeView.hidden = false;

        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.composeImage.alpha = 1
            self.composeImage.frame.origin.y -= 300
            }) { (finished:Bool) -> Void in
            // here
        }
        toTextField.becomeFirstResponder()
    }

    @IBAction func onCancelButton(sender: AnyObject) {
        composeView.hidden = true;
        composeView.endEditing(true)
    }
    
    @IBAction func onNavOptionsControl(sender: AnyObject) {
        switch navOptions.selectedSegmentIndex {
            case 0:
                navOptions.tintColor = mailboxYellow
                showLaterScrollView()
            case 1:
                navOptions.tintColor = mailboxBlue
                showInboxScrollView()
            case 2:
                navOptions.tintColor = mailboxGreen
                showArchiveScrollView()
            default:
                navOptions.tintColor = mailboxBlue
        }
    }
    
    func showLaterScrollView() {
        laterScrollView.frame.origin.x = -320
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.scrollView.frame.origin.x = 320
            self.archiveScrollView.frame.origin.x = 320
            self.laterScrollView.frame.origin.x = 0
        })
    }
    
    func showInboxScrollView() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.archiveScrollView.frame.origin.x = 320
            self.laterScrollView.frame.origin.x = -320
            self.scrollView.frame.origin.x = 0
        })
    }
    
    func showArchiveScrollView() {
        archiveScrollView.frame.origin.x = 320
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.archiveScrollView.frame.origin.x = 0
            self.scrollView.frame.origin.x = -320
            self.laterScrollView.frame.origin.x = -320
        })
    }
}
