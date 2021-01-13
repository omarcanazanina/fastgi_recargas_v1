//
//  PayView.swift
//  fastgi
//
//  Created by Hegaro on 26/11/2020.
//

import SwiftUI
import SDWebImageSwiftUI

struct PayView: View {
    @State private var monto: String = ""
    var user: String
    var resultado: String
    //datos user
    @ObservedObject var userDataVM = UserDataViewModel()
    //test
    @ObservedObject var qrPayment = QrPayment()
    @ObservedObject var qrPaymentVM = QrPaymentViewModel()
    //
    
    /*init() {
        recuperarUser()
    }*/
    
    //alert
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var alertState: Bool = false
    
    @State private var action:Int? = 0
    var imageProfile:some View {
        HStack(alignment: .center){
                WebImage(url: URL(string: "https://i.postimg.cc/8kJ4bSVQ/image.jpg" ))
                    .onSuccess { image, data, cacheType in
                    }
                    .placeholder(Image( "user-default"))
                    .resizable()
                    .foregroundColor(.white)
                    .frame(width: 100.0, height: 100.0)
                    .clipShape(Circle())
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 2, y: 3)
                    .overlay(
                        Circle()
                            .stroke(Color("card"), lineWidth: 2))
            
        }
        
    }
    
    
    var buttonSuccess:some View {
        VStack(){
            Button(action: {
                self.qrPaymentVM.pagoQr(id_cobrador: self.user, monto: self.monto)
                //self.qrPayment.pagoQr(id_cobrador: self.user, monto: self.monto)
                self.action = 1
            }){
                Text("Pagar")
                    .foregroundColor(Color.white)
                    .frame(maxWidth:.infinity)
                    .padding(8)
                    .background(Color("primary"))
                    .clipShape(Capsule())
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 2, y: 3)
                
            }
           /* NavigationLink(destination: TestpayDetail(monto: self.monto, nombreCobrador: self.user, id_usuario: self.qrPaymentVM.qrPayData.id_usuario), tag: 1, selection: self.$action) {
                EmptyView()
        }*/
            NavigationLink(destination: TestpayDetail(monto: self.monto, nombreCobrador: "\(self.userDataVM.userResponsePago.nombres) \(self.userDataVM.userResponsePago.apellidos)", id_usuario: "\(self.userDataVM.userResponsePago.nombres) \(self.userDataVM.userResponsePago.apellidos)", fecha: "",fechaFormat: "", horaFormat: ""), tag: 1, selection: self.$action) {
                 EmptyView()
         }
        }
        .padding()
    }
    
    
    var body: some View {
        //NavigationView{
            VStack{
                Text("Pagar transporte")
                    .font(.title)
                self.imageProfile
                Text("\(self.user)")
                Text("\(self.userDataVM.userResponsePago.nombres) \(self.userDataVM.userResponsePago.apellidos)")
            
                VStack(alignment: .leading, spacing: 8){
                    Text("MONTO BS.")
                        .textStyle(TitleStyle())
                    TextField("Ingrese monto", text: $monto)
                        .textFieldStyle(Input())
                        .keyboardType(.numberPad)
                        .introspectTextField { (textField) in
                            let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: textField.frame.size.width, height: 44))
                            let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
                            let doneButton = UIBarButtonItem(title: "Cerrar", style: .done, target: self, action: #selector(textField.doneButtonTapped(button:)))
                         doneButton.tintColor = .darkGray
                            toolBar.items = [flexButton, doneButton]
                            toolBar.setItems([flexButton, doneButton], animated: true)
                            textField.inputAccessoryView = toolBar
                            textField.becomeFirstResponder()
                         }
                }
                /*Button(action:{
                    self.qrPaymentVM.userVerifi(id_cobrador: "5fbe3893dee3371becd7bbf1")
                }){
                    Text("sadad")
                }*/
                self.buttonSuccess
                HStack{
                    Button(action: {
                        if self.user != "" {
                            self.qrPaymentVM.userAfiliacion(id_afiliado: self.user)
                            self.userDataVM.DatosUserPago(id_usuario: self.user)
                        }else if self.user == "" {
                            print("no hay user afiliado")
                        }
                        if  self.qrPaymentVM.noafiliado == nil {
                            self.alertState = true
                        }
                    }){
                        Text("Aceptar")
                    }
                    if self.qrPaymentVM.afiliado == true {
                        Text("user existente")
                    }
                    if  self.qrPaymentVM.noafiliado == nil {
                        
                        Text("User no esta afiliado")
                            .foregroundColor(.red)
                        //self.alertState = true
                    }
                }
            }
            .padding(.horizontal)
    //}
            .onAppear{
                //print("se ejecuto el onAppear del pay")
                //self.userDataVM.DatosUserPago(id_usuario: self.user)
                if self.user != "" {
                    self.qrPaymentVM.userAfiliacion(id_afiliado: self.user)
                    self.userDataVM.DatosUserPago(id_usuario: self.user)
                }else if self.user == "" {
                    print("no hay user afiliado")
                }
            }.alert(isPresented:  self.$alertState){
                self.alerts
            }
    //.navigationBarTitle("Pagar transporte", displayMode: .inline)
}
    //alerta
    var alerts:Alert{
        Alert(title: Text("Fastgi"), message: Text("Usuario no afiliado."), dismissButton: .default(Text("Aceptar"), action: {
            self.presentationMode.wrappedValue.dismiss()
        }))
    }
    
}

struct PayView_Previews: PreviewProvider {
    static var previews: some View {
        PayView(user: "", resultado: "")
    }
}

extension PayView{
    func recuperarUser() -> String {
        //self.qrPaymentVM.userVerifi(id_cobrador: self.user)
        return "SE EJECUTO EXITOSAMENTE"
    }
}
