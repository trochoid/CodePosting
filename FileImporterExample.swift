

//from
//https://stackoverflow.com/questions/64974785/swiftui-loading-images-with-fileimporter





struct ContentView: View {
    
    @State private var openFile = false
    @State private var img1 = UIImage()
    @State private var img2 = UIImage()

    @State private var target: Binding<UIImage>?    // dynamic target for importer
    
    var body: some View {
        Form {
            //image 1
            Button(action: {
                    self.target = $img1
                self.openFile.toggle()
            }){
                
                Image(uiImage: self.img1)
                .renderingMode(.original)
                .resizable()
                .frame(width: 48, height: 48)
                .clipShape(Circle())
            }
            
            //image 2
            Button(action: {
                    self.target = $img2
                self.openFile.toggle()
            }){
                
                Image(uiImage: self.img2)
                .renderingMode(.original)
                .resizable()
                .frame(width: 48, height: 48)
                .clipShape(Circle())
            }
        }
        .navigationTitle("File Importer")

        //file importer
        .fileImporter(isPresented: $openFile, allowedContentTypes: [.image]) { (res) in
            do{
                let fileUrl = try res.get()
                print(fileUrl)
                
                guard fileUrl.startAccessingSecurityScopedResource() else { return }
                if let imageData = try? Data(contentsOf: fileUrl),
                let image = UIImage(data: imageData) {
                    self.target?.wrappedValue = image
                }
                fileUrl.stopAccessingSecurityScopedResource()
                
            } catch{
                
                print ("error reading")
                print (error.localizedDescription)
            }
        }
    }
}









struct ImportContentView: View {
    
    @State var openFile = false
    @State var img1 = UIImage()
    @State var img2 = UIImage()

    var body: some View {
        //Form {             // << does not work for Form !!
        VStack {   
            //image 1
            Button(action: {
                self.openFile.toggle()
            }){
                
                Image(uiImage: self.img1)
                .renderingMode(.original)
                .resizable()
                .frame(width: 48, height: 48)
                .clipShape(Circle())
                .background(LoaderView(isActive: $openFile, image: $img1))
            }
            
            //image 2
            Button(action: {
                self.openFile.toggle()
            }){
                
                Image(uiImage: self.img2)
                .renderingMode(.original)
                .resizable()
                .frame(width: 48, height: 48)
                .clipShape(Circle())
                .background(LoaderView(isActive: $openFile, image: $img2))
            }
        }
        .navigationTitle("File Importer")
    }
}

struct LoaderView: View {
    @Binding var isActive: Bool
    @Binding var image: UIImage

    var body: some View {
        Color.clear
        .fileImporter(isPresented: $isActive, allowedContentTypes: [.image]) { (res) in
            do{
                let fileUrl = try res.get()
                print(fileUrl)
                
                guard fileUrl.startAccessingSecurityScopedResource() else { return }
                if let imageData = try? Data(contentsOf: fileUrl),
                let image = UIImage(data: imageData) {
                    self.image = image
                }
                fileUrl.stopAccessingSecurityScopedResource()
            } catch{
                print ("error reading")
                print (error.localizedDescription)
            }
        }
    }
}





