//
//  MainCollectionViewController.swift
//  Caras
//
//  Created by cice on 18/1/17.
//  Copyright © 2017 cice. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

//UserDefaults (Para hacer la aplicacion persistente. Se recomienda no guardar mas de un MegaByte de datos	
    //Bool, Floar, Double, ...

class MainCollectionViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    var gente = [Persona] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPersona))
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        let defaults = UserDefaults.standard
        if let genteGuardada = defaults.object(forKey: "gente") as? Data{
            gente = NSKeyedUnarchiver.unarchiveObject(with: genteGuardada) as! [Persona]
        }
        // Do any additional setup after loading the view.
    }
    
    func addPersona(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true //Aunque no la edite el programa lo entiende como editado
        picker.delegate = self
        present(picker, animated: true)//Hay que añadirle mensaje en info.plist si no te da error
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return gente.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Persona", for: indexPath) as! PersonaCollectionViewCell
    
        // Configure the cell
        //1a manera
        //cell.nombre.text = gente[indexPath.row]._nombre
        
        //2a manera
        let persona = gente[indexPath.item]
        cell.nombre.text = persona._nombre
        
        let path = getDocumentsDirectory().appendingPathComponent(persona._imagen)
        cell.imageView.image = UIImage(contentsOfFile: path.path) //Configuramos la celda con la imagen cogida de la carpeta documentos
        
        cell.imageView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor//Le damos un poco de transparencia
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    //Se ejecuta una vez salido del UIImagePickerController Devuelve una Key
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //Key
            // - UIImagePickerControllerEditedImage
            // - UIImagePickerCOntrollerOriginalImage
        
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else {return}  //Usamos Guard para saber si ha elegido la imagen, si no la elegido salimos con return
      
        //Universally Unique Identifier. Le damos un nombre único para que no haya problemas a la hora de elegirlo
        let imageName = UUID().uuidString
        
        //Cada aplicacion su propia carpeta documentos que va asociada a la cuenta de usuario
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = UIImageJPEGRepresentation(image, 0.8){ //Calidad  float de 0 a 1. Este metodo puede dar errores y te devuelve un optionals por eso utilizamos un safe unrawapping
            //Hemos creado la imagen como jpegrepresentation para guardarla en disco y luego lo intentmaos guardar
        
            try? jpegData.write(to: imagePath)
            
        }
        
        let persona = Persona(nombre: "Persona", imagen: imageName) //Le damos un nombre para poder acceder a el
        gente.append(persona)
        collectionView?.reloadData()
        self.guardar()

        
        dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
    
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)//Esto seria como el sistema de archivos de usuario. Asi que accedemos al sistema de archivos del usuario situdo en la carpeta documentos
        let documentsDirectory = paths[0] //Te devuelde la ruta de las carpetas, donde el primer valor es la que has pedido
        
        return documentsDirectory
        
    }
    
    //Si solo lo queires cunado seleciones en el label tendrias que poner el label como ibaction
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let persona = gente[indexPath.item]
        
        let ac = UIAlertController(title: "Renombrar Persona", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
            
        ac.addAction(UIAlertAction(title: "Ok", style: .default) { _ in
            let nuevoNombre = ac.textFields![0]
            persona._nombre = nuevoNombre.text!
            self.guardar()
            self.collectionView?.reloadData()
        
        })
        present(ac, animated: true)
    }
    
    func guardar(){
        
        //Array -> [Persona, Persona, Persona]
            //Data
        let dataAGuardar = NSKeyedArchiver.archivedData(withRootObject: gente)
        let defaults = UserDefaults.standard
        defaults.setValue(dataAGuardar, forKey: "gente")
        
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
