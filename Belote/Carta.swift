//
//  Carta.swift
//  Belote
//
//  Created by Matteo Courthoud on 15/07/16.
//  Copyright © 2016 Matteo Courthoud. All rights reserved.
//

import Foundation
import Cocoa

class Card {
    
    var semeCarta:String
    var numeroCarta:Int
    
    init(semeCarta:String, numeroCarta:Int){
        
        self.semeCarta=semeCarta
        self.numeroCarta=numeroCarta
        
    }
    
    func getSeme() -> String {
        return self.semeCarta
    }
    
    func getNumero() -> Int {
        return self.numeroCarta
    }
    
    
    // VALORE PER PAROLA INIZIALE
    func getValore() -> Int {
        if (numeroCarta==1){
            return 5
        }
        if (numeroCarta==2){
            return 5
        }
        if (numeroCarta==3){
            return 13
        }
        if (numeroCarta==4){
            return 8
        }
        if (numeroCarta==5){
            return 20
        }
        if (numeroCarta==6){
            return 6
        }
        if (numeroCarta==7){
            return 7
        }
        if (numeroCarta==8){
            return 9
        }
        else {
            return 0
        }
    }
    
    
    // PUNTI CARTE
    func getPunti() -> Int {
        if (numeroCarta==1){
            return 0
        }
        if (numeroCarta==2){
            return 0
        }
        if (numeroCarta==3){
            return 0
        }
        if (numeroCarta==4){
            return 10
        }
        if (numeroCarta==5){
            return 2
        }
        if (numeroCarta==6){
            return 3
        }
        if (numeroCarta==7){
            return 4
        }
        if (numeroCarta==8){
            return 11
        }
        else {
            return 0
        }
    }
    
    
    // PUNTI ATOUT
    func getPuntiAtout() -> Int {
        if (numeroCarta==1){
            return 0
        }
        if (numeroCarta==2){
            return 0
        }
        if (numeroCarta==3){
            return 14
        }
        if (numeroCarta==4){
            return 10
        }
        if (numeroCarta==5){
            return 20
        }
        if (numeroCarta==6){
            return 3
        }
        if (numeroCarta==7){
            return 4
        }
        if (numeroCarta==8){
            return 11
        }
        else {
            return 0
        }
    }
    
    
    // PRIORITA
    func getPriority() -> Int {
        if (numeroCarta==1){
            return 1
        }
        if (numeroCarta==2){
            return 2
        }
        if (numeroCarta==3){
            return 3
        }
        if (numeroCarta==4){
            return 7
        }
        if (numeroCarta==5){
            return 4
        }
        if (numeroCarta==6){
            return 5
        }
        if (numeroCarta==7){
            return 6
        }
        if (numeroCarta==8){
            return 8
        }
        else {
            return 0
        }
    }
    
    
    
    // PRIORITA ATOUT
    func getPriorityAtout() -> Int {
        if (numeroCarta==1){
            return 1
        }
        if (numeroCarta==2){
            return 2
        }
        if (numeroCarta==3){
            return 14
        }
        if (numeroCarta==4){
            return 7
        }
        if (numeroCarta==5){
            return 20
        }
        if (numeroCarta==6){
            return 5
        }
        if (numeroCarta==7){
            return 6
        }
        if (numeroCarta==8){
            return 8
        }
        else {
            return 0
        }
    }
    
    
    
    
    // NOME CARTA
    func getCarta() -> String {
        if (numeroCarta==1){
            return "sette"
        }
        if (numeroCarta==2){
            return "otto"
        }
        if (numeroCarta==3){
            return "nove"
        }
        if (numeroCarta==4){
            return "dieci"
        }
        if (numeroCarta==5){
            return "fante"
        }
        if (numeroCarta==6){
            return "donna"
        }
        if (numeroCarta==7){
            return "re"
        }
        if (numeroCarta==8){
            return "asso"
        }
        else {
            return "BOH!"
        }
    }
    
    
    // IMMAGINE CARTA
    func getImage() -> NSImage {
        if ( semeCarta == "picche" && numeroCarta==1 ){
            return NSImage(named:"picche7")!
        }
        if ( semeCarta == "picche" && numeroCarta==2 ){
            return NSImage(named:"picche8")!
        }
        if ( semeCarta == "picche" && numeroCarta==3 ){
            return NSImage(named:"picche9")!
        }
        if ( semeCarta == "picche" && numeroCarta==4 ){
            return NSImage(named:"picche10")!
        }
        if ( semeCarta == "picche" && numeroCarta==5 ){
            return NSImage(named:"piccheJ")!
        }
        if ( semeCarta == "picche" && numeroCarta==6 ){
            return NSImage(named:"piccheQ")!
        }
        if ( semeCarta == "picche" && numeroCarta==7 ){
            return NSImage(named:"piccheK")!
        }
        if ( semeCarta == "picche" && numeroCarta==8 ){
            return NSImage(named:"piccheA")!
        }
        if ( semeCarta == "cuori" && numeroCarta==1 ){
            return NSImage(named:"cuori7")!
        }
        if ( semeCarta == "cuori" && numeroCarta==2 ){
            return NSImage(named:"cuori8")!
        }
        if ( semeCarta == "cuori" && numeroCarta==3 ){
            return NSImage(named:"cuori9")!
        }
        if ( semeCarta == "cuori" && numeroCarta==4 ){
            return NSImage(named:"cuori10")!
        }
        if ( semeCarta == "cuori" && numeroCarta==5 ){
            return NSImage(named:"cuoriJ")!
        }
        if ( semeCarta == "cuori" && numeroCarta==6 ){
            return NSImage(named:"cuoriQ")!
        }
        if ( semeCarta == "cuori" && numeroCarta==7 ){
            return NSImage(named:"cuoriK")!
        }
        if ( semeCarta == "cuori" && numeroCarta==8 ){
            return NSImage(named:"cuoriA")!
        }
        if ( semeCarta == "fiori" && numeroCarta==1 ){
            return NSImage(named:"fiori7")!
        }
        if ( semeCarta == "fiori" && numeroCarta==2 ){
            return NSImage(named:"fiori8")!
        }
        if ( semeCarta == "fiori" && numeroCarta==3 ){
            return NSImage(named:"fiori9")!
        }
        if ( semeCarta == "fiori" && numeroCarta==4 ){
            return NSImage(named:"fiori10")!
        }
        if ( semeCarta == "fiori" && numeroCarta==5 ){
            return NSImage(named:"fioriJ")!
        }
        if ( semeCarta == "fiori" && numeroCarta==6 ){
            return NSImage(named:"fioriQ")!
        }
        if ( semeCarta == "fiori" && numeroCarta==7 ){
            return NSImage(named:"fioriK")!
        }
        if ( semeCarta == "fiori" && numeroCarta==8 ){
            return NSImage(named:"fioriA")!
        }
        if ( semeCarta == "quadri" && numeroCarta==1 ){
            return NSImage(named:"quadri7")!
        }
        if ( semeCarta == "quadri" && numeroCarta==2 ){
            return NSImage(named:"quadri8")!
        }
        if ( semeCarta == "quadri" && numeroCarta==3 ){
            return NSImage(named:"quadri9")!
        }
        if ( semeCarta == "quadri" && numeroCarta==4 ){
            return NSImage(named:"quadri10")!
        }
        if ( semeCarta == "quadri" && numeroCarta==5 ){
            return NSImage(named:"quadriJ")!
        }
        if ( semeCarta == "quadri" && numeroCarta==6 ){
            return NSImage(named:"quadriQ")!
        }
        if ( semeCarta == "quadri" && numeroCarta==7 ){
            return NSImage(named:"quadriK")!
        }
        if ( semeCarta == "quadri" && numeroCarta==8 ){
            return NSImage(named:"quadriA")!
        }
        else {
            return NSImage(named:"cover")!

        }
    }
}





// Nel secondo campo, devo salvare carta+proprietario... salvo una CardToShow
class CardToShow {
    
    var cartaDaMostrare: Card
    var proprietarioCarta: Int
    
    init(cartaDaMostrare: Card, proprietarioCarta: Int) {
        self.cartaDaMostrare=cartaDaMostrare
        self.proprietarioCarta=proprietarioCarta
    }
    
    func getImageToShow() -> NSImage {
        return self.cartaDaMostrare.getImage()
    }
    
    func getProprietario() -> Int {
        return self.proprietarioCarta
    }
    
}


