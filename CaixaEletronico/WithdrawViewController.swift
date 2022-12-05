//
//  ViewController.swift
//  CaixaEletronico
//
//  Created by Diego Ferreira on 03/12/22.
//

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
        
        exerciseSegmentedControl.addTarget(self, action: #selector(didChangeExerciseSegmentedControl), for: .valueChanged)
    }
    
    private func configureWithdrawTextField() {
        
        withdrawalTextField.becomeFirstResponder()
    }
    
    private func configureDelegates() {
        
        withdrawViewModel.configure(delegate: self)
    }
    
    @objc
    private func didChangeExerciseSegmentedControl() {
        
        withdrawalTextField.text = ""
        resultLabel.isHidden = true
    }
    
    @IBAction func didTapWithdrawButton(_ sender: UIButton) {
        
        let withdrawalValue = withdrawalTextField.text
        
        withdrawViewModel.calculateWithdraw(of: withdrawalValue, for: exerciseSegmentedControl.selectedSegmentIndex)
    }
}

extension WithdrawViewController: WithdrawViewModelDelegate {
    
    func didCalculateExerciseOne(results: [BankNoteModel]) {
        
        var text = ""
        
        for result in results {
            
            text.append("\(result.quantidadeDeNotas) \(result.quantidadeDeNotas > 1 ? "notas" : "nota") de R$ \(result.nota)\n")
        }
        
        resultLabel.text = text
        resultLabel.isHidden = false
        
        withdrawalTextField.resignFirstResponder()
    }
    
    func valorIndisponivel(message: String) {
        
        resultLabel.text = message
        resultLabel.isHidden = false
        
        withdrawalTextField.resignFirstResponder()
    }
}