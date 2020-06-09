import UIKit

class MenuSectionItemsContainerView: UIView {
    
    enum State {
        case opening
        case opened
        case closing
        case closed
    }
    
    var state = State.closed
    
}
