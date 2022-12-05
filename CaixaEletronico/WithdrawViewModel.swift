import Foundation

protocol WithdrawViewModelDelegate: AnyObject {
    
    func didCalculateExerciseOne(results: [BankNoteModel])
    
    func valorIndisponivel(message: String)
}

class WithdrawViewModel {
    
    private weak var delegate: WithdrawViewModelDelegate?
    
    func configure(delegate: WithdrawViewModelDelegate) {
        self.delegate = delegate
    }
    
    func calculateWithdraw(of value: String?, for exercise: Int) {
        
        guard let withdrawalString = value,
              let withdrawalValue = Int(withdrawalString) else { return }
            
        if exercise == 0 {
            calculateWithdrawExerciseOne(value: withdrawalValue)
        }
        
        if exercise == 1 {
            calculateWithdrawExerciseTwo(value: withdrawalValue)
        }
    }
}

//MARK: - Exercise 1
extension WithdrawViewModel {
    
    private func calculateWithdrawExerciseOne(value: Int) {
        
        let notasDisponiveis = [50, 10, 5, 2]
        
        var valorRestante = value
        
        var quantidadeDeNotas = 0
        
        var result: [BankNoteModel] = []

        for nota in notasDisponiveis {

            while valorRestante >= nota {
                
                if valorRestante % nota > 3 || valorRestante % nota == 2 || valorRestante % nota == 0 {
                    valorRestante -= nota
                    
                    quantidadeDeNotas += 1
                } else {
                    break
                }
            }
            
            result.append(BankNoteModel(nota: nota, quantidadeDeNotas: quantidadeDeNotas))

            quantidadeDeNotas = 0
        }
        
        delegate?.didCalculateExerciseOne(results: result)
    }
}

//MARK: - Exercise 2
extension WithdrawViewModel {
    
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
