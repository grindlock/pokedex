//
//  PokemonDetailVC.swift
//  pokedex
//
//  Created by Sergio E. Perez Aponte on 6/23/16.
//  Copyright © 2016 SEPA. All rights reserved.
//

import UIKit
import AVFoundation

class PokemonDetailVC: UIViewController {
    
    var pokemon: Pokemon!
    var audio: AVAudioPlayer!
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var pokedexLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    @IBOutlet weak var evoLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLbl.text = pokemon.name.capitalizedString
        let img = UIImage(named: "\(pokemon.pokedexId)")
        mainImg.image = img
        currentEvoImg.image = img
        
        pokemon.downloadPokemonDetails { () -> () in
            //this will be called after download is done
            self.updateUI()
            
        }
    }
    
    func updateUI() {
            descriptionLbl.text = pokemon.description
            typeLbl.text = pokemon.type
            defenseLbl.text = pokemon.defense
            heightLbl.text = pokemon.height
            pokedexLbl.text = "\(pokemon.pokedexId)"
            weightLbl.text = pokemon.weight
            attackLbl.text = pokemon.attact
        
        if pokemon.nextEvoId == "" {
            evoLbl.text = "No Evolutions"
            nextEvoImg.hidden = true
        }
        else{
            nextEvoImg.hidden = false
            nextEvoImg.image = UIImage(named: pokemon.nextEvoId)
            var str = "Next Evolution: \(pokemon.nextEvoTxt)"
            if pokemon.nextEvoLvl != ""{
                str += " - LVL \(pokemon.nextEvoLvl)"
            }
        }
        
    }
    
    @IBAction func backBtnPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func musicBtnPressed(sender: UIButton!) {
        
        if audio.playing{
            audio.stop()
            sender.alpha = 0.2
        }else{
            audio.play()
            sender.alpha = 1.0
        }
        
    }
}
