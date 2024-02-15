import SwiftUI
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    @Binding var capturedImage: UIImage?

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.capturedImage = image

                // Upload the image to the API
                uploadImageToAPI(image: image)
            }

            parent.isPresented = false
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresented = false
        }

        func uploadImageToAPI(image: UIImage) {
            guard let imageData = image.jpegData(compressionQuality: 0.9) else {
                print("Failed to convert image to data.")
                return
            }

            let url = URL(string: "https://api.trace.moe/search")!

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
            request.httpBody = imageData

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error uploading image: \(error)")
                    return
                }

                if let data = data {
                    // Process the API response (JSON parsing, etc.)
                    do {
                        let result = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        print("API Response:", result ?? "No data")
                    } catch {
                        print("Error parsing API response:", error)
                    }
                }
            }.resume()
        }
    }


    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
}

extension View {
    func imagePicker(isPresented: Binding<Bool>, capturedImage: Binding<UIImage?>) -> some View {
        sheet(isPresented: isPresented) {
            ZStack{
                ImagePicker(isPresented: isPresented, capturedImage: capturedImage).background()
            }
        }
    }
}
