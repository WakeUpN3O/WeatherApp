import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var searchTextFieldArea: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextFieldArea.delegate = self
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let textFromArea = searchTextFieldArea.text {
            print(textFromArea)
        }
        return true
    }
    
}

