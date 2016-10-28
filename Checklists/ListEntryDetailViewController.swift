import UIKit

protocol DetailViewControllerDelegate: class {
    func DetailViewControllerDidCancel(_ controller: DetailViewController)
    func DetailViewController(_ controller: DetailViewController, didFinishAddingItemWithText text: String)
    func DetailViewController(_ controller: DetailViewController, didFinishEditingEntry entry: Entry)
}

protocol Entry: class {
    var text: String {get set};
}

class DetailViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    var entryToEdit: Entry?
    
    weak var delegate: DetailViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let entry = entryToEdit {
            title = "Edit Item"
            textField.text = entry.text
            doneBarButton.isEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    @IBAction func cancel() {
        delegate?.DetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        
        if let entry = entryToEdit {
            entry.text = textField.text!;
            
            delegate?.DetailViewController(self, didFinishEditingEntry: entry)
        } else {
            delegate?.DetailViewController(self, didFinishAddingItemWithText: textField.text!);
        }
        
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText: NSString = textField.text! as NSString
        let newText: NSString = oldText.replacingCharacters(in: range, with: string) as NSString
        
        doneBarButton.isEnabled = (newText.length > 0)
        
        return true
    }
    
}
