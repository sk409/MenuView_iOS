import UIKit

class MenuSectionItemsStackView: UIStackView {
    
    enum State {
        case opening
        case opened
        case closing
        case closed
    }
    
    var state = State.closed
    
}
