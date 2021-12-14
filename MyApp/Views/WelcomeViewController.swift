//
//  WelcomeViewController.swift
//  MyApp
//
//  Created by Fernando Farias on 29/10/2021.
//

import UIKit

class WelcomeViewController: UIViewController {
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!

    func goToLoginController() {
        let mainVC = UIStoryboard(name: "Main", bundle: nil) as UIStoryboard
        let loginVC = mainVC.instantiateViewController(withIdentifier: "LoginVC") as UIViewController
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true)
        // navigationController?.pushViewController(vc!, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        imageLogo.image = UIImage(named: "Logo")
        // imagenes del sistema: UIImage(systemName: "person.fill")
        // Do any additional setup after loading the view.
    }

    @IBAction func dismiss(_ sender: Any) {
        // navigationController?.popViewController(animated: true)
        goToLoginController()
    }
}
