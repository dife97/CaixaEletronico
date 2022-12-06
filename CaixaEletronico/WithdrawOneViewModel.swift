import Foundation

protocol WithdrawViewModelDelegate: AnyObject {
    
    func didCalculateExerciseOne(results: [BankNoteModel])
    
    func valorIndisponivel(message: String)
    
    func errorToCalculate(message: String)
}

class WithdrawOneViewModel {
    
    let notasDisponiveis: [BankNoteModel] = [
        BankNoteModel(nota: 50, quantidadeDeNotas: 3),
        BankNoteModel(nota: 10, quantidadeDeNotas: 10),
        BankNoteModel(nota: 5, quantidadeDeNotas: 50),
        BankNoteModel(nota: 2, quantidadeDeNotas: 20)
    ]
    
    var valorRestante = 0
    
    var quantidadeDeNotas = 0
    
    var result: [BankNoteModel] = []
    
    var banknotesIndex = 0
    
    var menorCedula: Int {
        var menorCedula = notasDisponiveis[0].nota
        
        for nota in notasDisponiveis {
            if nota.nota < menorCedula {
                menorCedula = nota.nota
            }
        }
        
        return menorCedula
    }
    
    private weak var delegate: WithdrawViewModelDelegate?
    
    func configure(delegate: WithdrawViewModelDelegate) {
        self.delegate = delegate
    }
    
    func calculateWithdraw(of value: String?, for exercise: Int) {
        
        guard let withdrawalString = value,
              let withdrawalValue = Int(withdrawalString) else { return }
            
        if exercise == 0 {
            requestWithdrawExerciseOne(value: withdrawalValue)
        }
        
        if exercise == 1 {
            calculateWithdrawExerciseTwo(value: withdrawalValue)
        }
        
        if exercise > 1 {
            delegate?.errorToCalculate(message: "Erro inesperado")
        }
    }
}

//MARK: - Exercise 1
extension WithdrawOneViewModel {
    
    func requestWithdrawExerciseOne(value: Int) {
        
        let nota = notasDisponiveis[banknotesIndex].nota
        
        valorRestante = value
        
        if valorRestante - nota == 0 {
            valorRestante -= nota
            
            quantidadeDeNotas += 1
            
            result.append(BankNoteModel(nota: nota,
                                        quantidadeDeNotas: quantidadeDeNotas))
            
            delegate?.didCalculateExerciseOne(results: result)
            
            clearValues()
            
            return
        }
        
        if valorRestante - nota < 0 || valorRestante - nota == 3 || valorRestante - nota < menorCedula {
            
            if quantidadeDeNotas > 0 {
                result.append(BankNoteModel(nota: nota, quantidadeDeNotas: quantidadeDeNotas))
            }
            
            quantidadeDeNotas = 0
            
            nextBanknote()
        }
        
        if valorRestante - nota > 0 {
            valorRestante -= nota
            
            quantidadeDeNotas += 1
            
            return requestWithdrawExerciseOne(value: valorRestante)
        }
    }
}

//MARK: - Exercise 2
extension WithdrawOneViewModel {
    
    private func calculateWithdrawExerciseTwo(value: Int) {
        
        let notasDisponiveis: [BankNoteModel] = [
            BankNoteModel(nota: 50, quantidadeDeNotas: 3),
            BankNoteModel(nota: 10, quantidadeDeNotas: 10),
            BankNoteModel(nota: 5, quantidadeDeNotas: 50),
            BankNoteModel(nota: 2, quantidadeDeNotas: 20)
        ]
        
        var valorRestante = value
        
        var quantidadeDeNotas = 0

        var result: [BankNoteModel] = []
        
        var totalDisponivel: Int {
            
            var total = 0
            
            for nota in notasDisponiveis {
                total += nota.nota * nota.quantidadeDeNotas
            }
            
            return total
        }
        
        if valorRestante > totalDisponivel {
            delegate?.valorIndisponivel(message: "Notas indisponíveis")
            
            return
        }
        
        for nota in notasDisponiveis {
            
            while valorRestante >= nota.nota {
                
                if quantidadeDeNotas == nota.quantidadeDeNotas { break }
                
                if valorRestante % nota.nota > 3 || valorRestante % nota.nota == 2 || valorRestante % nota.nota == 0 {
                    valorRestante -= nota.nota
                    
                    quantidadeDeNotas += 1
                } else { break }
            }
            
            result.append(BankNoteModel(nota: nota.nota, quantidadeDeNotas: quantidadeDeNotas))
            
            quantidadeDeNotas = 0
        }
        
        if valorRestante != 0 {
            delegate?.valorIndisponivel(message: "Valor indisponível")
        } else {
            delegate?.didCalculateExerciseOne(results: result)
        }
    }
}

//MARK: - Private Functions
extension WithdrawOneViewModel {
    
    private func nextBanknote() {
        
        if banknotesIndex + 1 >= notasDisponiveis.count && valorRestante > 0 {
            
            clearValues()
            
            delegate?.valorIndisponivel(message: "Cédulas indisponíveis")
        } else {
            banknotesIndex += 1
            
            return requestWithdrawExerciseOne(value: valorRestante)
        }
    }
    
    private func clearValues() {
        
        valorRestante = 0
        
        quantidadeDeNotas = 0
        
        result = []
        
        banknotesIndex = 0
    }
}
