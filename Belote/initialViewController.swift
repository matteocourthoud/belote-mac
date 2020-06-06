//
//  initialViewController.swift
//  Belote
//
//  Created by Matteo Courthoud on 19/07/16.
//  Copyright © 2016 Matteo Courthoud. All rights reserved.
//

import Cocoa

class initialViewController: NSViewController {

    
    
    @IBOutlet weak var carta1: NSImageView!
    @IBOutlet weak var carta2: NSImageView!
    @IBOutlet weak var carta3: NSImageView!
    @IBOutlet weak var carta4: NSImageView!
    @IBOutlet weak var carta5: NSImageView!
    @IBOutlet weak var carta6: NSImageView!
    @IBOutlet weak var carta7: NSImageView!
    @IBOutlet weak var carta8: NSImageView!
    var carte_Array = [NSImageView]()
    
    
    @IBOutlet weak var parolaGiocatore1: NSTextFieldCell!
    @IBOutlet weak var parolaGiocatore2: NSTextFieldCell!
    @IBOutlet weak var parolaGiocatore3: NSTextFieldCell!
    var parolaGiocatori_Array = [NSTextFieldCell]()
    
    
    @IBOutlet weak var accusoAzione: NSPopUpButton!
    @IBOutlet weak var accusoValore: NSPopUpButton!
    @IBOutlet weak var accusoSeme: NSPopUpButton!
    @IBOutlet weak var accusoButton: NSButton!
    @IBOutlet weak var giveCards: NSButton!
    @IBOutlet weak var talk: NSButton!
    @IBOutlet weak var nextPhase: NSButton!
    @IBOutlet weak var firstPhase: NSButton!
    
    
    
    
    
    let semi = [String](arrayLiteral: "cuori","fiori","quadri","picche")
    let cartaBlank = Card(semeCarta: "none", numeroCarta: 0)
    var mazzo = [Card]()
    var carteGiocatore0 = [Card]()
    var carteGiocatore1 = [Card]()
    var carteGiocatore2 = [Card]()
    var carteGiocatore3 = [Card]()
    var carteTuttiGiocatori = Array<Array<Card>>()
    var paroleGiocatori = ["","","","",""]
    var puntiInMano_Array = [Card]()
    
    
    var serieAccusi = [Card]()     // Contiene tutta la sequenza degli accusi
    var atout = String.self
    var letsPlay = false        // Controllo se bisogna ancora parlare o si può giocare
    var hannoAperto = Int()   // Variabile che guarda chi apre alla fine
    var hoDatoPunti = [false,false]  // controlla che diano i punti una volta sola (per team)
    var totDelay = 0
    var accusiAmici = [Card]()
    var accusiNemici = [Card]()
    var contro = false
    
    
    
    // Quando carica la schermata
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    // Quando carica tutti gli oggetti
    override var representedObject: AnyObject? {
        didSet {
        }
    }
    
    
    
    
    
    
    
    
    
    // Quando schiaccio il bottono "GIVE CARDS"
    @IBAction func giveCards(sender:NSButton){
        
        // mostro gli altri bottoni e nascondo questo
        accusoAzione.transparent=false
        accusoSeme.transparent=false
        accusoValore.transparent=false
        talk.transparent=false
        talk.title="Parla"
        giveCards.transparent=true
        accusoAzione.enabled=true
        giveCards.enabled = false
        
        
        // riempio gli array dei vari oggetti
        carte_Array=[carta1,carta2,carta3,carta4,carta5,carta6,carta7,carta8]
        parolaGiocatori_Array=[parolaGiocatore2,parolaGiocatore1,parolaGiocatore2,parolaGiocatore3]
        
        
        // Riempio il mazzo
        for seme in semi {
            for value in 1...8 {
                mazzo.append(Card (semeCarta: seme, numeroCarta: value))
            }
        }
        
        // Shuffle deck
        for _ in 0...200 {
            let ran1 = Int(arc4random_uniform(32))
            let ran2 = Int(arc4random_uniform(32))
            let tempCard = mazzo[ran1]
            mazzo[ran1]=mazzo[ran2]
            mazzo[ran2]=tempCard
        }
        
        
        // Read cards
        print("Le mie carte sono:")
        for i in 0...7 {
            carteGiocatore0.append(mazzo[i])
            print("   -   "+mazzo[i].getCarta()+" di "+mazzo[i].getSeme())
        }
        print("Le carte del giocatore 1 sono:")
        for i in 8...15 {
            carteGiocatore1.append(mazzo[i])
            print("   -   "+mazzo[i].getCarta()+" di "+mazzo[i].getSeme())
        }
        print("Le carte del mio amico sono:")
        for i in 16...23 {
            carteGiocatore2.append(mazzo[i])
            print("   -   "+mazzo[i].getCarta()+" di "+mazzo[i].getSeme())
        }
        print("Le carte del giocatore 3 sono:")
        for i in 24...31 {
            carteGiocatore3.append(mazzo[i])
            print("   -   "+mazzo[i].getCarta()+" di "+mazzo[i].getSeme())
        }
        
        
        // Riordino la mia mano
        carteGiocatore0=reorderHand(carteGiocatore0)
        
        
        // Add a blankcard
        serieAccusi.append(Card(semeCarta: "none", numeroCarta: 72))
        
        
        // Mostro le mie carte
        print("bottone schiacciato")
        for i in 0...7 {
            
            carte_Array[i].image = carteGiocatore0[i].getImage()
        }
        
        
        // Riunisco le mani (ordinate) in un array
        carteTuttiGiocatori=[reorderHand(carteGiocatore0),reorderHand(carteGiocatore1),reorderHand(carteGiocatore2),reorderHand(carteGiocatore3)]
        
        
        // Calcolo i punti nella mani di tutti
        for i in 0...3 { puntiInMano_Array.append(calculatePoints(i)) }
        
    }
    
    
    
    
    
    // MMMMMM funza!! Passo le informazioni alla prossima schermata
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "infoID") {
            let svc = segue.destinationController as! infoViewController;
            
            svc.carteGiocatore0 = carteGiocatore0
            svc.carteGiocatore1 = carteGiocatore1
            svc.carteGiocatore2 = carteGiocatore2
            svc.carteGiocatore3 = carteGiocatore3
            svc.accusoFinale = serieAccusi[serieAccusi.count-4]
            svc.serieAccusi = serieAccusi
            svc.accusiAmici = accusiAmici
            svc.accusiNemici = accusiNemici
            svc.contro = contro
            if hannoAperto%2==0 {svc.hannoAperto = "noi"}
            else {svc.hannoAperto = "loro"}
            
            
        }
    }
    
    
    
    
    
    
    
    // Ordino la mano
    func reorderHand(arrayToOrder: [Card]) -> [Card] {
        var tempArray = [Card]()
        for seme in semi {
            for numero in 1...8 {
                for i in 0...7 {
                    if (arrayToOrder[i].getSeme()==seme && arrayToOrder[i].getNumero()==numero) {
                        tempArray.append(arrayToOrder[i])
                    }
                }
            }
        }
        return tempArray
    }
    
    
    
    
    
    
    
    
    // Calcolo punti in mano
    func calculatePoints(numeroGiocatore: Int) -> Card {
        let mano = carteTuttiGiocatori[numeroGiocatore]
        var accuso=cartaBlank
        var tempCard=cartaBlank
        var puntiTiers = 0
        var cartaTiers = 0
        var checkCarre = [0,0,0,0,0,0,0,0]
        
        
        for seme in semi {
            tempCard=Card(semeCarta: seme, numeroCarta: 0)
            for i in 0...7 {
                
                // Controllo gli assi
                if (mano[i].getSeme()==seme) { tempCard=Card(semeCarta: seme, numeroCarta: tempCard.getNumero()+mano[i].getValore()) }
                else { if (mano[i].getNumero()==8) { tempCard=Card(semeCarta: seme, numeroCarta: tempCard.getNumero()+7) }}
                
                // Controllo le tiers
                if (i>1 && mano[i].getSeme()==seme && mano[i-1].getSeme()==seme && mano[i-2].getSeme()==seme && mano[i].getNumero()==mano[i-1].getNumero()+1 && mano[i].getNumero()==mano[i-2].getNumero()+2) {
                    if (i>2 && mano[i-3].getSeme()==seme && mano[i].getNumero()==mano[i-3].getNumero()+3) {
                        if (i>3 && mano[i-4].getSeme()==seme && mano[i].getNumero()==mano[i-4].getNumero()+3) {
                            // HO 100 !!!
                            puntiTiers = 50
                            cartaTiers = mano[i].getNumero()
                            print("Il giocatore \(numeroGiocatore) ha 100 a "+mano[i].getCarta()+" di "+mano[i].getSeme()+"!! Esticazzi!!!")
                        }
                        else {
                            // HO 50 !!!
                            puntiTiers = 25
                            cartaTiers = mano[i].getNumero()
                            print("Il giocatore \(numeroGiocatore) ha 50 a "+mano[i].getCarta()+" di "+mano[i].getSeme()+"! Che culo!!")
                        }
                    }
                    else {
                    // HO TIERS !!!
                    puntiTiers = 10
                    cartaTiers = mano[i].getNumero()
                    print("Il giocatore \(numeroGiocatore) ha tiers a "+mano[i].getCarta()+" di "+mano[i].getSeme()+", not bad!")
                    }
                    
                    // Aggiorno il check per i carrè
                    checkCarre[mano[i].getNumero()-1]=checkCarre[mano[i].getNumero()-1]+1
                }
                
                
            }
            
            
            
            // Aggiungo i punti di tiers, 50 e 100 agli accusi
            tempCard=Card(semeCarta: seme, numeroCarta: tempCard.getNumero()+puntiTiers)
            if puntiTiers > 0 {
                if numeroGiocatore%2==0 {accusiAmici.append(Card(semeCarta: "\(puntiTiers*2)", numeroCarta: cartaTiers))}
                else {accusiNemici.append(Card(semeCarta: "\(puntiTiers*2)", numeroCarta: cartaTiers))}
            }
            puntiTiers=0
            cartaTiers=0
            
            
            // Aggiungo i punti dei carrè agli accusi
            for carta in checkCarre {
                if carta==4 {
                    tempCard=Card(semeCarta: seme, numeroCarta: tempCard.getNumero()+50)
                    let numCarta = checkCarre.indexOf(carta)
                    if numeroGiocatore%2==0 {accusiAmici.append(Card(semeCarta: "carre", numeroCarta: numCarta!))}
                    else {accusiNemici.append(Card(semeCarta: "carre", numeroCarta: numCarta!))}
                    print("Il giocatore \(numeroGiocatore) ha un carre di \(carta)!! WOW!!!")
                }
                
            }
            
            // Aggiungo i punti Belote/Rebelote
            for i in 1...7 {
                if mano[i].getNumero()==7 && mano[i].getSeme() == seme && mano[i-1].getNumero()==6 && mano[i-1].getSeme() == seme {
                    tempCard=Card(semeCarta: seme, numeroCarta: tempCard.getNumero()+12)
                    // Numero carta == 12 indica Belote nella fase dopo. Non modificarlo!
                    if numeroGiocatore%2==0 {accusiAmici.append(Card(semeCarta: seme, numeroCarta: 12))}
                    else {accusiNemici.append(Card(semeCarta: seme, numeroCarta: 12))}
                    print("Il giocatore \(numeroGiocatore) ha belote/rebelote a "+seme+"!! WOW!!!")
                    
                }
            }
            
            // Conto gli assi degli amici
            var compagnoDiTeam = 0
            if numeroGiocatore == 3 {compagnoDiTeam = 1}
            if numeroGiocatore<2 { compagnoDiTeam = numeroGiocatore+2 }
            let manoAmico = carteTuttiGiocatori[compagnoDiTeam]
            for i in 0...7 {
                if manoAmico[i].getNumero()==8 && !(manoAmico[i].getSeme()==seme) {
                    tempCard=Card(semeCarta: seme, numeroCarta: tempCard.getNumero()+7)
                }
            }
            
            
            if (tempCard.getNumero()>accuso.getNumero()) {
                accuso=tempCard
            }
        }
        
        print("Il giocatore \(numeroGiocatore) ha \(accuso.getNumero()) punti a "+accuso.getSeme())
        
        // Aggiungo un elemento random
        accuso=Card(semeCarta: accuso.getSeme() , numeroCarta: accuso.getNumero()-Int(arc4random_uniform(3)))
        
        // Vado a seme
        if (accuso.getNumero()<35) {accuso=Card(semeCarta: accuso.getSeme(), numeroCarta: 0)}
        else if (accuso.getNumero()<38) {accuso=Card(semeCarta: accuso.getSeme(), numeroCarta: 82)}
        else if (accuso.getNumero()<43) {accuso=Card(semeCarta: accuso.getSeme(), numeroCarta: 92)}
        else if (accuso.getNumero()<50) {accuso=Card(semeCarta: accuso.getSeme(), numeroCarta: 102)}
        else if (accuso.getNumero()<60) {accuso=Card(semeCarta: accuso.getSeme(), numeroCarta: 112)}
        else if (accuso.getNumero()<70) {accuso=Card(semeCarta: accuso.getSeme(), numeroCarta: 122)}
        else if (accuso.getNumero()<80) {accuso=Card(semeCarta: accuso.getSeme(), numeroCarta: 132)}
        else if (accuso.getNumero()<90) {accuso=Card(semeCarta: accuso.getSeme(), numeroCarta: 142)}
        else if (accuso.getNumero()<100) {accuso=Card(semeCarta: accuso.getSeme(), numeroCarta: 152)}
        else {accuso=Card(semeCarta: accuso.getSeme(), numeroCarta: 162)}
        
        print("Dopo lunghe riflessioni, il giocatore \(numeroGiocatore) pensa di poter fare \(accuso.getNumero()) a "+accuso.getSeme())
        
        return accuso
    }
    
    
    
    
    
    
    
    
    
    // Do gli accusi quando non ho da aprire
    func doAccuso(mano: [Card], numeroGiocatore: Int) -> Int {
        var semeAmico = "none"
        if serieAccusi.count>1 {semeAmico = serieAccusi[serieAccusi.count-2].getSeme()}
        var countAtout = 0
        var countAssi = 0
        var parola = 0
        for i in 0...7 {
            if (mano[i].getSeme()==semeAmico) {
                countAtout=countAtout+1   // conto gli atout
                if (mano[i].getNumero()==3) {parola = 10}  // se ho il 10 di atout
                if (mano[i].getNumero()==5) {parola = 20}   // se ho il 20 di atout
            } else if (mano[i].getNumero()==8) {countAssi=countAssi+1}  // conto gli assi non atout
        }
        
        print("Giocatore \(numeroGiocatore) ha \(countAssi) assi e \(countAtout) atout")
        print("Il team \(numeroGiocatore%2) ha gia dato punti? \(hoDatoPunti[(numeroGiocatore)%2])")
        
        if (countAtout>2 && hoDatoPunti[(numeroGiocatore)%2]==false) {  // se non ho almeno 2 atout non parlo  ----- NON PEFETTO -----
            paroleGiocatori[numeroGiocatore] = "Alzo \(parola)"
            hannoAperto=numeroGiocatore
            hoDatoPunti[(numeroGiocatore)%2]=true
            return 20
        }
        else if (countAtout==2 && hoDatoPunti[(numeroGiocatore)%2]==false ) {
            paroleGiocatori[numeroGiocatore] = "Ancora \(parola)"
            hannoAperto=numeroGiocatore
            hoDatoPunti[(numeroGiocatore)%2]=true
            if parola>0 {return parola} else {return 10}
        }
        else {
            if countAssi>0 {paroleGiocatori[numeroGiocatore] = "Aspetto"}
            else {paroleGiocatori[numeroGiocatore] = "Passo"}
            return 0
        }
        
    }
    
    
    
    
    
    
    // Parla giocatore
    func parla(mano: [Card], nrGiocatore: Int) -> Card {
        var parola=cartaBlank
        let vadoA = puntiInMano_Array[nrGiocatore]
        
        
        // Se ho piu punti di quello prima e allo stesso seme, do contro (CHECK! PENSO SIA GIUSTO MA NON SONO 100% SICURO)
        if vadoA.getNumero() > serieAccusi[serieAccusi.count-1].getNumero() && (vadoA.getSeme() == serieAccusi[serieAccusi.count-1].getSeme() || (serieAccusi.count>3 && vadoA.getSeme() == serieAccusi[serieAccusi.count-3].getSeme() && serieAccusi[serieAccusi.count-1].getNumero()==serieAccusi[serieAccusi.count-3].getNumero())) {
            
            parola=Card(semeCarta: vadoA.getSeme(), numeroCarta: serieAccusi[serieAccusi.count-1].getNumero())
            paroleGiocatori[nrGiocatore] = ("Contro a "+parola.getSeme())
            hannoAperto=nrGiocatore
            contro=true
            letsPlay=true
            
        }
        
        // Se ho piu punti di quello prima e i nemici non hanno tutti passato, parlo e alzo
        else if vadoA.getNumero() > serieAccusi[serieAccusi.count-1].getNumero() && (serieAccusi.count<=5 || serieAccusi.count>5 && !(serieAccusi[serieAccusi.count-1].getSeme()=="none") && !(serieAccusi[serieAccusi.count-3].getSeme()=="none")) {
            
            parola=Card(semeCarta: vadoA.getSeme(), numeroCarta: serieAccusi[serieAccusi.count-1].getNumero()+10)
            paroleGiocatori[nrGiocatore] = ("\(parola.getNumero()) a "+parola.getSeme())
            hannoAperto=nrGiocatore
            
        }
        
        // Sennò passo/aspetto
        else {
            let tempAccuso = doAccuso(mano,numeroGiocatore: nrGiocatore)
            if tempAccuso==0 {
                parola=Card(semeCarta: "none", numeroCarta: serieAccusi[serieAccusi.count-1].getNumero()+tempAccuso)
            }
            else {
                parola=Card(semeCarta: serieAccusi[serieAccusi.count-2].getSeme(), numeroCarta: serieAccusi[serieAccusi.count-1].getNumero()+tempAccuso)
            }
        }
        
        // Ricordo a tutti a quanto siamo e per chi
        if (nrGiocatore==2) { print("Siamo \(parola.getNumero()) a "+parola.getSeme()+" per noi") }
        else { print("Siamo \(parola.getNumero()) a "+parola.getSeme()+" per loro") }
        
        return parola
    }
    
    
    
    
    
    
    
    // Check if game is over and enable next stage
    func gameEnded() -> Bool {
        var tempGame = false
        if (serieAccusi.count>4) {
            if (serieAccusi[serieAccusi.count-1].getNumero()==serieAccusi[serieAccusi.count-2].getNumero() && serieAccusi[serieAccusi.count-1].getNumero()==serieAccusi[serieAccusi.count-3].getNumero() && serieAccusi[serieAccusi.count-1].getNumero()==serieAccusi[serieAccusi.count-4].getNumero()) {
                tempGame = true
                talk.enabled = false
            }
        }
        return tempGame
    }
    
    
    
    
    // Cosa attiva il primo pulsante
    @IBAction func dichiaro(sender: NSPopUpButton) {
        if sender.indexOfSelectedItem == 1 {
            accusoSeme.enabled = true
            accusoValore.enabled = true
            talk.enabled = false
        }
        else if sender.indexOfSelectedItem == 2 || sender.indexOfSelectedItem == 3 {
            accusoSeme.enabled = false
            accusoValore.enabled = false
            talk.enabled = true
        }
        else if sender.indexOfSelectedItem == 4 && (hannoAperto==1 || hannoAperto==3) {
            accusoSeme.enabled = false
            accusoValore.enabled = false
            talk.enabled = true
        }
        else {
            accusoSeme.enabled = false
            accusoValore.enabled = false
            talk.enabled = false
        }
        
    }
    
    
    
    // Cosa attiva il secondo: posso solo dichiarare oltre
    @IBAction func alzo(sender: NSPopUpButton) {
        let tempAccuso = 72 + 10*sender.indexOfSelectedItem
        if tempAccuso > serieAccusi[serieAccusi.count-1].getNumero() && tempAccuso > 81 && accusoSeme.indexOfSelectedItem>0 {
            talk.enabled = true
        }
        else {
            talk.enabled = false
        }
    }
    
    
    
    // Cosa attiva il terzo: posso solo dichiarare oltre
    @IBAction func seme(sender: NSPopUpButton) {
        let tempAccuso = 72 + 10*accusoValore.indexOfSelectedItem
        if tempAccuso > serieAccusi[serieAccusi.count-1].getNumero() && tempAccuso > 81 && sender.indexOfSelectedItem>0 {
            talk.enabled = true
        }
        else {
            talk.enabled = false
        }
    }
    
    
    
    
    
    
    
    
    
    
    // Quando schiaccio il bottone "TALK"
    @IBAction func accuso(sender:NSButton){
        totDelay = 1
        
        
        for i in 1...3 { self.parolaGiocatori_Array[i].stringValue = "" }
        
        
        if letsPlay==false {
            
            // Passo
            if accusoAzione.indexOfSelectedItem==2 {
                print("Ho scelto di passare")
                serieAccusi.append(Card(semeCarta: "none", numeroCarta: serieAccusi[serieAccusi.count-1].getNumero()))
            }
                
            // Aspetto
            else if accusoAzione.indexOfSelectedItem==3 {
                print("Ho scelto di aspettare")
                serieAccusi.append(Card(semeCarta: "none", numeroCarta: serieAccusi[serieAccusi.count-1].getNumero()))
            }
                
            // Do contro
            else if accusoAzione.indexOfSelectedItem==4 {
                print("Ho scelto di dare contro a "+serieAccusi[serieAccusi.count-1].getSeme())
                serieAccusi.append(Card(semeCarta: serieAccusi[serieAccusi.count-1].getSeme(), numeroCarta: serieAccusi[serieAccusi.count-1].getNumero()))
                hannoAperto = 0
                contro = true
                letsPlay = true
            }
                
            // Parlo!
            else {
                let tempSeme = accusoSeme.titleOfSelectedItem
                let tempValore = 72+accusoValore.indexOfSelectedItem*10
                print("Ho dichiarato \(tempValore) a "+tempSeme!)
                
                // Se è piu alta dell'ultimo accuso, vado io
                if tempValore>serieAccusi[serieAccusi.count-1].getNumero() {
                    serieAccusi.append(Card(semeCarta: tempSeme!, numeroCarta: tempValore))
                    hannoAperto=0
                    print("Siamo a \(tempValore) a "+tempSeme!+" per noi")
                    
                    // Se ho alzato, lo segno
                    if serieAccusi.count>3 && tempSeme == serieAccusi[serieAccusi.count - 3].getSeme() {
                        hoDatoPunti[0]=true
                    }
                
                // Sennò appendo carta blank
                } else {
                    serieAccusi.append(Card(semeCarta: "none", numeroCarta: serieAccusi[serieAccusi.count-1].getNumero()))
                }
                
                
            }
            if gameEnded() {letsPlay=true}
        }
        
        
        
        // Disattivo tutto
        accusoAzione.selectItem(accusoAzione.itemArray[0])
        accusoValore.selectItem(accusoValore.itemArray[0])
        accusoSeme.selectItem(accusoSeme.itemArray[0])
        accusoAzione.enabled=false
        accusoValore.enabled=false
        accusoSeme.enabled=false
        talk.enabled=false
        
        
        
        // parlano gli altri giocatori
        for i in 1...3{
            if letsPlay==false {
                
                serieAccusi.append((parla(carteTuttiGiocatori[i], nrGiocatore: i)))
                
                let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(totDelay) * Int64(NSEC_PER_SEC))
                dispatch_after(time, dispatch_get_main_queue()) {
                    self.parolaGiocatori_Array[i].stringValue = self.paroleGiocatori[i]
                }
                totDelay=totDelay+1
                
                if gameEnded() {letsPlay=true}
            }
        }
        
        
        // Controllo se il gioco è finito
        if letsPlay == true {
            
            // Se qualcuno ha dato conto, i 3 giocatori successivi non parlano
            if contro==true { for _ in 1...3 { serieAccusi.append(cartaBlank) } }
            
            let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(totDelay) * Int64(NSEC_PER_SEC))
            dispatch_after(time, dispatch_get_main_queue()) {
                
                // Se nessuno ha aperto, si torna indietro
                if self.serieAccusi[self.serieAccusi.count-4].getNumero()==72 {
                    self.firstPhase.transparent=false
                    self.firstPhase.title = ("Nessuno ha aperto... Fail \n \n Clicca qua per cominciare un'altra partita.")
                    self.firstPhase.frame = CGRect(x: 130,y: 150,width: 400,height: 120)
                    self.firstPhase.enabled = true
                    self.firstPhase.alphaValue = 0.8
                }
                
                // Se qualcuno ha aperto, si va alla prossima fase
                else {
                    self.performSegueWithIdentifier("infoID", sender: nil)
                }
            }
        }
            
            
        // Se il gioco non è finito, posso riparlare io
        else {
            let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(totDelay) * Int64(NSEC_PER_SEC))
            dispatch_after(time, dispatch_get_main_queue()) {
                self.accusoAzione.enabled=true
            }
        }
        
    }
    

    
    
    
    
}