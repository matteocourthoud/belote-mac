//
//  infoViewController.swift
//  Belote
//
//  Created by Matteo Courthoud on 25/07/16.
//  Copyright © 2016 Matteo Courthoud. All rights reserved.
//

import Cocoa

class infoViewController: NSViewController {
    
    
    @IBOutlet weak var semeField: NSTextField!
    @IBOutlet weak var puntiField: NSTextField!
    @IBOutlet weak var descriptionField: NSTextField!
    
    
    
    // Variabili che eredito
    var carteGiocatore0 = [Card]()
    var carteGiocatore1 = [Card]()
    var carteGiocatore2 = [Card]()
    var carteGiocatore3 = [Card]()
    var accusoFinale = Card(semeCarta: "none", numeroCarta: 0)
    var serieAccusi = [Card]()
    var hannoAperto = "none" // variabile che si ricorda chi ha aperto
    var accusiAmici = [Card]()
    var accusiNemici = [Card]()
    var paroleAmici = [String]()
    var paroleNemici = [String]()
    var accusiAmiciNemici = [0,0]
    var contro = false

    
    
    
    
    
    
    override func viewDidLoad() {
        
        
        
        // Mostro seme e punti
        super.viewDidLoad()
    
        if accusoFinale.getSeme()=="quadri" {semeField.stringValue = "Quadri"}
        if accusoFinale.getSeme()=="picche" {semeField.stringValue = "Picche"}
        if accusoFinale.getSeme()=="fiori" {semeField.stringValue = "Fiori"}
        if accusoFinale.getSeme()=="cuori" {semeField.stringValue = "Cuori"}
        if contro==true { puntiField.stringValue = "contro" }
        else { puntiField.stringValue = "\(accusoFinale.getNumero())" }
        
        // Printo tutti gli accusi
        for accuso in accusiAmici {
            print("Gli amici hanno \(accuso.getNumero()) a "+accuso.getSeme())
        }
        for accuso in accusiNemici {
            print("I nemici hanno \(accuso.getNumero()) a "+accuso.getSeme())
        }
        
        
        // Conto gli accusi
        contaAccusi()
        
        
        // Creo la frase amici
        var fraseAmici = ""
        if paroleAmici.count==0 {
            fraseAmici = "Il tuo team non ha accusi. "
        }
        else {
            fraseAmici = "Il tuo team ha "
            for parola in paroleAmici {
                if paroleAmici.indexOf(parola) == paroleAmici.count-1 {
                    fraseAmici = fraseAmici+parola+". "
                }
                else  {
                    fraseAmici = fraseAmici+parola+", "
                }
            }
        }
        
        
        // Creo la frase nemici
        var fraseNemici = ""
        if paroleNemici.count==0 {
            fraseNemici = "Il team nemico non ha accusi. "
        }
        else {
            fraseNemici = "Il team nemico ha "
            for parola in paroleNemici {
                if paroleNemici.indexOf(parola) == paroleNemici.count-1 {
                    fraseNemici = fraseNemici+parola+". "
                }
                else  {
                    fraseNemici = fraseNemici+parola+", "
                }
            }
        }
        
        
        
        // Creo la frase 1
        var fraseUno = ""
        if hannoAperto == "noi" { fraseUno = "Ha aperto il tuo team. "}
        else { fraseUno = "Hanno aperto loro. " }
        if contro == true {
            if hannoAperto == "noi" { fraseUno = "Il tuo team ha dato contro "}
            else { fraseUno = "Il team rivale ha dato contro. " }
        }
        
        // Creo la frase 2
        var fraseDue = "Si va a \(accusoFinale.getNumero()) a "+accusoFinale.getSeme()+". "
        if contro == true { fraseDue = "Vince chi fa piu punti a "+accusoFinale.getSeme()+". " }
        
        
        
        // Compongo il messaggio
        descriptionField.stringValue = fraseUno+fraseDue+"Sarai tu il primo a giocare. "+fraseAmici+fraseNemici+"Il totale degli accusi è di \(accusiAmiciNemici[0]) per il tuo team e \(accusiAmiciNemici[1]) per i rivali. Schiaccia 'gioca' per cominciare la partita."
        
    }
    
    
    
    
    
    
    // Conto quali sono gli accusi buoni
    func contaAccusi() {
        let squadraTiers=checkTiers() // controlla a chi vanno le tiers
        
        //Accusi amici
        for accuso in accusiAmici {
            
            // Aggiungo le tiers se sono del team
            if accuso.getSeme()=="100" || accuso.getSeme()=="50" || accuso.getSeme()=="20" {
                if squadraTiers=="amici" {
                    accusiAmiciNemici[0]=accusiAmiciNemici[0]+Int(accuso.getSeme())!
                    if accuso.getSeme()=="20" {
                        if accuso.getNumero()==6 { paroleAmici.append("tiers alla "+accuso.getCarta()) }
                        else if accuso.getNumero()==2 || accuso.getNumero()==8 {paroleAmici.append("tiers all'"+accuso.getCarta())}
                        else { paroleAmici.append("tiers al "+accuso.getCarta()) }
                    }
                    else {
                        if accuso.getNumero()==6 { paroleAmici.append(accuso.getSeme()+" alla "+accuso.getCarta()) }
                        else if accuso.getNumero()==2 || accuso.getNumero()==8 {paroleAmici.append(accuso.getSeme()+" all'"+accuso.getCarta())}
                        else { paroleAmici.append(accuso.getSeme()+" al "+accuso.getCarta()) }
                    }
                        
                }
            }
            
            // Aggiungo le belot/rebelot se sono del seme
            if accuso.getNumero()==12 && accuso.getSeme()==accusoFinale.getSeme() {
                accusiAmiciNemici[0]=accusiAmiciNemici[0]+20
                paroleAmici.append("belot e rebelot")
            }
            
            // Aggiungo carre
            if accuso.getSeme()=="carre" {
                if accuso.getNumero()==5 {
                    accusiAmiciNemici[0]=accusiAmiciNemici[0]+200
                    paroleAmici.append("carre di 20")
                }
                else if accuso.getNumero()==3 {
                    accusiAmiciNemici[0]=accusiAmiciNemici[0]+150
                    paroleAmici.append("carre di 10")
                }
                else {
                    accusiAmiciNemici[0]=accusiAmiciNemici[0]+100
                    paroleAmici.append("carre di "+accuso.getCarta())
                }
            }
        }
        
        
        //Accusi nemici
        for accuso in accusiNemici {
            
            // Aggiungo le tiers se sono del team
            if accuso.getSeme()=="100" || accuso.getSeme()=="50" || accuso.getSeme()=="20" {
                if squadraTiers=="nemici" {
                    accusiAmiciNemici[1]=accusiAmiciNemici[1]+Int(accuso.getSeme())!
                    if accuso.getSeme()=="20" {
                        if accuso.getNumero()==6 { paroleNemici.append("tiers alla "+accuso.getCarta()) }
                        else if accuso.getNumero()==2 || accuso.getNumero()==8 {paroleNemici.append("tiers all'"+accuso.getCarta())}
                        else { paroleNemici.append("tiers al "+accuso.getCarta()) }
                    }
                    else {
                        if accuso.getNumero()==6 { paroleNemici.append(accuso.getSeme()+" alla "+accuso.getCarta()) }
                        else if accuso.getNumero()==2 || accuso.getNumero()==8 {paroleNemici.append(accuso.getSeme()+" all'"+accuso.getCarta())}
                        else { paroleNemici.append(accuso.getSeme()+" al "+accuso.getCarta()) }
                    }
                }
            }
            
            // Aggiungo le belot/rebelot se sono del seme
            if accuso.getNumero()==12 && accuso.getSeme()==accusoFinale.getSeme() {
                accusiAmiciNemici[1]=accusiAmiciNemici[1]+20
                paroleNemici.append("belote e rebelote")
            }
            
            // Aggiungo carre
            if accuso.getSeme()=="carre" {
                if accuso.getNumero()==5 {
                    accusiAmiciNemici[1]=accusiAmiciNemici[1]+200
                    paroleNemici.append("carre di 20")
                }
                else if accuso.getNumero()==3 {
                    accusiAmiciNemici[1]=accusiAmiciNemici[1]+150
                    paroleNemici.append("carre di 10")
                }
                else {
                    accusiAmiciNemici[1]=accusiAmiciNemici[1]+100
                    paroleNemici.append("carre di "+accuso.getCarta())
                }
            }
        }
 
        
    }
    
    
    
    
    
    // Controllo a chi vanno le tiers/50/100
    func checkTiers() -> String {
        var team = "amici"
        var checkValore = 0
        var checkNumero = 0
        
        for accuso in accusiAmici {
            if accuso.getSeme()=="100" || accuso.getSeme()=="50" || accuso.getSeme()=="30" {
                if Int(accuso.getSeme())!>12 && Int(accuso.getSeme())! > checkValore {
                    checkValore = Int(accuso.getSeme())!
                    checkNumero = accuso.getNumero()
                }
            }
        }
        
        for accuso in accusiNemici {
            if accuso.getSeme()=="100" || accuso.getSeme()=="50" || accuso.getSeme()=="30" {
                if Int(accuso.getSeme())! > checkValore {
                    if accuso.getNumero() > checkNumero {
                        team = "nemici"
                    }
                }
                
            }
        }
        return team
    }
    
    
    
    
    
    // MMMMMM funza!! Passo le informazioni alla prossima schermata
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "segueID") {
            let svc = segue.destinationController as! finalViewController;
            
            svc.carteGiocatore0 = carteGiocatore0
            svc.carteGiocatore1 = carteGiocatore1
            svc.carteGiocatore2 = carteGiocatore2
            svc.carteGiocatore3 = carteGiocatore3
            svc.accusoFinale = accusoFinale
            svc.serieAccusi = serieAccusi
            svc.accusiAmiciNemici = accusiAmiciNemici
            svc.hannoAperto = hannoAperto
            svc.contro = contro
            
            
        }
    }
    
    
    
    
    
}
