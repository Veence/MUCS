// Layer for displaying components
import SwiftUI

struct ComponentLayer: View {
    
    let s: GUIState
    
    var body: some View {
        
        ForEach(s.placedComponents, id: \.id) { comp in
            comp.comp.symbol.path(s.gridSpacing).stroke(.white, lineWidth: 2)
                .offset(comp.pos)
        }
        
        if let sprite = s.selectedComp, s.mouseIn {
            sprite.symbol.path(s.gridSpacing).stroke(.blue, lineWidth: 2)
                .offset(s.mOff)
        }
    }
}
