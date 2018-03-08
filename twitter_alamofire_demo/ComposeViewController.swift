//
//  ComposeViewController.swift
//  twitter_alamofire_demo
//
//  Created by Israel Andrade on 3/5/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit
import RSKPlaceholderTextView

protocol ComposeViewControllerDelegate:NSObjectProtocol{
    func did(post: Tweet)
}
class ComposeViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var textView: RSKPlaceholderTextView!
    weak var delegate: ComposeViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let pictureUrl = User.current?.profile_image_url_https
        let imageURL = URL(string: pictureUrl!)!
        profilePicture.af_setImage(withURL: imageURL)
        // Do any additional setup after loading the view.
        self.textView.placeholder = "What do you want to say about this event?"
        self.view.addSubview(self.textView)
        textView.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapTweet(_ sender: Any) {
        APIManager.shared.tweet()
        APIManager.shared.composeTweet(with: textView.text) { (tweet, error) in
            if let error = error {
                print("Error composing Tweet: \(error.localizedDescription)")
            } else if let tweet = tweet {
                self.delegate?.did(post: tweet)
                print("Compose Tweet Success!")
            }
        }
    }
    

    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // TODO: Check the proposed new text character count
        // Allow or disallow the new text
        // Set the max character limit
        let characterLimit = 140
        
        // Construct what the new text would be if we allowed the user's latest edit
        let newText = NSString(string: textView.text!).replacingCharacters(in: range, with: text)
        
        // TODO: Update Character Count Label
        countLabel.text = String(characterLimit - newText.characters.count)
        
        
        // The new text should be allowed? True/False
        return newText.characters.count < characterLimit
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


