import UIKit

class PassController: UIViewController, PassDelegate {
    
    // MARK: - Views
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var passDescriptionLabel: UILabel!
    @IBOutlet weak var entitlementsLabel: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    
    // MARK: - Local Variables and Constants
    
    var pass: Pass?
    let soundEffectsPlayer = SoundEffectsPlayer()
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pass?.delegate = self
        
        if let pass = pass {
            let entrant = pass.entrant
            
            if let name = entrant.name, name.isIncomplete {
                passDescriptionLabel.text = nil
                
                switch entrant {
                case is Guest:
                    fullNameLabel.text = "Guest"
                    passDescriptionLabel.text = pass.description
                case is Vendor:
                    fullNameLabel.text = pass.description
                default:
                    break
                }
            } else {
                fullNameLabel.text = entrant.name?.description
                passDescriptionLabel.text = pass.description
            }
            
            var entitlements = ""
            
            if pass.hasAccess(to: RideAccess.allRides) {
                entitlements += "Go on all rides\n"
            }
            
            if pass.hasAccess(to: RideAccess.skipQueues) {
                entitlements += "Skip long queues\n"
            }
            
            if !pass.discount.isAvailable() {
                entitlements += "Food discounted at \(pass.discount.food)%\n"
                entitlements += "Merchandise discounted at \(pass.discount.merchandise)%"
            } else {
                entitlements += "No discount available"
            }
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 2
            
            entitlementsLabel.attributedText = NSAttributedString(string: entitlements, attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .medium),
                NSAttributedString.Key.paragraphStyle: paragraphStyle
            ])
        }
    }
    
    @IBAction func validateAccess(_ sender: UIButton) {
        if let text = sender.currentTitle, let pass = pass {
            if let area = AccessibleArea(rawValue: text) {
                pass.swipe(for: area)
            } else if let type = RideAccess(rawValue: text) {
                pass.swipe(for: type)
            } else if text == "Discount Access" {
                pass.swipe(for: pass.discount)
            }
        }
    }
    
    @IBAction func createNewPass() {
        dismiss(animated: true)
    }
    
    func displayMessage(_ message: String?, textColor: UIColor?, backgroundColor: UIColor?) {
        messageLabel.text = message
        messageLabel.textColor = textColor
        messageLabel.superview!.backgroundColor = backgroundColor
    }
    
    func didSwipeWhenAccessGranted(for type: AccessType) {
        soundEffectsPlayer.playSound(status: true)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd LLLL"
        
        if let dateOfBirth = pass?.entrant.dateOfBirth, dateFormatter.string(from: Date()) == dateFormatter.string(from: dateOfBirth) {
            DispatchQueue.main.async {
                self.presentAlert(title: "Happy Birthday!", actionTitle: "Dismiss")
            }
        }
        
        var text = "Access Granted!"
        let backgroundColor = UIColor(red: 0.44, green: 0.81, blue: 0.59, alpha: 1)
        
        if let pass = pass, type is Discount {
            text = "Food: \(pass.discount.food)%\nMerchandise: \(pass.discount.merchandise)%"
        }
        
        displayMessage(text, textColor: .white, backgroundColor: backgroundColor)
    }
    
    func didSwipeWhenAccessDenied(for type: AccessType) {
        soundEffectsPlayer.playSound(status: false)
        
        var text = "Access Denied!"
        let backgroundColor = UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1)
        
        if type is Discount {
            text = "No discount\navailable"
        }
        
        displayMessage(text, textColor: .white, backgroundColor: backgroundColor)
    }
    
    func didSwipeDuringProcessingTime(seconds: Double) {
        soundEffectsPlayer.playSound(status: false)
        
        let text = String(format: "Please wait for\n%.f seconds", seconds)
        displayMessage(text, textColor: .white, backgroundColor: UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1))
    }
    
    func processingTimeDidElapse() {
        displayMessage("Press an option", textColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.35), backgroundColor: .white)
    }
}
