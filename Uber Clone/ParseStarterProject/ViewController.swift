
import UIKit
import Parse


// ec2-3-18-113-237.us-east-2.compute.amazonaws.com - link
// user - username
// c2wiBzva6dRC - password



class ViewController: UIViewController {
    
    func displayAlert(title: String, message: String) {
        
        let alertcontroller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertcontroller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alertcontroller,animated: true)
        
    }
    
    var signUpMode = true
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var switchRiderDriver: UISwitch!
    
    @IBOutlet weak var riderLabel: UILabel!
    
    @IBOutlet weak var driverLabel: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func login(_ sender: Any) {
        
        if usernameTextField.text == "" || passwordTextField.text == "" {
            
            displayAlert(title: "Error in form!", message: "Username and password are required.")
            
        } else {
            
            if signUpMode {
                
                let user = PFUser()
                
                user.username = usernameTextField.text
                user.password = passwordTextField.text
                
                user["isDriver"] = switchRiderDriver.isOn
                
                user.signUpInBackground { (success, error) in
                    
                    if let error = error {
                        
                        var displayedErrorMessage = "Please try again later"
                        
                        if let parseError = error._userInfo?["error"] as? String {
                            
                            displayedErrorMessage = parseError
                            
                        }
                        
                        self.displayAlert(title: "Sign Up Failed", message: displayedErrorMessage)
                        
                    } else {
                        
                        print("Sign Up Successful")
                        
                        if let isDriver = PFUser.current()?["isDriver"] as? Bool {
                            
                            if isDriver {
                                
                                self.performSegue(withIdentifier: "showDriverViewController", sender: self)
                                
                            } else {
                                
                                self.performSegue(withIdentifier: "showRiderViewController", sender: self)
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            } else {
                
                PFUser.logInWithUsername(inBackground: usernameTextField.text!, password: passwordTextField.text!, block: { (user, error) in
                    
                    if let error = error {
                        
                        var displayedErrorMessage = "Please try again later"
                        
                        if let parseError = error._userInfo?["error"] as? String {
                            
                            displayedErrorMessage = parseError
                            
                        }
                        
                        self.displayAlert(title: "Sign Up Failed", message: displayedErrorMessage)
                        
                    } else {
                        
                        print("Log In Successful")
                        
                        if let isDriver = PFUser.current()?["isDriver"] as? Bool {
                            
                            if isDriver {
                                
                                self.performSegue(withIdentifier: "showDriverViewController", sender: self)
                                
                            } else {
                                
                                self.performSegue(withIdentifier: "showRiderViewController", sender: self)
                                
                            }
                            
                        }
                        
                    }
                    
                })
                
            }
            
        }
        
    }
    
    @IBOutlet weak var changeModeButton: UIButton!
    
    @IBAction func changeMode(_ sender: Any) {
        
        if signUpMode {
            
            loginButton.setTitle("Log In", for: [])
            
            changeModeButton.setTitle("Switch To Sign Up", for: [])
            
            signUpMode = false
            
            switchRiderDriver.isHidden = true
            
            riderLabel.isHidden = true
            
            driverLabel.isHidden = true
            
        } else {
            
            loginButton.setTitle("Sign Up", for: [])
            
            changeModeButton.setTitle("Switch to Log In", for: [])
            
            signUpMode = true
            
            switchRiderDriver.isHidden = false
            
            riderLabel.isHidden = false
            
            driverLabel.isHidden = false
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let isDriver = PFUser.current()?["isDriver"] as? Bool {
            
            if isDriver {
                
                performSegue(withIdentifier: "showDriverViewController", sender: self)
                
            } else {
                
                self.performSegue(withIdentifier: "showRiderViewController", sender: self)
                
            }
            
        }
        
    }
    
    
        override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
