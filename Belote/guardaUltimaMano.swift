//
//  guardaUltimaMano.swift
//  Belote
//
//  Created by Matteo Courthoud on 17/07/16.
//  Copyright © 2016 Matteo Courthoud. All rights reserved.
//

import Cocoa

class guardaUltimaMano: NSViewController {
    
    
    
    @IBOutlet weak var cartaGiocatore_0: NSImageView!
    @IBOutlet weak var cartaGiocatore_1: NSImageView!
    @IBOutlet weak var cartaGiocatore_2: NSImageView!
    @IBOutlet weak var cartaGiocatore_3: NSImageView!
    @IBOutlet weak var infoMano: NSTextField!
    @IBOutlet weak var otherInfo: NSTextField!
    @IBOutlet weak var avevaAperto: NSTextField!
    
    
    var carteGiocate = [Card]()
    var primiAgiocare_Array = [Int]()
    var vinceGiocatoreX = Int()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        if carteGiocate.count>3 && primiAgiocare_Array.count>0 {
            
            
            let carta0 = carteGiocate[(carteGiocate.count-4)]
            let carta1 = carteGiocate[(carteGiocate.count-3)]
            let carta2 = carteGiocate[(carteGiocate.count-2)]
            let carta3 = carteGiocate[(carteGiocate.count-1)]
            
            
            if primiAgiocare_Array[primiAgiocare_Array.count-1]==0 {
                cartaGiocatore_0.image = carta0.getImage()
                cartaGiocatore_1.image = carta1.getImage()
                cartaGiocatore_2.image = carta2.getImage()
                cartaGiocatore_3.image = carta3.getImage()
            }
            if primiAgiocare_Array[primiAgiocare_Array.count-1]==1 {
                cartaGiocatore_0.image = carta3.getImage()
                cartaGiocatore_1.image = carta0.getImage()
                cartaGiocatore_2.image = carta1.getImage()
                cartaGiocatore_3.image = carta2.getImage()
            }
            if primiAgiocare_Array[primiAgiocare_Array.count-1]==2 {
                cartaGiocatore_0.image = carta2.getImage()
                cartaGiocatore_1.image = carta3.getImage()
                cartaGiocatore_2.image = carta0.getImage()
                cartaGiocatore_3.image = carta1.getImage()
            }
            if primiAgiocare_Array[primiAgiocare_Array.count-1]==3 {
                cartaGiocatore_0.image = carta1.getImage()
                cartaGiocatore_1.image = carta2.getImage()
                cartaGiocatore_2.image = carta3.getImage()
                cartaGiocatore_3.image = carta0.getImage()
            }
            
            
            if (vinceGiocatoreX==0 || vinceGiocatoreX==4) && primiAgiocare_Array.count>0 {
                infoMano.stringValue = "Hai vinto tu l'ultima mano"
            } else {
                infoMano.stringValue = "Ha vinto il giocatore \(vinceGiocatoreX)"
            }
            
            if primiAgiocare_Array.count>0 {
                let vincitore = (vinceGiocatoreX-primiAgiocare_Array[primiAgiocare_Array.count-1]+4)%4
                let cartaVincente = carteGiocate[carteGiocate.count - 4 + vincitore]
                otherInfo.stringValue = "con "+cartaVincente.getCarta()+" di "+cartaVincente.getSeme()
            }
            
            
            if (primiAgiocare_Array[primiAgiocare_Array.count-1]==0 || primiAgiocare_Array[primiAgiocare_Array.count-1]==4) && primiAgiocare_Array.count>0 {
                avevaAperto.stringValue = "(avevi aperto tu)"
            } else {
                avevaAperto.stringValue = "(aveva aperto il giocatore \(primiAgiocare_Array[primiAgiocare_Array.count-1]) )"
            }

            
            
        }
        
        
    }
    
}
