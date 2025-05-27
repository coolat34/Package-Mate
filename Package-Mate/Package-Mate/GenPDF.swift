//
//  GenPDF.swift
//  Package-Mate
//
//  Created by Chris Milne on 27/05/2025.
//

import SwiftUI
import PDFKit

struct GenPDF: View {
    @EnvironmentObject var IM: InputModel
    @Environment(\.dismiss) var dismiss
    @State private var pdfURL: URL? = nil
    @State private var hasShared = false
    @State private var pdfWrapper: IdentifiableURL? = nil
    
    var body: some View {

       Color.clear // invisible view

          .onAppear {
                if !hasShared {
                    let url = generatePDF(length: IM.length, width: IM.width, height: IM.height)
                    pdfWrapper = IdentifiableURL(url: url)
                    hasShared = true
                }
            }

            .sheet(item: $pdfWrapper) { wrapper in
                ShareSheet(activityItems: [wrapper.url]) {
                    dismiss()
                }
            }
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
                var pdfRect = CGRect(origin: .zero, size: pageSize)
        /// 5: Create the CGContext for our PDF pages
                guard let pdf = CGContext(url as CFURL, mediaBox: &pdfRect, nil) else { return }
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
} /// struct
            
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
struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    var onComplete: (() -> Void)? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        controller.completionWithItemsHandler = { _, _, _, _ in
            onComplete?()
        }
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

struct IdentifiableURL: Identifiable {
    let id = UUID()
    let url: URL
}


#Preview {
    GenPDF()
}

