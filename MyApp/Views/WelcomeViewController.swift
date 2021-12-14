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
        gesturesManager()
    }

    private func gesturesManager() {
        self.imageLogo.isUserInteractionEnabled = true
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        self.imageLogo.addGestureRecognizer(pinch)
        // let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        // self.imageLogo.addGestureRecognizer(tap)

    }

    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return }
        guard let compiled = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else { return }
        guard let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String else { return }
        let alert = UIAlertController(title: "Info",
                                      message: "Copyright @ 2021\n\(appName)\nVersion \(version) (\(compiled))",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Got it", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @objc func handlePinch(_ sender: UIPinchGestureRecognizer) {
        print("hola")
        if let scale = (sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)) {
                   guard scale.a > 1.0 else { return }
                   guard scale.d > 1.0 else { return }
                    sender.view?.transform = scale
                   sender.scale = 1
        }
    }

    @IBAction func dismiss(_ sender: Any) {
        goToLoginController()
    }
}
