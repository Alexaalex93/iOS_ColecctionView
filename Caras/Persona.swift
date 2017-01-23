//
//  Persona.swift
//  Caras
//
//  Created by cice on 23/1/17.
//  Copyright © 2017 cice. All rights reserved.
//

import UIKit

class Persona: NSObject {
    
    var _nombre: String
    var _imagen: String
    
    init(nombre: String, imagen: String){
    
        self._nombre = nombre
        self._imagen = imagen
    
    }

}
