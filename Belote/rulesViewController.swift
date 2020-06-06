//
//  rulesViewController.swift
//  Belote
//
//  Created by Matteo Courthoud on 21/07/16.
//  Copyright © 2016 Matteo Courthoud. All rights reserved.
//

import Cocoa

class rulesViewController: NSViewController {


    
    @IBOutlet weak var scrollView: NSScrollView!
    @IBOutlet var regoleBelote: NSTextView!


    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        
        // Leggo le regole dal file
        do {
            let path = NSBundle.mainBundle().pathForResource("Regole", ofType: "txt")
            let regoleBelot = try String(contentsOfFile: path!, encoding: NSUTF8StringEncoding)
            regoleBelote.string = regoleBelot
            print("Ho trovato le regole")
        }
        catch let error as NSError {
            print("Error: \(error)")
        }
        
        
        
    
        
    }
    
}
