//
//  ContainerViewController.swift
//  Belote
//
//  Created by Matteo Courthoud on 15/07/16.
//  Copyright © 2016 Matteo Courthoud. All rights reserved.
//

import Cocoa


class ContainerViewController: NSViewController {
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        // Costruisco la storyboard
        let mainStoryboard: NSStoryboard = NSStoryboard(name: "Main", bundle: nil)
        let nextViewController = mainStoryboard.instantiateControllerWithIdentifier("sourceViewController") as! sourceViewController
        self.insertChildViewController(nextViewController, atIndex: 0)
        self.view.addSubview(nextViewController.view)
        self.view.frame = nextViewController.view.frame
        
        
        
        
        
        
        
        
        
    }
    
}
