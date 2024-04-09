import SwiftUI
import PhotosUI

struct HomeView: View {
    @EnvironmentObject var animeInfo: AnimeInfo
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State var showCamera = false;
    @State var image: UIImage?
    @State var showPicker🎀 = false;
    @State var showEpisodeView🎀 = false;
    var body: some View {
        NavigationStack{
            VStack{
                Spacer()
                
                Menu {
                    Button { self.showCamera.toggle()
                    } label: {
                        Text("Take a photo")
                    }
                    Button {
                        showPicker🎀 = true
                    } label: {
                        Text("Upload a photo")
                    }
                    
                } label: {
                    VStack{
                        ZStack{
                            Rectangle().frame(width: 280, height: 160).clipShape(RoundedRectangle(cornerRadius: 25))
                                .foregroundStyle(Color(UIColor.white)).overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(.purple, style: StrokeStyle(lineWidth: 1, dash: [20])).frame(width: 300, height: 180)
                                )
                            
                            Image(systemName: "photo.badge.plus").resizable().aspectRatio(contentMode: .fit).frame(width:80).foregroundStyle(.purple)
                            
                        }.padding().contextMenu(ContextMenu(menuItems: {
                            Text("Take a photo")
                            Text("Upload from gallery")
                        }))
                        Text("Take or upload photo").font(.system(size: 15, weight: .semibold)).foregroundStyle(.gray)
                    }.imagePicker(isPresented: $showCamera, capturedImage: $image)
                    
                        .photosPicker(isPresented: $showPicker🎀, selection: $selectedItem)
                        .onChange(of: image) { oldvalue, newItem in
                            Task {
                                if let data = newItem {
                                    image = data
                                    animeInfo.uploadImageToAPI(image: image)
                                    showEpisodeView🎀 = true
                                    
                                    
                                } else {
                                    print("Failed to load the image")
                                }
                            }
                        }
                    
                        .onChange(of: selectedItem) { oldvalue, newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    image = UIImage(data: data)
                                    animeInfo.uploadImageToAPI(image: image)
                                    showEpisodeView🎀 = true
                                    
                                    
                                } else {
                                    print("Failed to load the image")
                                }
                            }
                        }            }
                
                Spacer()
                Text("App made by Kameko").bold().foregroundStyle(.gray).padding()
            }.navigationDestination(isPresented: $showEpisodeView🎀, destination: {EpisodeView().onDisappear{
                selectedItem = nil
                selectedImage = nil
                animeInfo.AnimeStruct = nil
                animeInfo.animeInfo = nil
            }}).onAppear {
                // Reset the selected item and image when the view appears
                selectedItem = nil
                selectedImage = nil
            }
            
            
        }
    }

}

#Preview {
    HomeView().environmentObject(AnimeInfo())
}
