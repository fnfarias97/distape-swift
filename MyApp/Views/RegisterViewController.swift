//
//  RegisterViewController.swift
//  MyApp
//
//  Created by Fernando Farias on 27/10/2021.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet var background: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var user: UITextField!
    @IBOutlet weak var socialButton: UIButton!
    @IBOutlet weak var userValidationLabel: UILabel!
    var facebook: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        user.startInController()
        // Do any additional setup after loading the view.
        userValidationLabel.isHidden = true
        user.addTarget(self, action: #selector(removeValidationLabels(_:)), for: .touchDown)
    }

    @objc func removeValidationLabels(_ textfield: UITextField) {
        userValidationLabel.isHidden = true
    }

    func goToWelcomeController() {
        view.endEditing(true)
        let mainVC = UIStoryboard(name: "Main", bundle: nil) as UIStoryboard
        let tabBarC = mainVC.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController
        tabBarC?.modalPresentationStyle = .fullScreen
        present(tabBarC!, animated: true)
    }

    @IBAction func register(_ sender: Any) {
        guard let username: String = user.text else {return}
        let registerValidation: (code: Int, msg: String) = UserViewModel.registerValidation(username)

        switch registerValidation.code {
        case 0:
            goToWelcomeController()
        case 1, 2, 6:
            self.user.errorAnimation()
            userValidationLabel.isHidden = false
            userValidationLabel.text = registerValidation.msg
        default:
            print("Unknown error")
        }
    }

    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func facebookButton(_ sender: UIButton) {
        var myBGColor: UIColor?
        var myTintColor: UIColor?

        if facebook {
            myBGColor = UIColor(named: "Main")
            myTintColor = UIColor(named: "Background")
            facebook = false
        } else {
            myBGColor = UIColor.systemBlue
            myTintColor = UIColor.white
            facebook = true
        }

        sender.backgroundColor = myBGColor
        sender.tintColor = myTintColor
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
