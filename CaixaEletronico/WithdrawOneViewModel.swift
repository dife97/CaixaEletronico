import Foundation

protocol WithdrawViewModelDelegate: AnyObject {
    
    func didCalculateWithdraw(results: [BankNoteModel])
    
    func unavailableAmount(message: String)
    
    func didFailToCalculateWithdraw(message: String)
}

class WithdrawOneViewModel {
    
    let availableBanknotes: [BankNoteModel] = [
        BankNoteModel(value: 50, availableAmount: 3),
        BankNoteModel(value: 10, availableAmount: 10),
        BankNoteModel(value: 5, availableAmount: 50),
        BankNoteModel(value: 2, availableAmount: 20)
    ]
    
    var currentValue = 0
    
    var banknoteUsesCount = 0
    
    var result: [BankNoteModel] = []
    
    var banknoteIndex = 0
    
    var smallestBanknote: Int {
        var banknote = availableBanknotes[0].value
        
        for nota in availableBanknotes {
            if nota.value < banknote {
                banknote = nota.value
            }
        }
        
        return banknote
    }
    
    var totalAmountAvailable: Int {

        var total = 0

        for banknote in availableBanknotes {
            total += banknote.value * banknote.availableAmount
        }

        return total
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
            requestWithdrawExerciseTwo(value: withdrawalValue)
        }
        
        if exercise >= 2 {
            delegate?.didFailToCalculateWithdraw(message: "Erro inesperado")
        }
    }
}

//MARK: - Exercise 1
extension WithdrawOneViewModel {
    
    func requestWithdrawExerciseOne(value: Int) {
        
        let currentBanknote = availableBanknotes[banknoteIndex]
        
        currentValue = value
        
        makeWithdrawal(of: currentBanknote.value, forExercise: 1)
    }
}

//MARK: - Exercise 2
extension WithdrawOneViewModel {
    
    func requestWithdrawExerciseTwo(value: Int) {
        
        let currentBanknote = availableBanknotes[banknoteIndex]
        
        currentValue = value
        
        if currentValue > totalAmountAvailable {
            delegate?.unavailableAmount(message: "Valor indisponível")

            clearValues()
            
            return
        }
        
        if banknoteUsesCount >= currentBanknote.availableAmount {
            
            nextBanknoteFor(exercise: 2, currentBanknote: currentBanknote.value)
            
            return
        }
        
        makeWithdrawal(of: currentBanknote.value, forExercise: 2)
    }
}

//MARK: - Private Functions
extension WithdrawOneViewModel {
    
    private func makeWithdrawal(of value: Int, forExercise exercise: Int) {
        
        if currentValue - value == 0 {
            currentValue -= value
            
            banknoteUsesCount += 1
            
            result.append(BankNoteModel(value: value,
                                        availableAmount: banknoteUsesCount))
            
            delegate?.didCalculateWithdraw(results: result)
            
            clearValues()
            
            return
        }
        
        if currentValue - value < 0 || currentValue - value == 3 || currentValue - value < smallestBanknote {
            
            switch exercise {
            case 1:
                nextBanknoteFor(exercise: 1, currentBanknote: value)
            
            case 2:
                nextBanknoteFor(exercise: 2, currentBanknote: value)
            
            default:
                delegate?.didFailToCalculateWithdraw(message: "Erro inesperado")
            }
            
            return
        }
        
        if currentValue - value > 0 {
            currentValue -= value
            
            banknoteUsesCount += 1
            
            switch exercise {
            case 1:
                return requestWithdrawExerciseOne(value: currentValue)
            
            case 2:
                return requestWithdrawExerciseTwo(value: currentValue)
            
            default:
                delegate?.didFailToCalculateWithdraw(message: "Erro inesperado")
            }
        }
    }
    
    private func nextBanknoteFor(exercise: Int, currentBanknote: Int) {
        
        if banknoteUsesCount > 0 {
            result.append(BankNoteModel(value: currentBanknote,
                                        availableAmount: banknoteUsesCount))
        }
        
        banknoteUsesCount = 0
        
        if banknoteIndex + 1 >= availableBanknotes.count && currentValue > 0 {
            
            clearValues()
            
            delegate?.unavailableAmount(message: "Cédulas indisponíveis")
        } else {
            banknoteIndex += 1
            
            switch exercise {
            case 1:
                return requestWithdrawExerciseOne(value: currentValue)
            
            case 2:
                return requestWithdrawExerciseTwo(value: currentValue)
            
            default:
                delegate?.didFailToCalculateWithdraw(message: "Erro inesperado")
            }
        }
    }
    
    private func clearValues() {
        
        currentValue = 0
        banknoteUsesCount = 0
        result = []
        banknoteIndex = 0
    }
}
