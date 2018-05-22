import UIKit

class PassController: UIViewController, PassDelegate {
    
    var pass: Pass?
    let soundEffectsPlayer = SoundEffectsPlayer()
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var passDescriptionLabel: UILabel!
    @IBOutlet weak var entitlementsLabel: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    
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
            
            if let discount = pass.discount {
                entitlements += "Food discounted at \(discount.food)%\n"
                entitlements += "Merchandise discounted at \(discount.merchandise)%"
            } else {
                entitlements += "No discount available"
            }
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 2
            
            entitlementsLabel.attributedText = NSAttributedString(string: entitlements, attributes: [
                NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18, weight: .medium),
                NSAttributedStringKey.paragraphStyle: paragraphStyle
            ])
        }
    }
    
    @IBAction func validateAreaAccess(_ sender: UIButton) {
        if let text = sender.currentTitle, let area = AccessibleArea(rawValue: text) {
            pass?.swipe(for: area)
        }
    }
    
    @IBAction func validateRideAccess(_ sender: UIButton) {
        if let text = sender.currentTitle, let type = RideAccess(rawValue: text) {
            pass?.swipe(for: type)
        }
    }
    
    @IBAction func displayDiscount() {
        soundEffectsPlayer.playSound(status: pass?.discount != nil)
        
        let text: String
        let backgroundColor: UIColor
        
        if let discount = pass?.discount {
            text = "Food: \(discount.food)%\nMerchandise: \(discount.merchandise)%"
            backgroundColor = UIColor(red: 0.44, green: 0.81, blue: 0.59, alpha: 1)
        } else {
            text = "No discount\navailable"
            backgroundColor = UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1)
        }
        
        displayMessage(text, textColor: .white, backgroundColor: backgroundColor)
    }
    
    @IBAction func createNewPass() {
        dismiss(animated: true)
    }
    
    func displayMessage(_ message: String?, textColor: UIColor?, backgroundColor: UIColor?) {
        messageLabel.text = message
        messageLabel.textColor = textColor
        messageLabel.superview!.backgroundColor = backgroundColor
    }
    
    func didSwipeWhenAccessGranted() {
        soundEffectsPlayer.playSound(status: true)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd LLLL"
        
        if let dateOfBirth = pass?.entrant.dateOfBirth, dateFormatter.string(from: Date()) == dateFormatter.string(from: dateOfBirth) {
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) {_ in 
                self.presentAlert(title: "Happy Birthday!", message: "OK")
            }
        }
        
        displayMessage("Access Granted!", textColor: .white, backgroundColor: UIColor(red: 0.44, green: 0.81, blue: 0.59, alpha: 1))
    }
    
    func didSwipeWhenAccessDenied() {
        soundEffectsPlayer.playSound(status: false)
        displayMessage("Access Denied!", textColor: .white, backgroundColor: UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1))
    }
    
    func didSwipeDuringProcessingTime(seconds: Double) {
        soundEffectsPlayer.playSound(status: false)
        
        let text = String(format: "Please wait for\n%.f seconds", seconds)
        displayMessage(text, textColor: .white, backgroundColor: UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1))
    }
    
    func processingTimeDidElapse() {
        displayMessage("Press an option", textColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.35), backgroundColor: .white)
    }
    
    func presentAlert(title: String?, message: String? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        
        present(alertController, animated: true)
    }

}
