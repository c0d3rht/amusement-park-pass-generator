import UIKit

class PassController: UIViewController {

    var pass: Pass?
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var typeOfPassLabel: UILabel!
    @IBOutlet weak var entitlementsLabel: UILabel!
    
    @IBOutlet weak var dismissButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let pass = pass {
            fullNameLabel.text = pass.entrant.name?.description
            typeOfPassLabel.text = pass.type
            
            var entitlements = ""
            
            if pass.hasAccess(to: .allRides) {
                entitlements += "Go on all rides\n"
            }
            
            if pass.hasAccess(to: .skipRides) {
                entitlements += "Skip queues\n"
            }
            
            if let discount = pass.discount {
                entitlements += "Food discounted at \(discount.food)%\n"
                entitlements += "Merchandise discounted at \(discount.merchandise)%"
            }
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 2
            
            entitlementsLabel.attributedText = NSAttributedString(string: entitlements, attributes: [
                NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18, weight: .medium),
                NSAttributedStringKey.paragraphStyle: paragraphStyle
            ])
        }
    }
    
    @IBAction func createNewPass() {
        dismiss(animated: true)
    }

}
