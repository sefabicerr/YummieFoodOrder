//
//  PlaceAnOrderViewController.swift
//  Yummie
//
//  Created by Muhammed Sefa Biçer on 8.06.2022.
//

import UIKit

class PlaceAnOrderViewController: UIViewController,AlertProtocol {

    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var adressView: UIView!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var adressLbl: UILabel!
    
    //MARK: - Vars
    var order: Ordered?
    var isBell = false
    var isService = false
    var isDeliveryTypeYummie = true
    var isDeliveryTypeResto = false
    var discount = 0
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        registerCells()
        adressView.roundCorners([.bottomRight, .topRight], radius: 22)
    }
    override func viewWillAppear(_ animated: Bool) {
        getUserAdress()
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        createNotificationObserver()
    }
    
    //MARK: -Connection of cell design
    private func registerCells() {
        tableView.register(NoteTableViewCell.nib(), forCellReuseIdentifier: NoteTableViewCell.identifier)
        tableView.register(CheckBoxTableViewCell.nib(), forCellReuseIdentifier: CheckBoxTableViewCell.identifier)
        tableView.register(PaymentMethodTableViewCell.nib(), forCellReuseIdentifier: PaymentMethodTableViewCell.identifier)
        tableView.register(TypeOfDeliveryTableViewCell.nib(), forCellReuseIdentifier: TypeOfDeliveryTableViewCell.identifier)
        tableView.register(PaymentBriefTableViewCell.nib(), forCellReuseIdentifier: PaymentBriefTableViewCell.identifier)
    }
    
    //MARK: - Button func
    @IBAction func completeOrderBtnClicked(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("deleteCartList"), object: nil)
        saveOrderToFirebase()
    }
    
    //MARK: - Save order to firebase
    private func saveOrderToFirebase() {
        guard let order = order else {return}
        order.date = currentDate()
        order.isBell = isBell
        order.isService = isService
        if isDeliveryTypeYummie {
            order.typeOfDelivery = "Yummie getirsin"
        } else {
            order.typeOfDelivery = "Restoran getirsin"
        }
        
        saveOrderedToFirebase(ordered: order)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK: - To get the user address
    private func getUserAdress() {
        downloadUserAdressFromFirebase(with: User.currentId()) { (adress) in
            self.adressLbl.text = adress
        }
    }
    
    //MARK: - CheckBox control funcs
    private func isBellControl() {
        if isBell{
            isBell = false
        } else {
            isBell = true
        }
    }
    private func isServiceControl() {
        if isService{
            isService = false
        } else {
            isService = true
        }
    }
    private func checkBoxImageSetup(_ check: Bool) -> String{
        if check {
            return "checkmark-box-yes"
        } else {
            return "checkmark-box-no"
        }
    }
    private func deliveryControl() {
        if isDeliveryTypeYummie {
            isDeliveryTypeYummie = false
            isDeliveryTypeResto = true
        } else {
            isDeliveryTypeYummie = true
            isDeliveryTypeResto = false
        }
    }
    private func checkCircleImageSetup(_ check: Bool) -> String {
        if check {
            return "checkmark-round-yes"
        } else {
            return "checkmark-round-no"
        }
    }

    //MARK: - For take the current date
    private func currentDate() -> String{
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy HH:mm"
        return formatter.string(from: currentDateTime)
    }
    
    //MARK: - To calculate the discounted payment amount
    private func discountedPaymentAmountCalculator() -> Int{
        guard let order = order else {return 0}
        let paymentAmount = Int(order.totalPrice) ?? 0
        return paymentAmount - discount
        
    }
    
    //MARK: - Create notification observer
    private func createNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(getObject), name: NSNotification.Name.init(rawValue: "discount"), object: nil)
    }
    @objc func getObject() {
        self.discount = 10
        tableView.reloadData()
    }
}

extension PlaceAnOrderViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = ""
        if section == 0 {
            title = "Sipariş Notu"
        } else if section == 1 {
            title = "Çevreyi Koru"
        } else if section == 2 {
            title = "Teslimat Yöntemi"
        } else if section == 3 {
            title = "Ödeme Yöntemi"
        } else {
            title = "Ödeme Özeti"
        }
        return title
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else if section == 1{
            return 1
        } else if section == 2 {
            return 2
        } else if section == 3{
            return 1
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.identifier, for: indexPath) as! NoteTableViewCell
                if let order = order?.orderNote {
                    if order != "" {
                        cell.noteLbl.text = order
                    } else {
                        cell.noteLbl.text = "Sipariş notunu buraya yazabilirsiniz"
                    }
                } else {
                    cell.noteLbl.text = "Sipariş notunu buraya yazabilirsiniz"
                }
                return cell
                
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: CheckBoxTableViewCell.identifier, for: indexPath) as! CheckBoxTableViewCell
                cell.textLbl.text = "Zili Çalma"
                cell.imageCheck.image = UIImage(named: "\(checkBoxImageSetup(isBell))")
                return cell
            }
            
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CheckBoxTableViewCell.identifier, for: indexPath) as! CheckBoxTableViewCell
            cell.textLbl.text = "Bana servis(plastik,çatal,bıçak,peçete) gönderme"
            cell.imageCheck.image = UIImage(named: "\(checkBoxImageSetup(isService))")
            return cell
            
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: TypeOfDeliveryTableViewCell.identifier, for: indexPath) as! TypeOfDeliveryTableViewCell
                cell.typeLbl.text = "Yummie getirsin"
                cell.circleImage.image = UIImage(named: "\(checkCircleImageSetup(isDeliveryTypeYummie))")
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: TypeOfDeliveryTableViewCell.identifier, for: indexPath) as! TypeOfDeliveryTableViewCell
                cell.typeLbl.text = "Restoran getirsin"
                cell.circleImage.image = UIImage(named: "\(checkCircleImageSetup(isDeliveryTypeResto))")
                return cell
            }
            
            
        } else if indexPath.section == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: PaymentMethodTableViewCell.identifier, for: indexPath) as! PaymentMethodTableViewCell
            return cell
            
        } else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: CheckBoxTableViewCell.identifier, for: indexPath) as! CheckBoxTableViewCell
                cell.imageCheck.image = UIImage(named: "gift-box")
                cell.textLbl.text = "Kampanya Seçin"
                return cell
                
            } else if indexPath.row == 1{
                let cell = tableView.dequeueReusableCell(withIdentifier: PaymentBriefTableViewCell.identifier, for: indexPath) as! PaymentBriefTableViewCell
                cell.nameLbl.text = "Sepet tutarı"
                cell.priceLbl.text = "₺\(order?.totalPrice ?? "0").00"
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: PaymentBriefTableViewCell.identifier, for: indexPath) as! PaymentBriefTableViewCell
                cell.nameLbl.text = "Ödenecek tutar"
                cell.priceLbl.text = "₺\(discountedPaymentAmountCalculator()).00"
                self.priceLbl.text = "₺\(discountedPaymentAmountCalculator()).00"
                order?.price = "\(discountedPaymentAmountCalculator())"
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                alertWithTextField(titleInput: "Sipariş Notu", placeHolder: "Sipariş notunuzu yazınız") { (textFieldText) in
                    guard let order = self.order else {return}
                    order.orderNote = textFieldText
                    tableView.reloadData()
                }
            }
            if indexPath.row == 1 {
                isBellControl()
                tableView.reloadData()
            }
            
        } else if indexPath.section == 1 {
            isServiceControl()
            tableView.reloadData()
        
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                deliveryControl()
                tableView.reloadData()
            } else {
                deliveryControl()
                tableView.reloadData()
            }
        } else if indexPath.section == 4 {
            if indexPath.row == 0 {
                performSegue(withIdentifier: "toCampaign", sender: nil)
            }
        }
    }
}

