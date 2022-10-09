//
//  Home.swift
//  UI-693
//
//  Created by nyannyan0328 on 2022/10/09.
//

import SwiftUI

struct Home: View {
    @State var animate : Bool = false
    @State var b : CGFloat = 0
    @State var c : CGFloat = 0
    var body: some View {
        VStack(spacing: 15) {
            
            IsometricView(depath: 25) {
                
               ImageView()
                
                
            } bottom: {
                
                ImageView()
                
            } side: {
                
               
                ImageView()
            }
             .frame(width: 180,height: 330)
             .modifier(CustomProjection(b: b, c: c))
             .rotation3DEffect(.init(degrees: animate ? 180 : 0), axis: (x: 0, y: 0, z: 1))
             .scaleEffect(0.65)
             .offset(x:animate ? 12 : 0)
             
            
            VStack(alignment:.leading,spacing: 10){
                
                
                Text("Isometeric Transofroms")
                    .font(.largeTitle.bold())
                    .foregroundColor(.gray)
                
                HStack(spacing: 15) {
                    
                    Button("View1"){
                        
                        
                        withAnimation(.interactiveSpring(response: 0.5,dampingFraction: 0.8,blendDuration: 0.7).speed(1)){
                            
                            
                            animate = true
                            b = -0.3
                            c = -0.3
                        }
                        
                    }
                    .buttonStyle(.bordered)
                    .tint(.orange)
                    
                    Button("Slow"){
                        
                        withAnimation(.interactiveSpring(response: 0.5,dampingFraction: 0.8,blendDuration: 0.7).speed(0.1)){
                            
                            
                            animate = true
                            b = -0.3
                            c = -0.3
                        }
                        
                        
                    }
                    .buttonStyle(.bordered)
                    .tint(.green)
                    
                    Button("RESET"){
                        
                        withAnimation(.interactiveSpring(response: 0.5,dampingFraction: 0.8,blendDuration: 0.7)){
                            
                            
                            animate = false
                            
                            b  = 0
                            c = 0
                        }
                        
                        
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                    
                    
                    
                 
                }
                
            }

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .top)
        
    }
    @ViewBuilder
    func ImageView()->some View{
        
            Image("p1")
            .resizable()
            .aspectRatio(contentMode: .fill)
             .frame(width: 180,height: 330)
             .clipped()
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CustomProjection : GeometryEffect{
    
    var b : CGFloat
    var c : CGFloat
    
    var animatableData: AnimatablePair<CGFloat,CGFloat>{
        
        
        get{
            
            return AnimatablePair(b, c)
            
        }
        set{
            
            b = newValue.first
            c = newValue.second
        }
        
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        
        return .init(.init(1, b, c, 1 , 0, 0))
    }
}

struct IsometricView<Content : View,Bottom : View,Side : View> : View{
    
    var content : Content
    var bottom : Bottom
    var side : Side
    var depath : CGFloat
    
    init(depath :CGFloat, @ViewBuilder content: @escaping()->Content,@ViewBuilder bottom: @escaping()->Bottom,@ViewBuilder side: @escaping()->Side) {
        self.content = content()
        self.bottom = bottom()
        self.side = side()
        self.depath = depath
    }
    
    var body: some View{
        
        Color.clear
            .overlay {
                GeometryReader{
                    
                    let size = $0.size
                    
                    ZStack{
                        content
                        
                        DepathView(isBottom: true,size : size)
                        DepathView(size : size)
                    }
                    .frame(width: size.width,height: size.height)
                    
                }
            }
    }
    @ViewBuilder
    func DepathView(isBottom : Bool = false,size : CGSize)->some View{
        
        ZStack{
            
            if isBottom{
                
                bottom
                   .scaleEffect(y:depath,anchor: .bottom)
                    .frame(height:depath,alignment: .bottom)
                    .overlay(content: {
                        
                        Rectangle()
                            .fill(.blue.opacity(0.3))
                            .cornerRadius(10)
                    })
                    .clipped()
                  .projectionEffect(.init(.init(1, 0, 1, 1, 0, 0)))
                  .offset(y:depath)
                  .frame(maxHeight: .infinity,alignment: .bottom)
                
            }
            else{
                
                side
                    .scaleEffect(y:depath,anchor: .trailing)
                    .frame(width:depath,alignment: .trailing)
                    .overlay(content: {
                        
                        Rectangle()
                            .fill(.green.opacity(0.2))
                            .cornerRadius(10)
                    })
                    .clipped()
                    .projectionEffect(.init(.init(1, 1, 0, 1, 0, 0)))
                    .offset(x:depath)
                    .frame(maxWidth: .infinity,alignment: .trailing)
                
            }
        }
        
        
    }
}
