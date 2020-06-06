//
//  sourceViewController.swift
//  Belote
//
//  Created by Matteo Courthoud on 21/07/16.
//  Copyright © 2016 Matteo Courthoud. All rights reserved.
//

import Cocoa

class sourceViewController: NSViewController {

    @IBOutlet weak var Belote: NSTextField!
    @IBOutlet weak var showPoints: NSTextField!
    
    @IBOutlet weak var Continue: NSButton!
    @IBOutlet weak var newGame: NSButton!
    @IBOutlet weak var rulez: NSButton!
    @IBOutlet weak var quitApp: NSButton!
    
    var puntiAmici = 0
    var puntiNemici = 0

    
    
    
    
    
    
    // Quando carica la schermata
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Belote.stringValue = "Belote"
        
        // Leggo i punti dal file "punteggio.txt"
        var punti=""
        do {
            punti = try String(contentsOfFile: "punteggio.txt", encoding: NSUTF8StringEncoding)
            let score = punti.componentsSeparatedByString("-")
            puntiAmici=Int(score[0])!
            puntiNemici=Int(score[1])!
            print("I punti sono: \(puntiAmici)-\(puntiNemici)")
        }
        catch let error as NSError {
            print("Error: \(error)")
        }
        
        if (puntiAmici>0 || puntiNemici>0) && puntiAmici<2000 && puntiNemici<2000 {
            Continue.enabled = true
            showPoints.stringValue = "Amici: \(puntiAmici) - Nemici: \(puntiNemici)"
        }
            
        else {
            if puntiAmici>=2000 {
                if puntiNemici>puntiAmici { Belote.stringValue = "Hai perso!" }
                else if puntiNemici==puntiAmici { Belote.stringValue = "Pareggio!" }
                else { Belote.stringValue = "Hai vinto!" }
            }
            else if puntiNemici>=2000 { Belote.stringValue = "Hai perso!" }
            
            if puntiAmici>0 || puntiNemici>0 { showPoints.stringValue = "Amici: \(puntiAmici) - Nemici: \(puntiNemici)" }
            
            Continue.enabled = false
        }
        
        
    }
    
    
    
    
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject!) {
        
        // Nuova Partita
        if (segue.identifier == "newgameID") {
            
            Continue.enabled = false
            newGame.enabled = false
            puntiAmici = 0
            puntiNemici = 0
            
            print("NUOVA PARTITA")
            
            // Cancello il vecchio punteggio
            let punteggio = "0-0"
            do {
                try punteggio.writeToFile("punteggio.txt", atomically: true, encoding: NSUTF8StringEncoding)
                print("File deleted")
            }
            catch { print("Error: \(error)") }
            
        }
        
        // Continua Partita
        if (segue.identifier == "continueID") {
         
            
            Continue.enabled = false
            newGame.enabled = false
            
            print("CONTINUA PARTITA")
            
        }
        
        
        
    }
    

    
    
    
    
    @IBAction func quitApp(sender:NSObject) {
        NSApplication.sharedApplication().terminate(self)
    }
    
}
