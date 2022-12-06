struct BankNoteModel {
    
    let nota: Int
    let quantidadeDeNotas: Int
}

/*
 
 valor restante >= indexNota.currentBanknote ?
 
 posso retirar currentBanknote?
 - se valorRestante % nota > 3
 - se valorRestante % nota == 2
 - se valorRestante % nota == 0
    ---> subtrai
    ---> recursividade
 
 
 e se
 - se valorRestante % nota == 1 && valorRestante / nota <= 1
 - se valorRestante % nota == 3
    ---> próxima nota
 
 senão
    subtrai
    recursividade
 
 
 
 chamar próxima nota
 
 
 */
