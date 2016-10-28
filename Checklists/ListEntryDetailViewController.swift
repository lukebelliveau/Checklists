import UIKit

protocol ListEntryDetailViewControllerDelegate: class {
    func ListEntryDetailViewControllerDidCancel(_ controller: ListEntryDetailViewController)
    func ListEntryDetailViewController(_ controller: ListEntryDetailViewController, didFinishAddingItemWithText text: String)
    func ListEntryDetailViewController(_ controller: ListEntryDetailViewController, didFinishEditingEntry entry: Entry)
}

protocol Entry: class {
    func prepare(entryForSavingWithLabel label: String) -> Entry;
    func prepare(entryForEditingWithLabel label: String) -> Entry;
    var text: String {get set};
}

class ListEntryDetailViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    var entryToEdit: Entry?
    
    weak var delegate: ListEntryDetailViewControllerDelegate?
    
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
        delegate?.ListEntryDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        
        if let entry = entryToEdit {
            entry.text = textField.text!;
            
            delegate?.ListEntryDetailViewController(self, didFinishEditingEntry: entry)
        } else {
            delegate?.ListEntryDetailViewController(self, didFinishAddingItemWithText: textField.text!);
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
