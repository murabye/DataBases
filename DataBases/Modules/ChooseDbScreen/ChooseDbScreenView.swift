//
//  ChooseDbScreenView.swift
//  DataBases
//
//  Created by варя on 02/11/2018.
//Copyright © 2018 варя. All rights reserved.
//

import UIKit

//MARK: ChooseDbScreenView Class
final class ChooseDbScreenView: BaseTableView {
    @IBOutlet weak var secondAddButton: UIButton!
    @IBOutlet weak var addButton: UIBarButtonItem!
    override func viewDidLoad() {
        let module = AppModules.ChooseDbScreen.build()
        self._module = module
        super.viewDidLoad()
        module.change(view: self)
        updateButtonsState()
    }
    
    @IBAction func adminChange(_ sender: Any) {
        let segmentControl = sender as! UISegmentedControl
        if segmentControl.selectedSegmentIndex == 1 {
            let alert = UIAlertController(title: "Вход администратора", message: "Введите пароль администратора", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { (_) -> Void in
            }
            let saveAction = UIAlertAction(title: "Войти", style: .default) { (_) -> Void in
                let nameField = alert.textFields?[0]
                
                if let password = nameField?.text {
                    if password == "111"{
                        SqlManager.shared.isAdmin = true
                        self.updateButtonsState()
                        return
                    } else {
                        SqlManager.shared.isAdmin = false
                        segmentControl.selectedSegmentIndex = 0
                        self.updateButtonsState()
                    }
                }
                
            }
            
            alert.addTextField { (_) -> Void in }
            alert.textFields![0].placeholder = "Пароль"
            
            alert.addAction(cancelAction)
            alert.addAction(saveAction)
            
            self.present(alert, animated: true, completion: nil)
        } else {
            SqlManager.shared.isAdmin = false
            self.updateButtonsState()
        }
    }
    
    func updateButtonsState() {
        if SqlManager.shared.isAdmin {
            self.addButton.isEnabled = true
            self.secondAddButton.isEnabled = true
        } else {
            self.addButton.isEnabled = false
            self.secondAddButton.isEnabled = false
        }
    }
    @IBAction func addDbButtonAction(_ sender: Any) {
        let alert = UIAlertController(title: "Новое хранилище", message: "Введите название нового хранилища", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { (_) -> Void in
        }
        let saveAction = UIAlertAction(title: "Создать", style: .default) { (_) -> Void in
            let nameField = alert.textFields?[0]
            //TODO:
            if let name = nameField?.text {
                self.presenter.createNewDb(name: name)
            }
            
        }
        
        alert.addTextField { (_) -> Void in }
        alert.textFields![0].placeholder = "Название"
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: - ChooseDbScreenView API
extension ChooseDbScreenView: ChooseDbScreenViewApi {
    var table: UITableView {
        return tableView
    }
    
}

// MARK: - ChooseDbScreenView Viper Components API
private extension ChooseDbScreenView {
    var module: ChooseDbScreenModule {
        return _module as! ChooseDbScreenModule
    }
    var presenter: ChooseDbScreenPresenterApi {
        return module.presenter
    }
}
