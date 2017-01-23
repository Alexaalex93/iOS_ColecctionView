//
//  Persona.swift
//  Caras
//
//  Created by cice on 23/1/17.
//  Copyright © 2017 cice. All rights reserved.
//

import UIKit

class Persona: NSObject, NSCoding {
    
    var _nombre: String
    var _imagen: String
    
    init(nombre: String, imagen: String){
    
        self._nombre = nombre
        self._imagen = imagen
    
    }
    
    required init(coder aDecoder: NSCoder){ //Requerido para hacerlo tipo NSCoding
    
        _nombre = aDecoder.decodeObject(forKey: "nombre") as! String
        _imagen = aDecoder.decodeObject(forKey: "imagen") as! String
    
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(_nombre, forKey: "nombre")
        aCoder.encode(_imagen, forKey: "imagen")
    }
}
