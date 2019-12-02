//
//  ViewController.swift
//  InstaApp Storyboard
//
//  Created by Tushar Gusain on 02/12/19.
//  Copyright © 2019 Hot Cocoa Software. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    var instagramApi = InstagramApi.shared
    var testUserData = InstagramTestUser(access_token: "", user_id: 0)
    var instagramUser: InstagramUser?
    var signedIn = false
    
    @IBOutlet var backgroundImageView: UIImageView!
    
    @IBAction func authenticateOrSignIn(_ sender: UIButton) {
        if self.testUserData.user_id == 0 {
            presentWebViewController()
        } else {
            self.instagramApi.getInstagramUser(testUserData: self.testUserData) { [weak self] (user) in
                self?.instagramUser = user
                self?.signedIn = true
                DispatchQueue.main.async {
                    self?.presentAlert()
                }
            }
        }
    }
    @IBAction func fetchImageToBackground(_ sender: UIButton) {
        if self.instagramUser != nil {
            self.instagramApi.getMedia(testUserData: self.testUserData) { (media) in
                if media.media_type != MediaType.VIDEO {
                    let media_url = media.media_url
                    self.instagramApi.fetchImage(urlString: media_url, completion: { (fetchedImage) in
                        if let imageData = fetchedImage {
                            DispatchQueue.main.async {
                                self.backgroundImageView.image = UIImage(data: imageData)
                            }
                        } else {
                            print("Didn't fetched the data")
                        }
                        
                    })
                    print(media_url)
                } else {
                    print("Fetched media is a video")
                }
            }
        } else {
            print("Not signed in")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImageView.image = UIImage(imageLiteralResourceName: "instagram_background")
    }
    
    func presentAlert() {
        let alert = UIAlertController(title: "Signed In:", message: "with account: @\(self.instagramUser!.username)", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func presentWebViewController() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let webVC = storyBoard.instantiateViewController(withIdentifier: "webView") as! WebViewController
        webVC.instagramApi = self.instagramApi
        webVC.mainVC = self
        self.present(webVC, animated:true)
    }


}

