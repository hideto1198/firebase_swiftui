import SwiftUI

struct firebase_test_view: View {
    @ObservedObject var Firebase_Test = firebase_test()
    var body: some View {
        ZStack{
            VStack{
                
                Button(
                    action:{
                        self.Firebase_Test.http_connect()
                        self.Firebase_Test.db_set()
                        self.Firebase_Test.db_field_delete()
                        self.Firebase_Test.db_document_delete()
                        self.Firebase_Test.db_document_get()
                        self.Firebase_Test.db_collection_get()
                    }
                ){
                    Text("Click me")
                }
            }
            .alert(isPresented:self.$Firebase_Test.isAlert, content:{
                Alert(
                    title: Text("\(self.Firebase_Test.title)"),
                    message: Text("\(self.Firebase_Test.message)"),
                    dismissButton: .default(
                        Text("OK")
                    )
                )
            })
        }
        if self.Firebase_Test.isLoading{
            loading_view()
        }
    }
}

 
struct activity_indicator_view: UIViewRepresentable {
    public var style = UIActivityIndicatorView.Style.medium
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        uiView.startAnimating()
    }
}
    
struct loading_view: View {
    var body: some View {
        ZStack{
            Color.gray
                .opacity(0.5)
                .edgesIgnoringSafeArea(.all)
            VStack{
                Spacer()
                ZStack{
                    Color.white
                        .cornerRadius(15)
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 0.5)
                    VStack{
                        activity_indicator_view()
                        Text("?????????...")
                    }
                }.frame(width: width*0.4, height: height*0.15)
                Spacer()
            }
        }
    }
}


struct firebase_test_view_Previews: PreviewProvider {
    static var previews: some View {
        firebase_test_view()
    }
}
