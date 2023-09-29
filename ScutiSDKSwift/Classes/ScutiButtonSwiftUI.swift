//
//  ScutiButtonSwiftUI.swift
//  ScutiSDKSwift
//
//  Created by mac on 28/09/2023.
//

import SwiftUI

public struct ScutiButtonSwiftUI: UIViewRepresentable {
    public typealias UIViewType = UIView

    public init() {
        
    }
    public func makeUIView(context: Context) -> UIView {
        return ScutiButton()
    }

    public func updateUIView(_ view: UIView, context: Context) {
    }

}
public struct ScutiButtonSwiftUI_Previews: PreviewProvider {
    public static var previews: some View {
        ScutiButtonSwiftUI()
    }
}
