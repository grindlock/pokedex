//
//  ViewController.swift
//  pokedex
//
//  Created by Sergio E. Perez Aponte on 6/19/16.
//  Copyright © 2016 SEPA. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate{
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var musicBtn:UIButton!
    
    var pokemon = [Pokemon]()
    var filteredPokemon = [Pokemon]()
    var musicplayer: AVAudioPlayer!
    var inSearchMode = false
    final var stopPlay = CGFloat(0.2)
    final var playing = CGFloat(1.0)
    var currentAlpha:CGFloat?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        collection.delegate     = self
        collection.dataSource   = self
        searchBar.delegate      = self
        searchBar.returnKeyType = UIReturnKeyType.Done // Change the wording on the keyboard from search to done
        parsePokemonCSV()
        initAudion()
        
        if let c = currentAlpha where c > 0.0{
            musicBtn.alpha = c
        }
    }
    
    func initAudion(){
        let path = NSBundle.mainBundle().pathForResource("music", ofType: "mp3")!
        do{
            musicplayer = try AVAudioPlayer(contentsOfURL: NSURL(string: path)!)
            musicplayer.prepareToPlay()
            musicplayer.numberOfLoops = -1
            musicplayer.play()
            
        }catch let err as NSError{
            print(err.debugDescription)
        }
        
        
    }
    
    func parsePokemonCSV(){
        let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv")!
        
        do{
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            
            for row in rows{
               
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                let poke = Pokemon(name: name, pokedexId: pokeId)
                pokemon.append(poke)
            }
            
        }catch let err as NSError{
            print(err.debugDescription)
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PokeCell", forIndexPath: indexPath) as? PokeCell{
            let poke : Pokemon!
            
            if inSearchMode{
                poke = filteredPokemon[indexPath.row]
            }else{
                poke = pokemon[indexPath.row]
            }
            
            cell.configureCell(poke)
            return cell
        }else{
            return UICollectionViewCell()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        var poke:Pokemon!
        
        if inSearchMode{
            poke = filteredPokemon[indexPath.row]
        }else{
            poke = pokemon[indexPath.row]
        }
        
        performSegueWithIdentifier("pokemonDetailVC", sender: poke)
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inSearchMode{
            return filteredPokemon.count
        }else{
            return pokemon.count
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(105, 105)
    }

    @IBAction func musicBtnPressed(sender: UIButton!) {
        
        if musicplayer.playing{
            musicplayer.stop()
            sender.alpha = stopPlay
            currentAlpha = stopPlay
            
        }else{
            musicplayer.play()
            sender.alpha = playing
            currentAlpha = playing
        }
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            //view.endEditing(true)//close keyboard
            collection.reloadData()
            view.endEditing(true)//close keyboard
            
        }else{
            inSearchMode = true
            let lower = searchBar.text!.lowercaseString
            // section 10 video 118 at mark 8 min
            filteredPokemon = pokemon.filter({$0.name.rangeOfString(lower) != nil})
            collection.reloadData()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "pokemonDetailVC"{
            if let detailsVC = segue.destinationViewController as? PokemonDetailVC{
                if let poke = sender as? Pokemon{
                    detailsVC.pokemon = poke
                    detailsVC.audio = musicplayer
                    detailsVC.currentAlpha = currentAlpha
                }
            }
        }
    }
    
    // this get the alpha level of the music button at pokemonVC and set the music button in viewcontroller to the value
    @IBAction func unwindToMain(segue: UIStoryboardSegue){
        if segue.identifier == "goBack"{
            if let detailVC = segue.sourceViewController as? PokemonDetailVC {
                currentAlpha = detailVC.currentAlpha
                musicBtn.alpha = currentAlpha!
            }
        }
    }
    
   
}

