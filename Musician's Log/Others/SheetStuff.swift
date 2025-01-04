//
//  SheetStuff.swift
//  Musician's Log
//
//  Created by Bryce Sechrist on 1/1/25.
//

import SwiftUI


extension View {
    @ViewBuilder
    
    func bottomMaskForSheet(_ height: CGFloat = 49) -> some View {
        self
            .background(SheetRootViewFinder(height: height))
    }
}

fileprivate struct SheetRootViewFinder: UIViewRepresentable {
    var height: CGFloat
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    func makeUIView(context: Context) ->  UIView {
        return .init()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            guard !context.coordinator.isMasked else { return }
            if let rootView = uiView.viewBeforeWindow {
                let safeArea = rootView.safeAreaInsets
                rootView.frame = .init(origin: .zero, size: .init(width: rootView.frame.width, height: rootView.frame.height - (height + safeArea.bottom)))
                rootView.clipsToBounds = true
                for view in rootView.subviews {
                    
                    view.layer.shadowColor = UIColor.clear.cgColor
                    
                    if view.layer.animationKeys() != nil {
                        if let cornerRadiusView = view.allSubviews.first(where: { $0.layer.animationKeys()?.contains("cornerRadius") ?? false }) {
                            cornerRadiusView.layer.maskedCorners = []
                        }
                    }
                }
//                context.coordinator.isMasked = true
            }
        }
    }
    class Coordiantor: NSObject {
        var isMasked: Bool = false
    }
    
}

fileprivate extension UIView{
    var viewBeforeWindow: UIView? {
        if let superview, superview is UIWindow {
            return self
        }
        
        return superview?.viewBeforeWindow
    }
    
    var allSubviews: [UIView] {
        return subviews.flatMap { [$0] + $0.allSubviews }
    }
}


//MARK: Presentation Detent Stuff


extension PresentationDetent {
    static func newLarge(height: CGFloat) -> Self {
        BarDetent.setHeight(height)
        return Self.custom(BarDetent.self)
    }
    
    func isLarge() -> Bool {
        return self == .custom(BarDetent.self) // Adjust this check accordingly
    }
}

private struct BarDetent: CustomPresentationDetent {
    private static var customHeight: CGFloat = 300 // Default value, adjust as needed
    
    static func setHeight(_ height: CGFloat) {
        customHeight = height
    }
    
    static func height(in context: Context) -> CGFloat? {
        max(44, customHeight)
    }
}


#Preview() {
    ContentView(tabSelected: 0)
}


