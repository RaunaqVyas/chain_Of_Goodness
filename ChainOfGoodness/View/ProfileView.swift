import SwiftUI

struct ProfileView: View {
    
    @State var offset: CGFloat = 0
    
    // For Dark Mode Adoption..
    @Environment(\.colorScheme) var colorScheme
    
    @State var currentTab = "Chains"
    
    // For Smooth Slide Animation...
    @Namespace var animation
    
    @State var tabBarOffset: CGFloat = 0
    
    @State var titleOffset: CGFloat = 0
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false, content: {
            
            VStack(spacing: 15){
                
                // Header View...
                GeometryReader{proxy -> AnyView in
                    
                    // Sticky Header...
                    let minY = proxy.frame(in: .global).minY
                    
                    DispatchQueue.main.async {
                        
                        self.offset = minY
                    }
                    
                    return AnyView(
                    
                        ZStack{
                            
                            // Banner...
                            Image("Blob 1")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: getRect().width, height: minY > 0 ? 180 + minY : 180, alignment: .center)
                                .cornerRadius(0)
                            
                            BlurView()
                                .opacity(blurViewOpacity())
                            
                            // Title View...
                            VStack(spacing: 5){
                                
                                Text("raunaqVyas")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Text("0 Chains")
                                    .foregroundColor(.white)
                            }
                            // to slide from bottom added extra 60..
                            .offset(y: 120)
                            .offset(y: titleOffset > 100 ? 0 : -getTitleTextOffset())
                            .opacity(titleOffset < 100 ? 1 : 0)
                        }
                        .clipped()
                        // Stretchy Header...
                        .frame(height: minY > 0 ? 180 + minY : nil)
                        .offset(y: minY > 0 ? -minY : -minY < 80 ? 0 : -minY - 80)
                    )
                }
                .frame(height: 180)
                .zIndex(1)
                
                // Profile Image...
                
                VStack{
                    
                    VStack{
                        
                        Image("Avatar Default")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                            .padding(20)
                            .background(colorScheme == .dark ? Color.black : Color.white)
                            .clipShape(Circle())
                            .offset(y: offset < 0 ? getOffset() - 20 : -20)
                            .scaleEffect(getScale())
                        
                        Spacer()

                    }
                    .padding(.top,-25)
                    .padding(.bottom,10)
                    
                    // Profile Data...
                    
                    VStack(alignment: .center, spacing: 8, content: {
                        
                        Text("raunaqVyas")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        
                        
                    
                        HStack(spacing: 5){
                            
                            Text("0")
                                .foregroundColor(.primary)
                                .fontWeight(.semibold)
                            
                            Text("Followers")
                                .foregroundColor(.gray)
                            
                            Text("0")
                                .foregroundColor(.primary)
                                .fontWeight(.semibold)
                                .padding(.leading,10)
                            
                            Text("Following")
                                .foregroundColor(.gray)
                        }
                        .padding(.top,8)
                        .padding(.bottom,10)
                        HStack{
                        Button(action: {}, label: {
                            Text("Edit Profile")
                                .foregroundColor(.blue)
                                .padding(.vertical,10)
                                .padding(.horizontal)
                                .background(
                                    
                                    Capsule()
                                        .stroke(Color.blue,lineWidth: 1.5)
                                )
                        })
                        }
                    })
                    
                    
                    
                    .overlay(
                    
                        GeometryReader{proxy -> Color in
                            
                            let minY = proxy.frame(in: .global).minY
                            
                            DispatchQueue.main.async {
                                self.titleOffset = minY
                            }
                            return Color.clear
                        }
                        .frame(width: 0, height: 0)
                        
                        ,alignment: .top
                    )
                    
                    // Custom Segmented Menu...
                    
                    VStack(spacing: 0){
                        
                        ScrollView(.horizontal, showsIndicators: false, content: {
                            
                            HStack(spacing: 0){
                                
                                TabButton(title: "Chains", currentTab: $currentTab, animation: animation)
                                
                                TabButton(title: "Likes", currentTab: $currentTab, animation: animation)
                                
                                TabButton(title: "Comments", currentTab: $currentTab, animation: animation)
                                
                                TabButton(title: "Followers", currentTab: $currentTab, animation: animation)
                                
                                
                                

                            }
                        })
                        
                        Divider()
                    }
                    .padding(.top,30)
                    .background(colorScheme == .dark ? Color.black : Color.white)
                    .offset(y: tabBarOffset < 90 ? -tabBarOffset + 90 : 0)
                    .overlay(
                    
                        GeometryReader{reader -> Color in
                            
                            let minY = reader.frame(in: .global).minY
                            
                            DispatchQueue.main.async {
                                self.tabBarOffset = minY
                            }
                            
                            return Color.clear
                        }
                        .frame(width: 0, height: 0)
                        
                        ,alignment: .top
                    )
                    .zIndex(1)
                    .padding(.top)
                    .zIndex(0)
                }
                .padding(.horizontal)
                // Moving the view back if it goes > 80...
                .zIndex(-offset > 80 ? 0 : 1)
            }
        })
        .ignoresSafeArea(.all, edges: .top)
    }
    
    func getTitleTextOffset()->CGFloat{
        
        // some amount of progress for slide effect..
        let progress = 20 / titleOffset
        
        let offset = 60 * (progress > 0 && progress <= 1 ? progress : 1)
        
        return offset
    }
    
    // Profile Shrinking Effect...
    func getOffset()->CGFloat{
        
        let progress = (-offset / 80) * 20
        
        return progress <= 20 ? progress : 20
    }
    
    func getScale()->CGFloat{
        
        let progress = -offset / 80
        
        let scale = 1.8 - (progress < 1.0 ? progress : 1)
        
        // since were scaling the view to 0.8...
        // 1.8 - 1 = 0.8....
        
        return scale < 1 ? scale : 1
    }
    
    func blurViewOpacity()->Double{
        
        let progress = -(offset + 80) / 150
        
        return Double(-offset > 80 ? progress : 0)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .preferredColorScheme(.dark)
    }
}


// Extending View to get Screen Size...
extension View{
    
    func getRect()->CGRect{
        
        return UIScreen.main.bounds
    }
}

// Tab Button...
struct TabButton: View {
    
    var title: String
    @Binding var currentTab: String
    var animation: Namespace.ID
    
    var body: some View{
        
        Button(action: {
            withAnimation{
                currentTab = title
            }
        }, label: {
            
            LazyVStack(spacing: 12){
                
                Text(title)
                    .fontWeight(.semibold)
                    .foregroundColor(currentTab == title ? .blue : .gray)
                    .padding(.horizontal)
                
                if currentTab == title{
                    
                    Capsule()
                        .fill(Color.blue)
                        .frame(height: 1.2)
                        .matchedGeometryEffect(id: "TAB", in: animation)
                }
                else{
                    Capsule()
                        .fill(Color.clear)
                        .frame(height: 1.2)
                }
            }
        })
    }
}

