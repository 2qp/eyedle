import SwiftUI

extension View {
    public func actionable(action: @escaping () -> Void) -> some View {
        var view = self
        if var actionableView = view as? ActionableProtocol {
            actionableView.action = action
            view = actionableView as! Self
        }
        return view
    }
}
