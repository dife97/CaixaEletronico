import UIKit

class WithdrawViewController: UIViewController {
    
    @IBOutlet weak var exerciseSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var withdrawalTextField: UITextField!

    @IBOutlet weak var resultLabel: UILabel!
    
    private let withdrawViewModel = WithdrawViewModel()
    
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
    
    func didCalculateExerciseOne(results: [BankNoteModel]) {
        
        var text = ""
        
        for result in results {
            
            let bankNoteText = result.quantidadeDeNotas > 1 ? "notas" : "nota"
            
            text.append("\(result.quantidadeDeNotas) \(bankNoteText) de R$ \(result.nota)\n")
        }
        
        updateWithdrawTextField(with: text)
    }
    
    func valorIndisponivel(message: String) {
        
        updateWithdrawTextField(with: message)
    }
}

extension WithdrawViewController {
    
    private func updateWithdrawTextField(with text: String) {
        
        resultLabel.text = text
        resultLabel.isHidden = false
        
        withdrawalTextField.resignFirstResponder()
    }
}
