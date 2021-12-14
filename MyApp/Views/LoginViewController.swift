//
//  ViewController.swift
//  MyApp
//
//  Created by Fernando Farias on 22/10/2021.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var user: UITextField!
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var userValidationLabel: UILabel!
    @IBOutlet weak var passValidationLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        user.startInController()
        pass.startInController()
        userValidationLabel.isHidden = true
        passValidationLabel.isHidden = true

        user.addTarget(self, action: #selector(removeValidationLabels(_:)), for: .touchDown)
        pass.addTarget(self, action: #selector(removeValidationLabels(_:)), for: .touchDown)

        // getData()
        // postData()
        // deleteData(id: 2611)
    }

    @objc func removeValidationLabels(_ textfield: UITextField) {
        userValidationLabel.isHidden = true
        passValidationLabel.isHidden = true
    }

    func goToWelcomeController() {
        let mainVC = UIStoryboard(name: "Main", bundle: nil) as UIStoryboard
        let tabBarC = mainVC.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController
        tabBarC?.modalPresentationStyle = .fullScreen
        present(tabBarC!, animated: true)
    }

    func getData() {
        RestServiceManager.shared.getInfo(responseType: GenericUserResponseModel.self,
                                          method: .get, endpoint: "users", body: "") { status, data in
            if let response = data, let dataResponse = response.data {
                print(status)
                print(dataResponse)
            }
        }
    }

    func postData() {
        let user = CreateUserRequestModel(name: "Alex", email: "asd354649@asd.com", gender: "male", status: "active")

        RestServiceManager.shared.getInfo(responseType: CreateUserResponseModel.self, method: .post,
                                       endpoint: "users", body: user) { status, data in
            if let response = data, let dataResponse = response.data {
                print(status)
                print(dataResponse)
            }
        }
    }

    func deleteData(id: Int) {
        RestServiceManager.shared.getInfo(responseType: GenericUserResponseModel.self,
                                          method: .delete, endpoint: "users/\(id)", body: "") { status, data in
            if let response = data, let dataResponse = response.data {
                print(status)
                print(dataResponse)
            }
        }
    }

    @IBAction func `continue`(_ sender: UIButton) {
        guard let username: String = user.text,
              let password: String = pass.text
        else {return}

        let loginValidation: (code: Int, msg: String) = UserViewModel.loginValidation(username, password)
        switch loginValidation.code {
        case 0:
            goToWelcomeController()
        case 1, 2:
            self.user.errorAnimation()
            userValidationLabel.isHidden = false
            userValidationLabel.text = loginValidation.msg
        case 3, 4:
            self.pass.errorAnimation()
            passValidationLabel.isHidden = false
            passValidationLabel.text = loginValidation.msg
        case 5:
            self.user.errorAnimation()
            self.pass.errorAnimation()
            userValidationLabel.isHidden = false
            userValidationLabel.text = loginValidation.msg
        default:
            print("Unknown error")
        }
    }

    @IBAction func secureEntry(_ sender: UIButton) {
        let smallConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .bold, scale: .medium)
        if pass.isSecureTextEntry {
            pass.isSecureTextEntry = false
            sender.setTitle("Hide", for: .normal)
            sender.setImage(UIImage(systemName: "eye.slash", withConfiguration: smallConfig), for: .normal)
        } else {
            pass.isSecureTextEntry = true
            sender.setTitle("Show", for: .normal)
            sender.setImage(UIImage(systemName: "eye", withConfiguration: smallConfig), for: .normal)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension UIColor {
    static var customBackground: UIColor {
        return UIColor(named: "Background") ?? .white
    }
    static var mainColor: UIColor {
        return UIColor(named: "Main") ?? .white
    }
}
