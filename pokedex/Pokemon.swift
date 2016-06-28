//
//  Pokemon.swift
//  pokedex
//
//  Created by Sergio E. Perez Aponte on 6/19/16.
//  Copyright © 2016 SEPA. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon{

    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type:String!
    private var _defense:String!
    private var _height: String!
    private var _weight:String!
    private var _attack: String!
    private var _nexEvoTxt: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLvl: String!
    
    private var _pokemonUrl: String!
    
    
    var name: String {
        get{
            return _name
        }
    }
    
    var pokedexId:Int{
        get{
            return _pokedexId
        }
    }
    
    var description: String{
        if _description == nil{
            _description = ""
        }
        return _description
    }
    
    var type: String{
        if _type == nil{
            _type = ""
        }
        return _type
    }
    
    var  defense: String{
        if _defense == nil{
            _defense = ""
        }
        return _defense
    }
    
    var height:String{
        if _height == nil{
            _height = ""
        }
        return _height
    }
    
    var weight:String{
        if _weight == nil{
            _weight = ""
        }
        return _weight
    }
    var attact:String{
        if _attack == nil{
            _attack = ""
        }
        return _attack
    }
    
    var nextEvoTxt:String{
        get{
            if _nexEvoTxt == nil{
                _nexEvoTxt = ""
            }
            return _nexEvoTxt
        }
    }
    
    var nextEvoId: String{
        get{
            if _nextEvolutionId == nil{
                _nextEvolutionId = ""
            }
           
            return _nextEvolutionId
        }
        
    }
    
    var nextEvoLvl: String{
        get{
            if _nextEvolutionLvl == nil{
                _nextEvolutionLvl = ""
            }
             return _nextEvolutionLvl
        }
       
    }
    
    init(name: String, pokedexId: Int){
        self._name = name
        self._pokedexId = pokedexId
        
        _pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId)/"
    }
    
    func downloadPokemonDetails(completed: DownloadComplete){
        let url = NSURL(string: _pokemonUrl)!
        Alamofire.request(.GET, url).responseJSON{response in
            let result = response.result
            print(result.debugDescription)
            if let dict = result.value as? Dictionary<String, AnyObject>{
                if let weight = dict["weight"] as? String{
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String{
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int{
                    self._attack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int{
                    self._defense = "\(defense)"
                }
                print(" defenses  \(self._defense)")
                //types is a string and the values is a dictionary of string strings
                if let types = dict["types"] as? [Dictionary<String, String>] where types.count > 0 {
                   
                    if let name = types[0]["name"]{
                            self._type = name.capitalizedString
                    }
                    
                    if types.count > 1{
                        for x in 1 ... types.count-1 {
                            if let name  = types[x]["name"]{
                                //this how to append more string to the varible
                                self._type! += " / \(name.capitalizedString)"
                            }
                        }
                    }
                }else{
                    self._type = ""
                }
                
                if let descArr = dict["descriptions"] as? [Dictionary<String, String>] where descArr.count > 0{
                    if let url = descArr[0]["resource_uri"]{
                        let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                        Alamofire.request(.GET, nsurl).responseJSON{ response in
                            let desResult = response.result
                            if let descDict = desResult.value as? Dictionary<String, AnyObject>{
                                if let description = descDict["description"] as? String{
                                    //this looks for a string and replace it with another
                                    let des = description.stringByReplacingOccurrencesOfString("POKMON", withString: "pokémom")
                                    self._description = des
                                    print("description: \(self._description)")
                                }
                            }
                            completed()
                        }
                    }
                }else{
                    self._description = ""
                }
                
                if let evolution = dict["evolutions"] as? [Dictionary<String, AnyObject>] where evolution.count > 0{
                    if let to = evolution[0]["to"] as? String {
                        //mega is not found. cant support mega pokemon right now. api still has mega data
                        if to.rangeOfString("mega") == nil{
                            if let str = evolution[0]["resource_uri"] as? String {
                                let newStr = str.stringByReplacingOccurrencesOfString("api/v1/pokemon/", withString: "")
                                let num = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                
                                self._nextEvolutionId = num
                                self._nexEvoTxt = to
                                if let levl = evolution[0]["level"] as? Int{
                                    self._nextEvolutionLvl = "\(levl)"
                                }
                                
                            }
                        }
                    }
                }
            }
        }
    }
}