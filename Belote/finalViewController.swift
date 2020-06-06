//
//  finalViewController.swift
//  Belote
//
//  Created by Matteo Courthoud on 17/07/16.
//  Copyright © 2016 Matteo Courthoud. All rights reserved.
//

import Cocoa


class finalViewController: NSViewController {
    
    
    @IBOutlet weak var carta_1: NSButton!
    @IBOutlet weak var carta_2: NSButton!
    @IBOutlet weak var carta_3: NSButton!
    @IBOutlet weak var carta_4: NSButton!
    @IBOutlet weak var carta_5: NSButton!
    @IBOutlet weak var carta_6: NSButton!
    @IBOutlet weak var carta_7: NSButton!
    @IBOutlet weak var carta_8: NSButton!
    var carteInMano_Array = [NSButton]() // array dei bottoni delle mie carte
    
    
    @IBOutlet weak var cartaGiocata0: NSImageView!
    @IBOutlet weak var cartaGiocata1: NSImageView!
    @IBOutlet weak var cartaGiocata2: NSImageView!
    @IBOutlet weak var cartaGiocata3: NSImageView!
    var carteGiocate_Array = [NSImageView]() // array delle immagini delle carte giocate
    
    
    @IBOutlet weak var showLastHand: NSButton!
    @IBOutlet weak var endGame: NSButton!
    @IBOutlet weak var reminderText: NSTextField!
    
    
    @IBOutlet weak var mostraPuntiAmici: NSTextField!
    @IBOutlet weak var mostraPuntiNemici: NSTextField!
    
    
    // Variabili fisse
    let semi = [String](arrayLiteral: "cuori","fiori","quadri","picche")
    let cartaBlank = Card(semeCarta: "none", numeroCarta: 0)
    
    // Variabili nuove
    var carteTuttiGiocatori = Array<Array<Card>>()
    var carteInCampo = [Card]()
    var carteGiocate = [Card]()
    var puntiAmici = 0
    var puntiNemici = 0
    var gameOver = false
    var toccaA = 4             // variabile che stabilisce a chi tocca
    var primoAgiocare = 0      // variabile che si ricorda chi ha giocato per primo
    var possoGiocare = Bool()
    var primiAgiocare_Array = [Int]()
    var vinceGiocatoreX = Int()
    var numeroAtoutScesi = 0
    var carteDaMostrare = [CardToShow]() // Contiene le carte da mostrare a fine mano, in sequenza
    var totDelay = 0

    
    // Variabili che eredito
    var carteGiocatore0 = [Card]()
    var carteGiocatore1 = [Card]()
    var carteGiocatore2 = [Card]()
    var carteGiocatore3 = [Card]()
    var accusoFinale = Card(semeCarta: "none", numeroCarta: 0)
    var serieAccusi = [Card]()
    var hannoAperto = "none" // variabile che si ricorda chi ha aperto
    var accusiAmiciNemici = [0,0]
    var contro = false

    
    
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        
        // Mostro le carta
        carta_1.image = carteGiocatore0[0].getImage()
        carta_2.image = carteGiocatore0[1].getImage()
        carta_3.image = carteGiocatore0[2].getImage()
        carta_4.image = carteGiocatore0[3].getImage()
        carta_5.image = carteGiocatore0[4].getImage()
        carta_6.image = carteGiocatore0[5].getImage()
        carta_7.image = carteGiocatore0[6].getImage()
        carta_8.image = carteGiocatore0[7].getImage()
        
        // Scrivo a quanto si va
        reminderText.stringValue = ("Si va \(accusoFinale.getNumero()) a "+accusoFinale.getSeme()+"!")
        
        // DOUBLE CHECK INUTILE
        print("Si va \(serieAccusi[serieAccusi.count-4].getNumero()) a "+serieAccusi[serieAccusi.count-4].getSeme()+"!")
        
        
        // Compilo array
        carteInMano_Array=[carta_1,carta_2,carta_3,carta_4,carta_5,carta_6,carta_7,carta_8]
        carteGiocate_Array=[cartaGiocata0,cartaGiocata1,cartaGiocata2,cartaGiocata3]
        carteTuttiGiocatori=[carteGiocatore0,carteGiocatore1,carteGiocatore2,carteGiocatore3]
        puntiAmici=accusiAmiciNemici[0]
        puntiNemici=accusiAmiciNemici[1]
        mostraPuntiAmici.stringValue = "\(puntiAmici)"
        mostraPuntiNemici.stringValue = "\(puntiNemici)"
        possoGiocare = true
        
    }
    
    

    
    
    // MMMMMM funza!!
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject!) {
        
        // Passo le informazioni alla schermata che riasume l'ultima mano
        if (segue.identifier == "sideID") {
            let svc = segue.destinationController as! guardaUltimaMano;
            
            print("CONTROLLO LA MIA MANO")
            svc.carteGiocate = carteGiocate
            svc.primiAgiocare_Array = primiAgiocare_Array
            svc.vinceGiocatoreX = vinceGiocatoreX
            
        }
        
        // Passo le informazioni alla prima schermata
        if (segue.identifier == "restartID") {
            let svc = segue.destinationController as! sourceViewController;
            
            print("HO PASSATO \(puntiAmici) PUNTI AMICI E \(puntiNemici) PUNTI NEMICI ALLA PRIMA SCHERMATA")
            svc.puntiAmici=puntiAmici
            svc.puntiNemici=puntiNemici
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    
    // Formula l'ultimo messaggio e calcola i punti
    func formulateLastString() -> String {
        var lastString = ""
        
        if contro == false {
            if (hannoAperto=="noi") {
                if (puntiAmici >= accusoFinale.getNumero()) {
                    lastString = "Ce l'abbiamo fatta! \n Abbiamo fatto \(puntiAmici) punti ed eravamo andati a \(accusoFinale.getNumero())."
                    if puntiNemici-accusiAmiciNemici[1] == 0 {
                        lastString = "Cappotto! \n Gli avversari non hanno fatto punti quindi noi ne facciamo 252, più gli accusi."
                        puntiAmici = 252 + accusiAmiciNemici[0]
                    }
                }
                else {
                    lastString = "Non ce l'abbiamo fatta...  \n Abbiamo fatto \(puntiAmici) punti ed eravamo andati a \(self.accusoFinale.getNumero())."
                    puntiNemici = 162 + accusiAmiciNemici[1]
                    puntiAmici = accusiAmiciNemici[0]
                }
            }
            else if (puntiNemici >= accusoFinale.getNumero()) {
                lastString = "Ce l'hanno fatta... \n Hanno fatto \(self.puntiNemici) punti ed erano andati a \(accusoFinale.getNumero())."
                if puntiAmici-accusiAmiciNemici[0] == 0 {
                    lastString = "Cappotto... \n Non abbiamo fatto punti quindi gli avversari ne fanno 252, più gli accusi."
                    puntiNemici = 252 + accusiAmiciNemici[1]
                }
            }
            else {
                lastString = "Non ce l'hanno fatta! \n Hanno fatto \(puntiNemici) punti ed erano andati a \(accusoFinale.getNumero())."
                puntiNemici = accusiAmiciNemici[1]
                puntiAmici = 162 + accusiAmiciNemici[0]
            }
        }
        
        // Se era stato dato contro
        if contro == true {
            if (hannoAperto=="noi") {
                if puntiAmici>puntiNemici || puntiNemici<accusoFinale.getNumero(){
                    lastString = "Ce l'abbiamo fatta! \n Avevamo dato contro a "+accusoFinale.getSeme()+" e abbiamo vinto. \n I punti finali sono \((puntiAmici+accusiAmiciNemici[1])*2)-0 per noi."
                    puntiAmici = (puntiAmici+accusiAmiciNemici[1])*2
                    puntiNemici = 0
                }
                else {
                    lastString = "Non ce l'abbiamo fatta... \n Avevamo dato contro a "+accusoFinale.getSeme()+" ma abbiamo perso. \n I punti finali sono \((puntiNemici+accusiAmiciNemici[0])*2)-0 per loro."
                    puntiAmici = 0
                    puntiNemici = (puntiNemici+accusiAmiciNemici[0])*2
                }
            }
                
            else {
                if puntiNemici>puntiAmici || puntiAmici<accusoFinale.getNumero() {
                    lastString = "Ce l'hanno fatta... \n Avevano dato contro a "+accusoFinale.getSeme()+" e hanno vinto. \n I punti finali sono \((puntiNemici+accusiAmiciNemici[0])*2)-0 per loro."
                    puntiNemici = (puntiNemici+accusiAmiciNemici[0])*2
                    puntiAmici = 0
                }
                else {
                    lastString = "Non ce l'hanno fatta! \n Avevano dato contro a "+accusoFinale.getSeme()+" ma hanno perso). \n I punti finali sono \((puntiAmici+accusiAmiciNemici[1])*2)-0 per noi."
                    puntiNemici = 0
                    puntiAmici = (puntiAmici+accusiAmiciNemici[1])*2
                }
            }
        }
        
        return lastString+"\n \n \n Clicca per continuare."
        
    }

    

    
    // Check if the game is over
    func checkGameOver()  {
        var carteTOT = 0
        
        // Conto le mie carte
        for carta in carteGiocatore0 {
            if carta.getNumero()>0 {carteTOT=carteTOT+1}
        }
        
        // Conto le carte degli altri 3 giocatori
        for i in 1...3 {
            carteTOT=carteTOT + carteTuttiGiocatori[i].count
        }
        
        // Se non ci sono piu carte in giro
        if (carteTOT==0 ) {
            print (" --------------  The game is over ----------------")
            gameOver=true
        }
    }
    
    
    
    
    // conta i punti in campo
    func contaPunti(campo: [Card]) -> Int {
        var puntiInCampo=0
        for carta in campo {
            if carta.getSeme()==accusoFinale.getSeme() {
                puntiInCampo=puntiInCampo+carta.getPuntiAtout()
                numeroAtoutScesi=numeroAtoutScesi+1
            }
            else {puntiInCampo=puntiInCampo+carta.getPunti()}
        }
        
        print("I punti in campo erano \(puntiInCampo)")
        return puntiInCampo
    }
    
    
    
    // Controlla chi ha vinto la mano
    func vinceLaMano() -> Int {
        var tempCampo=carteInCampo
        var cartaDaBattere = tempCampo[0]
        vinceGiocatoreX = primoAgiocare
        
        // Ho fatto una modifica qua! Prima era for i in 1...3
        for i in 1...(carteInCampo.count-1) {
            // prima controllo se la carta giocata è atout
            if (tempCampo[i].getSeme()==accusoFinale.getSeme()) {
                if !(cartaDaBattere.getSeme()==accusoFinale.getSeme()) {
                    
                    // Se in campo non c'era atout, vince lui
                    vinceGiocatoreX = (i+primoAgiocare)%4
                    cartaDaBattere=tempCampo[i]

                    
                }
                else if (tempCampo[i].getPriorityAtout()>cartaDaBattere.getPriorityAtout()) {
                    
                    // Vince lui se aveva carta (atout) piu alta
                    vinceGiocatoreX = (i+primoAgiocare)%4
                    cartaDaBattere=tempCampo[i]
                }
            }
                
            // altrimenti poi controllo se è piu alta, allo stesso seme
            else if (tempCampo[i].getSeme()==cartaDaBattere.getSeme() && tempCampo[i].getPriority()>cartaDaBattere.getPriority())  {
                
                // Vince lui se ha carta piu alta
                vinceGiocatoreX = (i+primoAgiocare)%4
                cartaDaBattere=tempCampo[i]
            }
        }
        
        print("Mano vinta dal giocatore \(vinceGiocatoreX) con "+cartaDaBattere.getCarta()+" di "+cartaDaBattere.getSeme()+". Il primo a giocare era il giocatore \(primoAgiocare)")
        return vinceGiocatoreX
    }
    
    
    
    
    
    // assegna i punti a chi ha vinto
    func assegnaPunti(vincitore: Int, punti: Int) {
        var tempPunti=punti
        var vinceTeamX = ""
        
        // controllo chi ha vinto
        if (vincitore)%2 == 0 {vinceTeamX = "amici"}
        else {vinceTeamX = "nemici"}
        
        // do 10 punti in piu se è l'ultima mano
        if (carteTuttiGiocatori[1].count==0 && carteTuttiGiocatori[2].count==0 && carteTuttiGiocatori[3].count==0) {
            tempPunti = tempPunti+10
        }
        
        
        // assegno i punti a chi ha vinto
        print("Vincono: "+vinceTeamX)
        if vinceTeamX=="amici" {puntiAmici=puntiAmici+tempPunti}
        else {puntiNemici=puntiNemici+tempPunti}
        mostraPuntiAmici.stringValue="\(puntiAmici)"
        mostraPuntiNemici.stringValue="\(puntiNemici)"
        
    }
    
    
    
    
    
    // svuota il campo
    func svuotaCampo() {
        
        if carteInCampo.count==4 {
            
            // assegno i punti
            assegnaPunti(vinceLaMano(), punti: contaPunti(carteInCampo))
            
            
            // I prossimo a cominciare è il vincitore
            toccaA=vinceLaMano()
            if toccaA == 0 {
                toccaA = 4
            }
            
            print("Ho svuotato il campo. Adesso tocca al giocatore \(toccaA)")
            
            // svuoto il board
            for carta in carteInCampo {carteGiocate.append(carta)}  // me le salvo a parte
            primiAgiocare_Array.append(primoAgiocare)
            carteInCampo=[Card]()
            
            // Ricordo alla grafica di vuotare il board
            carteDaMostrare.append(CardToShow(cartaDaMostrare: cartaBlank, proprietarioCarta: 5))
        }
            
        else {print("ERRORE!!! Ci sono \(carteInCampo.count) carte in campo e dovrei svuotare il campo")}
        
        checkGameOver() // controlla se era l'ultima mano
    }
    
    
    
    
    // Giocatore i gioca la carta j
    func giocaCarta(giocatore: Int, numeroCarta: Int) {
        print("Il giocatore \(giocatore) gioca la carta \(numeroCarta). Ha \(carteTuttiGiocatori[giocatore].count) carta in mano.")
        carteInCampo.append(carteTuttiGiocatori[giocatore][numeroCarta])    // gioco la carta
        
        // Salvo la carta da mostrare
        carteDaMostrare.append(CardToShow(cartaDaMostrare: (carteTuttiGiocatori[giocatore])[numeroCarta], proprietarioCarta: giocatore))
        
        carteTuttiGiocatori[giocatore].removeAtIndex(numeroCarta)     // rimuovo la carta giocata
        
    }
    
    
    
    
    // Faccio giocare il giocatore X
    func giocaGiocatoreX(numeroGiocatore: Int ) {
        
        if carteInCampo.count > 3 {
            print("ERRORE!! Ci sono \(carteInCampo.count) carte in campo e dovrebbe giocare Giocatore \(numeroGiocatore)")
        }
        else if carteInCampo.count == 0 {
            //gioca prima carta
            primoAgiocare=numeroGiocatore
            giocaPerPrimo(numeroGiocatore)
        }
        else if carteInCampo.count < 4 {
            // gioco in risposta
            giocaNonPrimo(numeroGiocatore)
        }
        
        // Subito dopo aver giocato, pulisco il campo se ero l'ultimo
        if carteInCampo.count==4 {
            svuotaCampo()
        }
        // Sennò tocca al prossimo
        else {
            toccaA=toccaA+1
        }
        

    }
    
    
    
    
    
    // Guarda quali carte posso giocare
    func abilitaCarte() {
        var carteAbilitate = 0
        
        // Se non ci sono carte in campo, posso giocare quello che mi pare
        if carteInCampo.count == 0 {
            for carta in carteInMano_Array {
                carta.enabled=true
                carteAbilitate = carteAbilitate+1
            }
        }
        
        // Se è atout, devo superare
        else if carteInCampo[0].getSeme() == accusoFinale.getSeme() {
            for i in 0...7 {
                if superoIlCampo(carteGiocatore0, numeroCarta: i) == true {
                    carteInMano_Array[i].enabled = true
                    carteAbilitate = carteAbilitate+1
                }
            }
            
            // se non ho da superare, posso comunque giocare solo atout
            if carteAbilitate == 0 {
                for i in 0...7 {
                    if carteGiocatore0[i].getSeme() == accusoFinale.getSeme() {
                        carteInMano_Array[i].enabled = true
                        carteAbilitate = carteAbilitate+1
                    }
                }
            }
        }
        
        // Se non era atout, abilito tutte quelle a quel seme
        else {
            for i in 0...7 {
                if carteGiocatore0[i].getSeme() == carteInCampo[0].getSeme() {
                    carteInMano_Array[i].enabled = true
                    carteAbilitate = carteAbilitate+1
                }
            }
        }
        
        // Se ancora non posso giocare nessuna carta, faccio giocare tutte quelle disponibili
        if carteAbilitate == 0 {
            for i in 0...7 {
                if carteGiocatore0[i].getNumero() > 0 {
                    carteInMano_Array[i].enabled = true
                    carteAbilitate = carteAbilitate+1
                }
            }
            
        }
        
            
        
        
        
    }
    
    
    
    
    
    // Gioco carte io!
    @IBAction func playCard (sender:NSButton) {
        
        // Disattivo e svuoto tutto innanzitutto
        totDelay=0
        carteDaMostrare = [CardToShow]()
        for carta in carteInMano_Array { carta.enabled=false }
        
        
        for i in 0...7 {
            if (sender == carteInMano_Array[i] && carteGiocatore0[i].getNumero()>0 && toccaA==4 && possoGiocare==true) {
                possoGiocare=false
                if (carteInCampo.count==0) {primoAgiocare=0}
                
                
                
                // Gioco la carta
                print("Played carta \(i+1)")
                carteDaMostrare.append(CardToShow(cartaDaMostrare: carteGiocatore0[i], proprietarioCarta: 0))
                carteInCampo.append(carteGiocatore0[i])
                
                // cancello la carta giocata
                carteInMano_Array[i].image = nil
                carteGiocatore0[i]=cartaBlank
                
                
                // Se ero l'ultimo, svuoto il campo
                if carteInCampo.count==4 {
                    
                    print("adesso svuoto il campo")
                    svuotaCampo()
                    
                } else {
                    toccaA=1
                }
                
                while (toccaA==1 || toccaA==2 || toccaA==3) && gameOver==false {
                        
                    // Giocano gli altri giocatori
                    for j in 1...3 {
                        if toccaA==j && gameOver==false {
    
                            // gioca solo se ha carte in mano
                            giocaGiocatoreX(j)
                            
                        }
                    }
                }
            
                // Mostro le carte!
                for element in carteDaMostrare {
                    let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(totDelay) * Int64(NSEC_PER_SEC))
                    dispatch_after(time, dispatch_get_main_queue()) {
                        
                        // Se la carta giocata è blank (giocatore==5), pulisco il board
                        if element.getProprietario()==5 {
                            for immagine in self.carteGiocate_Array { immagine.image = nil }
                            
                        }
                            
                        // Altrimenti mostro la carta giocata
                        else {
                            self.carteGiocate_Array[element.getProprietario()].image = element.getImageToShow()
                        }
                    }
                    totDelay=totDelay+1
                }
                
                
                // Dopo tutte le animazioni, posso giocare
                let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(totDelay-1) * Int64(NSEC_PER_SEC))
                dispatch_after(time, dispatch_get_main_queue()) {
                    self.possoGiocare=true
                    self.abilitaCarte()
                    
                    // Se è finito il gioco, termino il gioco
                    if self.gameOver == true {
                        
                        // Faccio apparire il pulsantone e controllo se chi ha aperto è andato sotto
                        self.endGame.transparent=false
                        self.endGame.frame = CGRect(x: 130,y: 150,width: 400,height: 150)
                        self.endGame.enabled = true
                        self.endGame.title = self.formulateLastString()
                        self.endGame.alphaValue = 0.8
                        
                        // Salvo i punti
                        do {
                            let punti = try String(contentsOfFile: "punteggio.txt", encoding: NSUTF8StringEncoding)
                            print("I punti erano: "+punti)
                            let score = punti.componentsSeparatedByString("-")
                            self.puntiAmici=self.puntiAmici + Int(score[0])!
                            self.puntiNemici=self.puntiNemici + Int(score[1])!
                            print("Adesso i punti sono: \(self.puntiAmici)-\(self.puntiNemici)")
                        }
                        catch let error as NSError {
                            print("Error: \(error)")
                        }
                        
                       let punteggio = "\(self.puntiAmici)-\(self.puntiNemici)"

                        do {
                            try punteggio.writeToFile("punteggio.txt", atomically: true, encoding: NSUTF8StringEncoding)
                            print("Punteggio salvato! "+punteggio)
                        }
                        catch { print("Error: \(error)") }
                        
                    }
                    
                }
                
                
                
                
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    

    // -------------------------------------- COSTRUISCO LA IA ---------------------------------------------------
    
    

    
    
    
    
    
    // Se gioco per primo
    func giocaPerPrimo(numeroGiocatore: Int) {
        var cartaDaGiocare = -1
        var tempAmici = "loro"
        if numeroGiocatore==2 {tempAmici = "noi"}
        var giocatoreAmico=0
        if numeroGiocatore==1 { giocatoreAmico=3}
        else if numeroGiocatore==3 {giocatoreAmico=1}
        
        print("Giocatore \(numeroGiocatore) ("+tempAmici+") gioca per primo questa mano. Aveva aperto "+hannoAperto)
        
        // Faccio scendere gli atout se ha aperto la mia squadra e non sono scesi tutti gli atout
        if tempAmici==hannoAperto && contaAtout(carteTuttiGiocatori[numeroGiocatore])+contaAtout(carteTuttiGiocatori[giocatoreAmico])+numeroAtoutScesi < 8 {

            print("E decide di giocare MAXatout!!")
            cartaDaGiocare = giocaAtoutMAX(carteTuttiGiocatori[numeroGiocatore])
        }
        
        // A meno che non me li possano superare
        if !(chiHaAtoutPiuAlto()==numeroGiocatore) && !(chiHaAtoutPiuAlto()==giocatoreAmico) {
            cartaDaGiocare = -1
        }
            
        // Senno butto il massimo di un seme a caso
        if cartaDaGiocare == -1 {
            cartaDaGiocare = giocaScartoMAX(carteTuttiGiocatori[numeroGiocatore])
        }
        
        // A meno che non sia il 10 e ci sia ancora l'asso in giro
        var assoUscito=false
        for carta in carteGiocate {
            if carta.getNumero()==8 && carta.getSeme()==(carteTuttiGiocatori[numeroGiocatore])[cartaDaGiocare].getSeme() {
                assoUscito=true
            }
        }
        if (carteTuttiGiocatori[numeroGiocatore])[cartaDaGiocare].getNumero()==4 && assoUscito==false {
            cartaDaGiocare = giocaScartoMIN(carteTuttiGiocatori[numeroGiocatore])
        }
        
        // Finally gioco la carta
        giocaCarta(numeroGiocatore, numeroCarta: cartaDaGiocare)
        
    }
    
    
    
    
    // Se NON! gioco per primo
    func giocaNonPrimo(numeroGiocatore: Int) {
        var cartaDaGiocare = -1
        var giocatoreAmico=0
        if numeroGiocatore==1 { giocatoreAmico=3}
        else if numeroGiocatore==3 {giocatoreAmico=1}
        
        
        if carteInCampo[0].getSeme()==accusoFinale.getSeme() {
            
            // Scelto il massimo
            cartaDaGiocare = giocaAtoutMAX(carteTuttiGiocatori[numeroGiocatore])
            
            // Controllo se ho superato, sennò gioco il minimo
            if cartaDaGiocare >= 0 {
                if superoIlCampo(carteTuttiGiocatori[numeroGiocatore], numeroCarta: cartaDaGiocare)==false {
                    cartaDaGiocare = giocaAtoutMIN(carteTuttiGiocatori[numeroGiocatore])
                }
            }
        }
            
        // Se non hanno aperto a atout
        else {
            
            // Scelto il massimo
            cartaDaGiocare = giocaSemeMAX(carteTuttiGiocatori[numeroGiocatore])
            
            if cartaDaGiocare >= 0 {
                // A meno che non sia il 10 e ci sia ancora l'asso in giro
                var assoUscito=false
                for carta in carteGiocate {
                    if carta.getNumero()==8 && carta.getSeme()==(carteTuttiGiocatori[numeroGiocatore])[cartaDaGiocare].getSeme() {
                        assoUscito=true
                    }
                }
                if (carteTuttiGiocatori[numeroGiocatore])[cartaDaGiocare].getNumero()==4 && assoUscito==false {
                    cartaDaGiocare = giocaSemeMIN(carteTuttiGiocatori[numeroGiocatore])
                }
                
                
                // Controllo se ho superato, sennò gioco il minimo
                if superoIlCampo(carteTuttiGiocatori[numeroGiocatore], numeroCarta: cartaDaGiocare)==false {
                    cartaDaGiocare = giocaSemeMIN(carteTuttiGiocatori[numeroGiocatore])
                }
            }
        }
        
        // Se non hanno aperto atout e non ho carte di quel seme e la mano non è del mio amico, taglio col minimo
        if cartaDaGiocare == -1 {
            if carteInCampo.count==1 || (carteInCampo.count>1 && !(vinceLaMano()==giocatoreAmico)) {
                cartaDaGiocare = giocaAtoutMIN(carteTuttiGiocatori[numeroGiocatore])
                
                // Se però non supero, gioco atout MAX
                if cartaDaGiocare >= 0 {
                    if superoIlCampo(carteTuttiGiocatori[numeroGiocatore], numeroCarta: cartaDaGiocare)==false {
                        cartaDaGiocare = giocaAtoutMAX(carteTuttiGiocatori[numeroGiocatore])
                    }
                }
                
                // Se ancora non supero, scarto
                if cartaDaGiocare >= 0 {
                    if superoIlCampo(carteTuttiGiocatori[numeroGiocatore], numeroCarta: cartaDaGiocare)==false {
                        cartaDaGiocare = -1
                    }
                }
            }
        }
        
        // Sennò scarto
        if cartaDaGiocare == -1 {
            cartaDaGiocare = giocaScartoMIN(carteTuttiGiocatori[numeroGiocatore])
        }
        
        giocaCarta(numeroGiocatore, numeroCarta: cartaDaGiocare)
    }
    
    
    
    
    
    
    // Gioco la carta piu alta a atout
    func giocaAtoutMAX(mano: [Card]) -> Int {
        var scegliCarta = -1
        var tempNum = 0
        
        for i in 0...(mano.count-1) {
            if mano[i].getSeme()==accusoFinale.getSeme() && mano[i].getPriorityAtout()>tempNum {
                scegliCarta = i
                tempNum = mano[i].getPriorityAtout()
            }
        }
        
        if (scegliCarta < 0) { print("giocaAtoutMAX sta cercando di farmi giocare una carta di valore -1") }
        return scegliCarta
    }
    
    
    
    // Gioco la carta piu bassa a atout
    func giocaAtoutMIN(mano: [Card]) -> Int {
        var scegliCarta = -1
        var tempNum = 30
        
        for i in 0...(mano.count-1) {
            if mano[i].getSeme()==accusoFinale.getSeme() && mano[i].getPriorityAtout()<tempNum {
                scegliCarta = i
                tempNum = mano[i].getPriorityAtout()
            }
        }
        
        if (scegliCarta < 0) { print("giocaAtoutMIN sta cercando di farmi giocare una carta di valore -1") }
        return scegliCarta
    }
    
    
    
    // Gioco la carta piu alta al seme che c'è in campo
    func giocaSemeMAX(mano: [Card]) -> Int {
        var scegliCarta = -1
        var tempNum = 0
            
        for i in 0...(mano.count-1) {
            if mano[i].getSeme()==carteInCampo[0].getSeme() && mano[i].getPriority()>tempNum {
                scegliCarta = i
                tempNum = mano[i].getPriority()
            }
        }
        
        if (scegliCarta < 0) { print("giocaSemeMAX sta cercando di farmi giocare una carta di valore -1") }
        return scegliCarta
    }
    
    
    
    
    // Gioco la carta piu bassa al seme che c'è in campo
    func giocaSemeMIN(mano: [Card]) -> Int {
        var scegliCarta = -1
        var tempNum = 30
        
        for i in 0...(mano.count-1) {
            if mano[i].getSeme()==carteInCampo[0].getSeme() && mano[i].getPriority()<tempNum {
                scegliCarta = i
                tempNum = mano[i].getPriority()
            }
        }
        
        if (scegliCarta < 0) { print("giocaSemeMIN sta cercando di farmi giocare una carta di valore -1") }
        return scegliCarta
    }
    
    
    
    
    // Gioco la carta piu alta che trovo
    func giocaScartoMAX(mano: [Card]) -> Int {
        var scegliCarta = -1
        var tempNum = 0
        var tempSeme = "none"
        
        if carteInCampo.count>0 {tempSeme = carteInCampo[0].getSeme() }
        
        
        for i in 0...(mano.count-1) {
            if !(mano[i].getSeme()==tempSeme) && !(mano[i].getSeme()==accusoFinale.getSeme()) && mano[i].getPriority()>tempNum {
                scegliCarta = i
                tempNum = mano[i].getPriority()
            }
        }
        
        if scegliCarta == -1 {
            scegliCarta = 0
            print("Qualcosa non sta funzionando con giocaScartoMAX")
        }
        
        if (scegliCarta < 0) { print("giocaScartoMAX sta cercando di farmi giocare una carta di valore -1") }
        return scegliCarta
    }
    
    
    
    
    // Gioco la carta peggiore che trovo
    func giocaScartoMIN(mano: [Card]) -> Int {
        var scegliCarta = -1
        var tempNum = 30
        var tempSeme = "none"
        
        if carteInCampo.count>0 {tempSeme = carteInCampo[0].getSeme() }
        
        for i in 0...(mano.count-1) {
            if !(mano[i].getSeme()==tempSeme) && !(mano[i].getSeme()==accusoFinale.getSeme()) && mano[i].getPriority()<tempNum {
                scegliCarta = i
                tempNum = mano[i].getPriority()
            }
        }
        
        if scegliCarta == -1 {
            scegliCarta = 0
            print("Qualcosa non sta funzionando con giocaScartoMIN")
        }
        
        if (scegliCarta < 0) { print("giocaScartoMIN sta cercando di farmi giocare una carta di valore -1") }
        return scegliCarta
    }
    
    
    
    
    
    // conto gli atout in mano
    func contaAtout(mano: [Card]) -> Int {
        var tempConta = 0
        for carta in mano {
            if carta.getSeme() == accusoFinale.getSeme() {
                tempConta=tempConta+1
            }
        }
        return tempConta
    }
    
    
    
    
    // Controllo se la carta che ho scelto supera quello che c'è in camp
    func superoIlCampo(mano: [Card], numeroCarta: Int) -> Bool {
        var tempCampo=carteInCampo
        var supero = true
        
        for i in 0...(carteInCampo.count-1) {
            // prima controllo ci sono atout in campo
            if (tempCampo[i].getSeme()==accusoFinale.getSeme()) {
                if !(mano[numeroCarta].getSeme()==accusoFinale.getSeme()) {
                    
                    // Se in campo ci sono atout e io non ho giocato atout, ho subito perso
                    vinceGiocatoreX = (i+primoAgiocare)%4
                    supero = false
                    
                    
                }
                else if (mano[numeroCarta].getPriorityAtout()<tempCampo[i].getPriorityAtout()) {
                    
                    // Se comunque c'è un atout piu alto del mio, perdo
                    supero = false
                }
            }
            
            // Perdo se è a un seme diverso e non è atout
            else if !(mano[numeroCarta].getSeme()==tempCampo[0].getSeme()) && !(mano[numeroCarta].getSeme()==accusoFinale.getSeme()) {
                supero = false
            }
                
            // altrimenti poi controllo se è allo stesso seme
            else if (tempCampo[0].getSeme()==mano[numeroCarta].getSeme() && mano[numeroCarta].getPriority()<tempCampo[i].getPriority())  {
                
                // Perdo se la mia è allo stesso seme ma piu bassa
                supero = false
            }
        }
        
        return supero
    }
    
    
    
    
    // Controllo chi ha l'atout piu alto in mano
    func chiHaAtoutPiuAlto () -> Int {
        var chi = -1
        var atoutPiuAlto = -1
    
        for i in 0...3 {
            let mano = carteTuttiGiocatori[i]
            for carta in mano {
                if carta.getSeme()==accusoFinale.getSeme() && carta.getPriorityAtout()>atoutPiuAlto {
                    atoutPiuAlto = carta.getPriorityAtout()
                    chi = i
                }
            }
        }
        return chi
    }
    
    
    
    
    
    
    

    
}
