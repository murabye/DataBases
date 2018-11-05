//
//  BaseConfigurator.swift
//  MobileAgent
//
//  Created by Вова Петров on 27.09.2018.
//  Copyright © 2018 DartIT. All rights reserved.
//
import Foundation
import UIKit

private let kTabletSuffix = "Pad"

public class BaseModule {
    private(set) weak var _view: BaseViewProtocol!
    private(set) var _interactor: BaseInteractor!
    private(set) var _presenter: BasePresenter!
    private(set) var _router: BaseRouter!
    private(set) var _tableViewModel: BaseTableViewModelProtocol!
    
    required public init() { }
    
    var interactorClass: BaseInteractor.Type?
    var presenterClass: BasePresenter.Type?
    var routerClass: BaseRouter.Type?
    var storyboardName: String?
    var viewClass: UIViewController.Type?
    var tableViewModelClass: BaseTableViewModel.Type?
    

    static func build<T: RawRepresentable & ViperModule>(_ module: T, bundle: Bundle = Bundle.main, deviceType: UIUserInterfaceIdiom? = nil) -> BaseModule where T.RawValue == String {
        //Get class types
        let moduleClass = module.classForViperComponent(.module, bundle: bundle) as! BaseModule.Type
        let M = moduleClass.init()
        
        var interactorClass: BaseInteractor.Type //Если переопределить классы модуля, то создадутся они
        if M.interactorClass != nil {
            interactorClass = M.interactorClass!
        } else {
            interactorClass = module.classForViperComponent(.interactor, bundle: bundle) as! BaseInteractor.Type
        }
        
        var presenterClass: BasePresenter.Type
        if M.presenterClass != nil {
            presenterClass = M.presenterClass!
        } else {
            presenterClass = module.classForViperComponent(.presenter, bundle: bundle) as! BasePresenter.Type
        }
        
        var routerClass: BaseRouter.Type
        if M.routerClass != nil {
            routerClass = M.routerClass!
        } else {
            routerClass = module.classForViperComponent(.router, bundle: bundle) as! BaseRouter.Type
        }
        
        var T: BaseTableViewModel?
        if M.tableViewModelClass != nil {
            T = M.tableViewModelClass!.init()
        } else {
            if let tableClass = module.classForViperComponent(.tableViewModel, bundle: bundle) as! BaseTableViewModel.Type?{
                T = tableClass.init()
            }
        }
        
        //Allocate VIPER components
        let V = loadView(forModule: module, bundle: bundle, deviceType: deviceType, createdModule: M)
        let I = interactorClass.init()
        let P = presenterClass.init()
        let R = routerClass.init()
        
        return build(module: M, view: V, interactor: I, presenter: P, router: R, tableViewModel: T)
    }
}

//MARK: - Change Components
public extension BaseModule {
    
    public func change(view newView: BaseViewProtocol) {
        _view = newView
    }
    
    public func change(interactor newInteractor: BaseInteractor) {
        _interactor = newInteractor
    }
    
    public func change(presenter newPresenter: BasePresenter) {
        _presenter = newPresenter
    }
    
    public func change(router newRouter: BaseRouter) {
        _router = newRouter
    }
    public func change(tableViewModel newTableViewModel: BaseTableViewModelProtocol){
        _tableViewModel = newTableViewModel
    }
    
    public static func loadView(fromStoryboard storyboardName: String, viewClass: UIViewController.Type, viewIdentifier: String) -> UIViewController {
        let sb = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        return sb.instantiateViewController(withIdentifier: viewIdentifier)
    }
}


//MARK: - Helper Methods
private extension BaseModule {
    static func loadView<T: RawRepresentable & ViperModule>(forModule module: T, bundle: Bundle, deviceType: UIUserInterfaceIdiom? = nil, createdModule: BaseModule) -> BaseViewProtocol where T.RawValue == String {
        var viewClass: UIViewController.Type
        if createdModule.viewClass != nil {
            viewClass = createdModule.viewClass!
        } else {
            viewClass = module.classForViperComponent(.view, bundle: bundle, deviceType: deviceType) as! UIViewController.Type
        }
        
        let viewIdentifier = safeString(NSStringFromClass(viewClass).components(separatedBy: ".").last)
        var viewName: String
        
        if createdModule.storyboardName != nil {
            viewName = createdModule.storyboardName!
        } else {
            viewName = module.viewName.uppercasedFirst
        }
        
        switch module.viewType {
        case .storyboard:
            let sb = UIStoryboard(name: viewName, bundle: bundle)
            return sb.instantiateViewController(withIdentifier: viewIdentifier) as! BaseViewProtocol
        case .nib:
            return viewClass.init(nibName: viewName, bundle: bundle) as! BaseViewProtocol
        case .code:
            return viewClass.init() as! BaseViewProtocol
        }
    }
    
    static func build(module: BaseModule, view: BaseViewProtocol, interactor: BaseInteractor, presenter: BasePresenter, router: BaseRouter, tableViewModel: BaseTableViewModel?) -> BaseModule {
        //Module connections
        module._interactor = interactor
        module._view = view
        module._presenter = presenter
        module._router = router
        module._tableViewModel = tableViewModel
        
        //View connection
        view.setModule(module: module)
        
        //Interactor connection
        interactor._module = module
        
        //Presenter connection
        presenter._module = module
        
        //Router connection
        router._module = module
        
        //TableViewModel connection
        tableViewModel?._module = module
        
        return module
    }
}


//MARK: - Private Extension for Application Module generic enum
private extension RawRepresentable where RawValue == String {
    
    func classForViperComponent(_ component: ViperComponent, bundle: Bundle, deviceType: UIUserInterfaceIdiom? = nil) -> Swift.AnyClass? {
        let className = rawValue.uppercasedFirst + component.rawValue.uppercasedFirst
        let bundleName = safeString(bundle.infoDictionary?["CFBundleName"])
        let classInBundle = (bundleName + "." + className).replacingOccurrences(of: " ", with: "_")
        
        if component == .view {
            let deviceType = deviceType ?? UIScreen.main.traitCollection.userInterfaceIdiom
            let isPad = deviceType == .pad
            if isPad, let tabletView = NSClassFromString(classInBundle + kTabletSuffix) {
                return tabletView
            }
        }
        
        return NSClassFromString(classInBundle)
    }
}
