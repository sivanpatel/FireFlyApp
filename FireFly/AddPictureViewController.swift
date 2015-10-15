//
//  AddPictureViewController.swift
//  FireFly
//
//  Created by Rebecca Appleyard on 26/08/2015.
//  Copyright (c) 2015 Firefly. All rights reserved.
//

import UIKit
import Parse
import Bolts


class AddPictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var img = UIImagePickerController()
    @IBOutlet weak var pictureView: UIImageView!

    @IBOutlet weak var commentView: UITextField!
    
    @IBAction func openPhotoLibrary(sender: AnyObject) {
        img.sourceType = .PhotoLibrary;
        img.allowsEditing = false
        img.modalPresentationStyle = .Popover
        presentViewController(img, animated: true, completion: nil)
    }
    func imagePickerController(img: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject: AnyObject]) {
        
        var pickedImage: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        pictureView.contentMode = .ScaleAspectFit
        pictureView.image = pickedImage
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(imgp: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func upLoadPicture(sender: AnyObject) {
        if let imageData = UIImagePNGRepresentation(pictureView.image) {
            let imageFile = PFFile(data:imageData)
            var userPhoto = PFObject(className:"Images")
            userPhoto["owner"] = PFUser.currentUser()
            userPhoto["imageComment"] = commentView.text
            userPhoto["imageFile"] = imageFile
            userPhoto["likes"] = 0
            
            userPhoto.saveInBackgroundWithBlock({
                (success:Bool, error:NSError?) -> Void in
                if success {
                    self.navigationController?.popToRootViewControllerAnimated(true)
                } else {
                    println("error!")
                }
            })
        } else {

        var uploadError:UIAlertController = UIAlertController(title: "Upload Error", message: "Please select a picture from your gallery to upload!", preferredStyle: UIAlertControllerStyle.Alert)
        var defaultAction = UIAlertAction(title:"OK", style: UIAlertActionStyle.Default, handler: nil)
        uploadError.addAction(defaultAction)
        presentViewController(uploadError, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        img.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
