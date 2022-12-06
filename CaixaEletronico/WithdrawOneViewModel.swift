import Foundation

protocol WithdrawViewModelDelegate: AnyObject {
    
    func didCalculateExerciseOne(results: [BankNoteModel])
    
    func valorIndisponivel(message: String)
    
    func errorToCalculate(message: String)
}

class WithdrawOneViewModel {
    
    let availableBanknotes: [BankNoteModel] = [
        BankNoteModel(banknote: 50, availableAmount: 3),
        BankNoteModel(banknote: 10, availableAmount: 10),
        BankNoteModel(banknote: 5, availableAmount: 50),
        BankNoteModel(banknote: 2, availableAmount: 20)
    ]
    
    var currentValue = 0
    
    var banknoteUsesCount = 0
    
    var result: [BankNoteModel] = []
    
    var banknotesIndex = 0
    
    var smallestBanknote: Int {
        var banknote = availableBanknotes[0].banknote
        
        for nota in availableBanknotes {
            if nota.banknote < banknote {
                banknote = nota.banknote
            }
        }
        
        return banknote
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
        
        if exercise >= 2 {
            delegate?.errorToCalculate(message: "Erro inesperado")
        }
    }
}

//MARK: - Exercise 1
extension WithdrawOneViewModel {
    
    func requestWithdrawExerciseOne(value: Int) {
        
        let currentBanknote = availableBanknotes[banknotesIndex].banknote
        
        currentValue = value
        
        if currentValue - currentBanknote == 0 {
            currentValue -= currentBanknote
            
            banknoteUsesCount += 1
            
            result.append(BankNoteModel(banknote: currentBanknote,
                                        availableAmount: banknoteUsesCount))
            
            delegate?.didCalculateExerciseOne(results: result)
            
            clearValues()
            
            return
        }
        
        if currentValue - currentBanknote < 0 || currentValue - currentBanknote == 3 || currentValue - currentBanknote < smallestBanknote {
            
            if banknoteUsesCount > 0 {
                result.append(BankNoteModel(banknote: currentBanknote, availableAmount: banknoteUsesCount))
            }
            
            banknoteUsesCount = 0
            
            nextBanknote()
        }
        
        if currentValue - currentBanknote > 0 {
            currentValue -= currentBanknote
            
            banknoteUsesCount += 1
            
            return requestWithdrawExerciseOne(value: currentValue)
        }
    }
}

//MARK: - Exercise 2
extension WithdrawOneViewModel {
    
    private func calculateWithdrawExerciseTwo(value: Int) {
        
        let currentBanknote = availableBanknotes[banknotesIndex].banknote
        
        currentValue = value
        
        if currentValue - currentBanknote == 0 {
            currentValue -= currentBanknote
            
            banknoteUsesCount += 1
            
            result.append(BankNoteModel(banknote: currentBanknote,
                                        availableAmount: banknoteUsesCount))
            
            delegate?.didCalculateExerciseOne(results: result)
            
            clearValues()
            
            return
        }
        
        if currentValue - currentBanknote < 0 || currentValue - currentBanknote == 3 || currentValue - currentBanknote < smallestBanknote {
            
            if banknoteUsesCount > 0 {
                result.append(BankNoteModel(banknote: currentBanknote, availableAmount: banknoteUsesCount))
            }
            
            banknoteUsesCount = 0
            
            nextBanknote()
        }
        
        if currentValue - currentBanknote > 0 {
            currentValue -= currentBanknote
            
            banknoteUsesCount += 1
            
            return requestWithdrawExerciseOne(value: currentValue)
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
//        let notasDisponiveis: [BankNoteModel] = [
//            BankNoteModel(banknote: 50, availableAmount: 3),
//            BankNoteModel(banknote: 10, availableAmount: 10),
//            BankNoteModel(banknote: 5, availableAmount: 50),
//            BankNoteModel(banknote: 2, availableAmount: 20)
//        ]
//
//        var valorRestante = value
//
//        var quantidadeDeNotas = 0
//
//        var result: [BankNoteModel] = []
//
//        var totalDisponivel: Int {
//
//            var total = 0
//
//            for nota in notasDisponiveis {
//                total += nota.banknote * nota.availableAmount
//            }
//
//            return total
//        }
//
//        if valorRestante > totalDisponivel {
//            delegate?.valorIndisponivel(message: "Notas indisponíveis")
//
//            return
//        }
//
//        for nota in notasDisponiveis {
//
//            while valorRestante >= nota.banknote {
//
//                if quantidadeDeNotas == nota.availableAmount { break }
//
//                if valorRestante % nota.banknote > 3 || valorRestante % nota.banknote == 2 || valorRestante % nota.banknote == 0 {
//                    valorRestante -= nota.banknote
//
//                    quantidadeDeNotas += 1
//                } else { break }
//            }
//
//            result.append(BankNoteModel(banknote: nota.banknote, availableAmount: quantidadeDeNotas))
//
//            quantidadeDeNotas = 0
//        }
//
//        if valorRestante != 0 {
//            delegate?.valorIndisponivel(message: "Valor indisponível")
//        } else {
//            delegate?.didCalculateExerciseOne(results: result)
//        }
    }
}

//MARK: - Private Functions
extension WithdrawOneViewModel {
    
    private func nextBanknote() {
        
        if banknotesIndex + 1 >= availableBanknotes.count && currentValue > 0 {
            
            clearValues()
            
            delegate?.valorIndisponivel(message: "Cédulas indisponíveis")
        } else {
            banknotesIndex += 1
            
            return requestWithdrawExerciseOne(value: currentValue)
        }
    }
    
    private func clearValues() {
        
        currentValue = 0
        
        banknoteUsesCount = 0
        
        result = []
        
        banknotesIndex = 0
    }
}
