//
//  TeachingViewController.swift
//  Studium
//
//  Created by Francesco Petrosino on 24/11/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit

class TeachingViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, SWRevealViewControllerDelegate, UIDocumentInteractionControllerDelegate, TeachingDelegate  {
    
    
    
    @IBOutlet weak var oscureLoadingView: UIView!
    @IBOutlet var viewAppoggio: UIView! //Contiene la scrollView
    @IBOutlet var stackView: UIStackView!
    
    @IBOutlet var courseNameLabel: UILabel!
    @IBOutlet var nameTeacherLabel: UILabel!
    
    // --- MARK: Stack View ---
    @IBOutlet weak var showcaseButtonView: UIView!
    @IBOutlet var showcaseButton: UIButton!
    @IBOutlet var showcaseLabel: UILabel!
    
    @IBOutlet weak var notifyButtonView: UIView!
    @IBOutlet var notifyButton: UIButton!
    @IBOutlet var notifyLabel: UILabel!
    
    @IBOutlet weak var syllabusButtonView: UIView!
    @IBOutlet var syllabusButton: UIButton!
    @IBOutlet var syllabusLabel: UILabel!
    
    @IBOutlet weak var descriptionButtonView: UIView!
    @IBOutlet var descriptionButton: UIButton!
    @IBOutlet var descriptionLabel: UILabel!
    
    @IBOutlet weak var documentsButtonView: UIView!
    @IBOutlet var documentsButton: UIButton!
    @IBOutlet var documentsLabel: UILabel!
    
    @IBOutlet weak var bookingButtonView: UIView!
    @IBOutlet var bookingButton: UIButton!
    @IBOutlet var bookingLabel: UILabel!

    // --- MARK: Variables ---
    var actionsView : UIView!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    }
    weak var teachingDataSource: Teaching! //Pre inizializzato - da completare con i dati pesanti
    let pageViewController: UIPageViewController!  = UIPageViewController(transitionStyle: UIPageViewController.TransitionStyle.scroll, navigationOrientation: UIPageViewController.NavigationOrientation.horizontal, options: nil)
    
    lazy var viewControllerList: [UIViewController]! = { return nil }()
    let documentInteractionController = UIDocumentInteractionController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TeachingViewDIdLoad")
        teachingDataSource.attachDelegate(delegate: self)
        courseNameLabel.text = teachingDataSource.name
        nameTeacherLabel.text = teachingDataSource.teacherName
        self.navigationController?.navigationBar.barTintColor = UIColor.clear
        self.courseNameLabel.lineBreakMode = .byTruncatingMiddle
        setUIForLoading()
        guard teachingDataSource.checkVisibility() else{
            setupPrivateCourseActionsView()
            showPrivateCourseAlert()
            return
        }
        loadContent()
        self.documentInteractionController.delegate = self
        self.navigationController?.navigationBar.backgroundColor = UIColor.white //non si sa perchè se metto white diventa del colore giusto.. boooo
    }
    
    func bookingsUpdated() { //called by protocol TeachingDelegate
        guard let _ = viewControllerList else{return}
        for controller in viewControllerList{
            if let c = controller as? BookingPageViewController{
                c.dataSource.items.removeAll()
                c.dataSource.insertBookings(sourceArray: self.teachingDataSource.bookings)
                if let tableview = c.bookingTableView {
                    tableview.reloadData()
                }
                c.bookingTableView.reloadData()
            }
        }
    }
    
    
    func showPrivateCourseAlert(){
        let SSAnimator = CoreSSAnimation.getUniqueIstance()
         SSAnimator.expandViewFromSourceFrame(sourceFrame: CGRect(x: 0, y: self.view.frame.size.height/1.2, width: self.view.frame.size.width, height: 200), viewToExpand: self.actionsView, elementsInsideView: nil, oscureView: nil) { (flag) in
                    
                }
    }
    
    func setupPrivateCourseActionsView(){
        let CV = ConfirmView.getUniqueIstance()
        let actionsViewTitleLabel = setupActionsPrivateCourseViewTitleLabel()
        let actionsViewDescLabel = setupActionsPrivateCourseViewDescLabel()
        let okButton = setupOkActionButton()
        self.actionsView = CV.getView(titleLabel: actionsViewTitleLabel, descLabel: actionsViewDescLabel, buttons: [okButton], dataToAttach: nil)
        self.view.addSubview(actionsView)
        self.actionsView.layer.zPosition = 10
    }
    private func setupActionsPrivateCourseViewTitleLabel() -> UILabel{
        let CV = ConfirmView.getUniqueIstance()
               return CV.getTitleLabel(text: "Corso privato")
    }
    private func setupActionsPrivateCourseViewDescLabel() -> UILabel{
        let CV = ConfirmView.getUniqueIstance()
        return CV.getDescriptionLabel(text: "Chiedi al docente maggiori informazioni")
    }
   
    private func setupOkActionButton()-> UIButton{
        let CV = ConfirmView.getUniqueIstance()
        return CV.getButton(position: .alone, title: "Chiudi", selector: #selector(popTeachController), target: self)
    }
    
    @objc func popTeachController(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
           guard let navVC = self.navigationController else {
               return self
           }
           return navVC
       }
    
    func openFile(tempUrl: URL) {
        documentInteractionController.url = tempUrl
        documentInteractionController.uti = tempUrl.typeIdentifier ?? "public.data, public.content"
        documentInteractionController.name = tempUrl.localizedName ?? tempUrl.lastPathComponent
        let flag = documentInteractionController.presentPreview(animated: true)
        if !flag {documentInteractionController.presentOptionsMenu(from: self.nameTeacherLabel.frame, in: self.view, animated: true)}
    }
    
    func setOscureView(){
        self.oscureLoadingView.isHidden = false
        self.oscureLoadingView.layer.zPosition = 2
        oscureLoadingView.backgroundColor = UIColor.oscureColor
        oscureLoadingView.alpha = 1.0
        let spinner = UIActivityIndicatorView(frame: CGRect(x: self.view.frame.width/2 - 30, y: self.view.frame.height/2-200, width: 60, height: 60))
        oscureLoadingView.addSubview(spinner)
        spinner.layer.zPosition = 4
        spinner.color = UIColor.lightGray
        spinner.style = .large
        spinner.startAnimating()
    }
    private func refreshContent(){
        self.teachingDataSource.removeAllData()
        self.setUIForRefreshing()
        teachingDataSource.refreshData(fromController:self) { (success) in
            if success{
                self.hideLoadingOscureView()
                self.refreshSubViewControllersContent()
            }
            else{
                self.hideSpinnerInOscureView()
            }
        }
    }
    
    private func contentDidLoaded(){
        self.istantiateViewControllers()
        if viewControllerList.count == 0 {
            print("nessun contenuto del corso..!")
            //fai comparire un alert avvisando l'utente
            self.hideSpinnerInOscureView()
            setupNoContentActionsView()
            showNoContentAlert()
            return
        }
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.setPageViewControllerSubviewsNumber()
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        self.setPageControllerLayout()
        self.hideLoadingOscureView()
        self.showStackView()
    }
    
    func showNoContentAlert(){
         let SSAnimator = CoreSSAnimation.getUniqueIstance()
        SSAnimator.expandViewFromSourceFrame(sourceFrame: CGRect(x: 0, y: self.view.frame.size.height/1.2, width: self.view.frame.size.width, height: 200), viewToExpand: self.actionsView, elementsInsideView: nil, oscureView: nil) { (flag) in
            
         }
     }
     
     func setupNoContentActionsView(){
         let CV = ConfirmView.getUniqueIstance()
         let actionsViewTitleLabel = setupNoContentViewTitleLabel()
         let actionsViewDescLabel = setupNoContentViewDescLabel()
         let okButton = setupOkActionButton()
         self.actionsView = CV.getView(titleLabel: actionsViewTitleLabel, descLabel: actionsViewDescLabel, buttons: [okButton], dataToAttach: nil)
         self.view.addSubview(actionsView)
         self.actionsView.layer.zPosition = 10
     }
     private func setupNoContentViewTitleLabel() -> UILabel{
         let CV = ConfirmView.getUniqueIstance()
                return CV.getTitleLabel(text: "Corso senza contenuto")
     }
     private func setupNoContentViewDescLabel() -> UILabel{
         let CV = ConfirmView.getUniqueIstance()
         return CV.getDescriptionLabel(text: "Chiedi al docente maggiori informazioni")
     }
    
    
    private func refreshSubViewControllersContent(){
        if viewControllerList == nil{
            contentDidLoaded()
            return
        }
        for vc in viewControllerList{
            if let v = vc as? NotifyPageViewController{
                v.dataSource.items.removeAll()
                v.dataSource.insertNotifies(sourceArray: self.teachingDataSource.notifyList)
                v.tableView.reloadData()
            }
            else if let v = vc as? DescriptionPageViewController{
                v.dataSource.items.removeAll()
                v.dataSource.insertDescriptionBlocks(sourceArray: self.teachingDataSource.descriptionBlocks)
                v.tableView.reloadData()
            }
            else if let v = vc as? DocumentsPageViewController{
                v.fs = self.teachingDataSource.fs
                v.viewDidLoad()
            }
            else if let v = vc as? BookingPageViewController{
                v.dataSource.items.removeAll()
                v.dataSource.insertBookings(sourceArray: self.teachingDataSource.bookings)
                if let tableview = v.bookingTableView {
                    tableview.reloadData()
                }
            }
        }
    }
    
    private func setUIForRefreshing(){
        self.showSpinnerInOscureView()
        //self.oscureLoadingView.alpha = 0.0
        self.oscureLoadingView.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
             self.oscureLoadingView.alpha = 1.0
        })
    }
    
    
    private func setUIForLoading(){
        self.setOscureView()
        self.stackView.isHidden = true
        self.stackView.alpha = 0.0
    }
    
    private func hideLoadingOscureView(){
        UIView.animate(withDuration: 0.5, animations: {
            self.oscureLoadingView.alpha = 0.0
        }) { (flag1) in
            self.oscureLoadingView.isHidden = true
        }
    }
    private func showStackView(){
        self.stackView.alpha = 0.0
        self.stackView.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.stackView.alpha = 1.0
        }
    }
    private func hideSpinnerInOscureView(){
        for subview in oscureLoadingView.subviews{
            if subview is UIActivityIndicatorView{
                subview.isHidden = true
            }
        }
    }
    private func showSpinnerInOscureView(){
        for subview in oscureLoadingView.subviews{
            if subview is UIActivityIndicatorView{
                subview.isHidden = false
            }
        }
    }
    private func loadContent(){
        teachingDataSource.completeTeachingData(fromController:self) { (wasLoaded,success) in
            if success || wasLoaded {self.contentDidLoaded()}
            else{self.hideSpinnerInOscureView()} //connection error
          //  if wasLoaded && !success {self.contentDidLoaded()} //it was loaded, we have still all data
        }
    }
    
    fileprivate func getShowcaseController() -> ShowcasePageViewController{
        let sb = storyboard!
        let vc = sb.instantiateViewController(withIdentifier: "showcasePageViewController") as! ShowcasePageViewController
        vc.showcaseHTML = teachingDataSource.showcaseHTML
        showcaseButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.sendToShowcaseView(_:))))
        customButtons(button: showcaseButton, image: "showcase", action: #selector(self.sendToShowcaseView(_:)))
        return vc
    }
    
    fileprivate func getNotifyController() -> NotifyPageViewController{
        let sb = storyboard!
        let vc = sb.instantiateViewController(withIdentifier: "notifyPageViewController") as! NotifyPageViewController
        vc.dataSource.insertNotifies(sourceArray: teachingDataSource.notifyList)
        notifyButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.sendToNotifyView(_:))))
        if teachingDataSource.notifyList.isEmpty {
            customButtons(button: notifyButton, image: "markedBell", action: #selector(self.sendToNotifyView(_:)))
        } else {
            customButtons(button: notifyButton, image: "bell", action: #selector(self.sendToNotifyView(_:)))
        }
        return vc
    }
    
    fileprivate func getSyllabusController() -> SyllabusPageViewController {
        let sb = storyboard!
        let vc = sb.instantiateViewController(withIdentifier: "syllabusPageViewController") as! SyllabusPageViewController
        vc.syllabusCode = teachingDataSource.syllabusCode
        syllabusButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.sendToSyllabusView(_:))))
        customButtons(button: syllabusButton, image: "description", action: #selector(self.sendToSyllabusView(_:)))
        return vc
    }
    
    fileprivate func getDescriptionController() -> DescriptionPageViewController {
        let sb = storyboard!
        let vc = sb.instantiateViewController(withIdentifier: "descriptionPageViewController") as! DescriptionPageViewController
        vc.dataSource.insertDescriptionBlocks(sourceArray: self.teachingDataSource.descriptionBlocks)
        descriptionButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.sendToDescriptionView(_:))))
        customButtons(button: descriptionButton, image: "notebook", action: #selector(self.sendToDescriptionView(_:)))
        return vc
    }
    
    fileprivate func getDocumentController() -> DocumentsPageViewController {
        let sb = storyboard!
        let vc = sb.instantiateViewController(withIdentifier: "documentsPageViewController") as! DocumentsPageViewController
        vc.fs = teachingDataSource.fs
        vc.thisTeaching = teachingDataSource
        vc.teachingController = self
        documentsButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.sendToDocumentsView(_:))))
        customButtons(button: documentsButton, image: "folder_1", action: #selector(self.sendToDocumentsView(_:)))
        return vc
    }
    
    fileprivate func getBookingController() -> BookingPageViewController {
        let sb = storyboard!
        let vc = sb.instantiateViewController(withIdentifier: "bookingPageViewController") as! BookingPageViewController
        //vc.haveBooking = teachingDataSource.haveBooking
        vc.dataSource.insertBookings(sourceArray: teachingDataSource.bookings)
        bookingButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.sendToBookingView(_:))))
        customButtons(button: bookingButton, image: "booking", action: #selector(self.sendToBookingView(_:)))
        return vc
    }
    
    private func istantiateViewControllers(){
        viewControllerList = {
            var activeControllerLists = [UIViewController]()
            if teachingDataSource.showcaseHTML != nil && !teachingDataSource.showcaseHTML.isEmpty{
                let vc = getShowcaseController()
                activeControllerLists.append(vc)
            }
            else{ showcaseButtonView.isHidden = true }
            
            if !teachingDataSource.notifyList.isEmpty{
                let vc = getNotifyController()
                activeControllerLists.append(vc)
            }
            else{ notifyButtonView.isHidden = true }
            
            if teachingDataSource.hasSyllabus == true && teachingDataSource.syllabusCode != nil && !teachingDataSource.syllabusCode.isEmpty {
                let vc = getSyllabusController()
                activeControllerLists.append(vc)
            }
            else{ syllabusButtonView.isHidden = true }
            
            
            if teachingDataSource.descriptionBlocks.count > 0 {
                let vc = getDescriptionController()
                activeControllerLists.append(vc)
            }
            else{ descriptionButtonView.isHidden =  true }
            
            if teachingDataSource.fs.currentFolder.childs.count != 0 {
                let vc = getDocumentController()
                activeControllerLists.append(vc)
            }
            else{ documentsButtonView.isHidden = true }
           
            
            if teachingDataSource.haveBooking != nil && teachingDataSource.haveBooking{
                let vc = getBookingController()
                activeControllerLists.append(vc)
            }
            else{ bookingButtonView.isHidden = true }
            
            return activeControllerLists
        }()
    }
    private func setPageControllerLayout(){
        viewAppoggio.frame.size = CGSize(width: self.view.frame.width, height: self.view.frame.height - (stackView.frame.height + courseNameLabel.frame.height + nameTeacherLabel.frame.height)) //definisco le dimensioni reali e di autolayout per la scrollView
            pageViewController.view.frame = CGRect(x: 0.0, y: 0.0, width: viewAppoggio.frame.width, height: viewAppoggio.frame.height)
            viewAppoggio.addSubview(pageViewController.view)
            if let fisrtViewController = viewControllerList.first {
               pageViewController.setViewControllers([fisrtViewController], direction: .forward, animated: true, completion: nil)
            }
            navigationItem.title = "Insegnamento"
            navigationController?.view.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.secondaryBackground, thickness: 0.3)
            for x in stackView.subviews {
                if !x.isHidden {
                    x.backgroundColor = UIColor.buttonSelected
                    break
                }
            }
    }

    private func setPageViewControllerSubviewsNumber() {
        for x in stackView.subviews {
            stackView.addConstraint(x.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1 /
                CGFloat(viewControllerList.count), constant: 0))
        }
    }
    
   private func setAllButtonsViewWithClearBackgroundColor(){
        showcaseButtonView.backgroundColor = UIColor.clear
        notifyButtonView.backgroundColor = UIColor.clear
        syllabusButtonView.backgroundColor = UIColor.clear
        descriptionButtonView.backgroundColor = UIColor.clear
        documentsButtonView.backgroundColor = UIColor.clear
        bookingButtonView.backgroundColor = UIColor.clear
    }
    
    private func customButtons(button: UIButton!, image: String!, action: Selector?){
        let customImageView = UIImageView(frame: CGRect(x: button.frame.size.width/2 - 16, y: button.frame.size.height/2 - 15, width: 32, height: 30))
        customImageView.image = UIImage(named: image!)
        button.addSubview(customImageView)
        button.addTarget(self, action: action!, for: UIControl.Event.touchUpInside)
    }
    
    @IBAction func refreshClicked(_ sender: Any) {
        self.refreshContent()
    }
    
    @objc func sendToShowcaseView(_ sender: UIButton) {
        var i = 0
        for x in viewControllerList {
            if x is ShowcasePageViewController { break }
            i += 1
        }
        pageViewController.setViewControllers([viewControllerList[i]], direction: .forward, animated: false, completion: nil)
        setAllButtonsViewWithClearBackgroundColor()
        showcaseButtonView.backgroundColor = UIColor.buttonSelected
    }
    
    @objc func sendToNotifyView(_ sender: UIButton) {
        var i = 0
        for x in viewControllerList {
            if x is NotifyPageViewController { break }
            i += 1
        }
        pageViewController.setViewControllers([viewControllerList[i]], direction: .forward, animated: false, completion: nil)
        setAllButtonsViewWithClearBackgroundColor()
        notifyButtonView.backgroundColor = UIColor.buttonSelected
    }
    
    @objc func sendToSyllabusView(_ sender: UIButton) {
        var i = 0
        for x in viewControllerList {
            if x is SyllabusPageViewController { break }
            i += 1
        }
        pageViewController.setViewControllers([viewControllerList[i]], direction: .forward, animated: false, completion: nil)
        setAllButtonsViewWithClearBackgroundColor()
        syllabusButtonView.backgroundColor = UIColor.buttonSelected
    }
    
    @objc func sendToDescriptionView(_ sender: UIButton) {
        var i = 0
        for x in viewControllerList {
            if x is DescriptionPageViewController { break }
            i += 1
        }
        pageViewController.setViewControllers([viewControllerList[i]], direction: .forward, animated: false, completion: nil)
        setAllButtonsViewWithClearBackgroundColor()
        descriptionButtonView.backgroundColor = UIColor.buttonSelected
    }
    
    @objc func sendToDocumentsView(_ sender: UIButton) {
        var i = 0
        for x in viewControllerList {
            if x is DocumentsPageViewController { break }
            i += 1
        }
        pageViewController.setViewControllers([viewControllerList[i]], direction: .forward, animated: false, completion: nil)
        setAllButtonsViewWithClearBackgroundColor()
        documentsButtonView.backgroundColor = UIColor.buttonSelected
    }
    
    @objc func sendToBookingView(_ sender: UIButton) {
        var i = 0
        for x in viewControllerList {
            if x is BookingPageViewController { break }
            i += 1
        }
        pageViewController.setViewControllers([viewControllerList[i]], direction: .forward, animated: false, completion: nil)
        setAllButtonsViewWithClearBackgroundColor()
        bookingButtonView.backgroundColor = UIColor.buttonSelected
    }

    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         navigationController?.interactivePopGestureRecognizer?.isEnabled = false
         if (revealViewController().frontViewPosition != FrontViewPosition.left) {
             revealViewController().frontViewPosition = .left
         }
        appDelegate.isFilePresented = false
        //print("TeachingAppeared")
     }
     
     func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
         guard let vcIndex = viewControllerList.firstIndex(of: viewController) else {return nil}
         let previousIndex = vcIndex - 1
         guard previousIndex >= 0 else {return nil}
         guard viewControllerList.count > previousIndex else {return nil}
         return viewControllerList[previousIndex]
     }
     
     func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
         guard let vcIndex = viewControllerList.firstIndex(of: viewController) else {return nil}
         let nextIndex = vcIndex + 1
         guard viewControllerList.count != nextIndex else {return nil}
         guard viewControllerList.count > nextIndex else {return nil}
         return viewControllerList[nextIndex]
     }
    
     func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
         guard completed else { return }
         guard let vc = pageViewController.viewControllers?.first else { return }
         if revealViewController() != nil {
             vc.view.removeGestureRecognizer(revealViewController().panGestureRecognizer())
         }
         setAllButtonsViewWithClearBackgroundColor()
         switch vc {
         case is ShowcasePageViewController:
             showcaseButtonView.backgroundColor = UIColor.buttonSelected
             if revealViewController() != nil {
                 vc.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
             }
             
         case is NotifyPageViewController:
             notifyButtonView.backgroundColor = UIColor.buttonSelected
             
         case is SyllabusPageViewController:
             syllabusButtonView.backgroundColor = UIColor.buttonSelected
             
         case is DescriptionPageViewController:
             descriptionButtonView.backgroundColor = UIColor.buttonSelected
             
         case is DocumentsPageViewController:
             documentsButtonView.backgroundColor = UIColor.buttonSelected
             
         case is BookingPageViewController:
             bookingButtonView.backgroundColor = UIColor.buttonSelected
             
         default:
             break
         }
     }
     
     func revealController(_ revealController: SWRevealViewController!, didMoveTo position: FrontViewPosition) {
         switch position {
         case .right: //Uno dei due menu è aperto
             stackView.isUserInteractionEnabled = false
             self.navigationController?.navigationBar.isUserInteractionEnabled = false
             
         case .left: //Tutti i menu sono chiusi
             stackView.isUserInteractionEnabled = true
             self.navigationController?.navigationBar.isUserInteractionEnabled = true
             
         default:
             break
         }
     }
    deinit{
        print("Deinit Teaching")
    }
    
    
}
