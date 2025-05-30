/*
//  MainInputV2.swift
//  BoxCalc
//
//  Created by Chris Milne on 20/03/2024.
//

import SwiftUI
import PDFKit

class InputModel: ObservableObject {
    @Published var length: Int64 = 0
    @Published var width: Int64 = 0
    @Published var height: Int64 = 0
    @Published var showReturnKey: Bool = true
}

@MainActor
struct MainInputV2: View {
 //   @State private var imagebox = "Package Dimensions"
    let columns = [GridItem(.fixed(80)),
                    GridItem(.fixed(80)),
                    GridItem(.fixed(80))]
        
@Environment(\.dismiss) var dismiss
@StateObject var IM = InputModel()
    @State  var inputlength = ""
    @State  var inputwidth = ""
    @State  var inputheight = ""
    
    var body: some View {


            NavigationView {
                ZStack {
                    Color(red: 0.85, green: 0.95, blue: 0.99)
                        .edgesIgnoringSafeArea(.all)

                    
                    VStack(alignment: .center, spacing: 0) {
                        Image("80")
                            .imageScale(.small)
                            .padding()
                        
                        Text("Enter the Length, Width and Height \nof the item that you want to cover\n to the nearest millimetre \n and Press Continue.")
                            .font(.title3)
                            .bold()
                            .multilineTextAlignment(.center)
                            .frame(width: 400)
                            .padding()
                        
                        Section {
                            
                            LazyVGrid(columns: columns, alignment:
                                        HorizontalAlignment.leading, spacing: 1)  {
                                Text("").gridCellColumns(1)
                                Text("Length")
                                    .gridCellColumns(2)
                                    .font(.system(.body))
                                TextField( "length", text: $inputlength)
                                    .keyboardType(.numberPad)
                                    .gridCellColumns(3)
                                    .fixedSize(horizontal: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                    .textFieldStyle(.roundedBorder)
                                    .font(.system(.body))
                                    .onChange(of: inputlength) {
                                        let filtered = inputlength.filter { "0123456789".contains($0) }
                                        IM.length = Int64(filtered) ?? 0
                                    }
                                
                                Text("").gridCellColumns(1)
                                Text("Width")
                                    .gridCellColumns(2)
                                    .font(.system(.body))
                                TextField("width", text: $inputwidth)
                                    .textFieldStyle(.roundedBorder)
                                    .gridCellColumns(3)
                                    .keyboardType(.numberPad)
                                    .font(.system(.body))
                                    .fixedSize(horizontal: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                    .onChange(of: inputwidth) {
                                        let filtered = inputwidth.filter { "0123456789".contains($0) }
                                        IM.width = Int64(filtered) ?? 0
                                    }
                                
                                Text("").gridCellColumns(1)
                                Text("Height")
                                    .gridCellColumns(2)
                                    .font(.system(.body))
                                TextField("height", text: $inputheight).textFieldStyle(.roundedBorder)
                                    .gridCellColumns(3)
                                    .keyboardType(.numberPad)
                                    .frame(height: 6)
                                    .font(.system(.body))
                                    .fixedSize(horizontal: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                    .onChange(of: inputheight) {
                                        let filtered = inputheight.filter { "0123456789".contains($0) }
                                        IM.height = Int64(filtered) ?? 0
                                    }
                            } /// VStack
                        } /// Section
                        .padding()
                        .padding()
                        VStack(spacing: 12) {
                            NavigationLink(destination: PackageDiagram(IM:IM, showReturnKey: true)
                                .environmentObject(IM)
                                .navigationBarBackButtonHidden(true)
                                .navigationBarTitleDisplayMode(.large)
                                .foregroundColor(Color(.black))
                            ) {
        CustomButton(label:"View Packaging", width: 300,logo:
                        Image("archivebox")) }
                            
                            NavigationLink(destination: GenPdf()
                                .environmentObject(IM)
                                .navigationBarBackButtonHidden(true)
           ) {
                                CustomButton(label:"Generate/Export a PDF", width: 300, altColour: true,logo:  Image(systemName: "rectangle.and.pencil.and.ellipsis") )
           }

                            
            Button(action: { dismiss() }) {
                CustomButton(label:"Return", width: 300,logo:
                                Image("arrow.uturn.backward")) }
                
                        }
                    }
            } /// NavView
            .navigationTitle("Box Calculator")
        } // ZStack
        } /// Body
} /// Struct

//MARK: Generate and Export a PDF

struct GenPdf: View {
    @EnvironmentObject var IM: InputModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        let pdfURL = generatePDF(length: IM.length, width: IM.width, height: IM.height)
            PDFKitView(url: pdfURL)
            ShareLink("Export PDF", item: pdfURL)
        
       Button(action: { dismiss() }) {
            CustomButton(label:"Return", width: 300,logo:
                           Image("arrow.uturn.backward")) }

    }
        /// 1: Generate pdf from given view
         @MainActor
    private func generatePDF(length: Int64, width: Int64, height: Int64) -> URL {
        ///  1; Select UI View to render as pdf
                let renderer = ImageRenderer(content: PackageDiagram(IM:IM, showReturnKey: false))
                
        /// 2: Save it to our documents directory
             let url = URL.documentsDirectory.appending(path: "BoxCalc.pdf")
        /// 3: Start the rendering process. Make the pageSize - A4 if it won't fit.
            renderer.render { size, context in
            let pageSize = size.width > 0 && size.height > 0 ? size : CGSize(width: 595, height: 842)
                
        /// 4: Tell SwiftUI our PDF should be the same size as the views we're rendering
                var pdfDimension = CGRect(origin: .zero, size: pageSize)
        /// 5: Create the CGContext for our PDF pages
                 guard let pdf = CGContext(url as CFURL, mediaBox: &pdfDimension, nil) else {
                     return
                 }
        /// 6: Start at Page 1. Required else Fatal Error
                pdf.beginPDFPage(nil)
        /// 7: Render the SwiftUI view data onto the page.
              context(pdf)   /// Parts of new page displayed but PDF is displayed & printed
        /// 8: End the page and close the file
                pdf.endPDFPage()
                pdf.closePDF()
             }  /// Renderer
          return url
         } /// func
    
    func sideCalc(tag: Int) -> Int64 {
        tag % 2 == 0 ? IM.width : IM.height
    }
          }  /// Struct
            
//MARK: PDF Viewer
            struct PDFKitView: UIViewRepresentable {
                let url: URL
                func makeUIView(context: Context) -> PDFView {
                    let pdfView = PDFView()
                    pdfView.document = PDFDocument(url: self.url)
                    pdfView.autoScales = true
                    return pdfView
                } /// func

                /// Update pdf if needed
                func updateUIView(_ pdfView: PDFView, context: Context) {
                }

} /// struct
        
#Preview {
    NavigationView {
        MainInputV2()
    }
}
*/
