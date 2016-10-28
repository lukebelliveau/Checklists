import UIKit

protocol ListEntryDetailViewControllerDelegate: class {
    func ListEntryDetailViewControllerDidCancel(_ controller: ListEntryDetailViewController)
    func ListEntryDetailViewController(_ controller: ListEntryDetailViewController, didFinishAddingItem item: ChecklistItem)
    func ListEntryDetailViewController(_ controller: ListEntryDetailViewController, didFinishEditingItem item: ChecklistItem)
}

protocol Entry: class {
    func prepare(entryForSavingWithLabel label: String) -> Entry;
    func prepare(entryForEditingWithLabel label: String) -> Entry;
}

class ListEntryDetailViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    var itemToEdit: ChecklistItem?
    
    weak var delegate: ListEntryDetailViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
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
        
        if let item = itemToEdit {
            let preparedItem = item.prepare(entryForEditingWithLabel: textField.text!);
            
            delegate?.ListEntryDetailViewController(self, didFinishEditingItem: preparedItem as! ChecklistItem)
        } else {
            let item = ChecklistItem()
            item.text = textField.text!
            item.checked = false
            
            delegate?.ListEntryDetailViewController(self, didFinishAddingItem: item)
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
