import UIKit

class WithdrawViewController: UIViewController {
    
    @IBOutlet weak var exerciseSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var withdrawalTextField: UITextField!

    @IBOutlet weak var resultLabel: UILabel!
    
    private let withdrawViewModel = WithdrawOneViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureExerciseSegmentedControl()
        
        configureWithdrawTextField()
        
        configureDelegates()
    }
    
    private func configureExerciseSegmentedControl() {
        
        exerciseSegmentedControl.addTarget(self,
                                           action: #selector(didChangeExerciseSegmentedControl),
                                           for: .valueChanged)
    }
    
    private func configureWithdrawTextField() {
        
        withdrawalTextField.becomeFirstResponder()
    }
    
    private func configureDelegates() {
        
        withdrawViewModel.configure(delegate: self)
    }
    
    @objc private func didChangeExerciseSegmentedControl() {
        
        withdrawalTextField.text = ""
        resultLabel.isHidden = true
    }
    
    @IBAction func didTapWithdrawButton(_ sender: UIButton) {
        
        let withdrawalValue = withdrawalTextField.text
        
        withdrawViewModel.calculateWithdraw(of: withdrawalValue,
                                            for: exerciseSegmentedControl.selectedSegmentIndex)
    }
}

extension WithdrawViewController: WithdrawViewModelDelegate {
    
    func didCalculateWithdraw(results: [BankNoteModel]) {
        
        var text = ""
        
        for result in results {
            
            let bankNoteText = result.availableAmount > 1 ? "notas" : "nota"
            
            text.append("\(result.availableAmount) \(bankNoteText) de R$ \(result.value)\n")
        }
        
        updateWithdrawTextField(with: text)
    }
    
    func unavailableAmount(message: String) {
        
        updateWithdrawTextField(with: message)
    }
    
    func didFailToCalculateWithdraw(message: String) {
        
        print("[WithdrawViewController] Error: \(message)")
    }
}

extension WithdrawViewController {
    
    private func updateWithdrawTextField(with text: String) {
        
        resultLabel.text = text
        resultLabel.isHidden = false
        
        withdrawalTextField.resignFirstResponder()
    }
}
