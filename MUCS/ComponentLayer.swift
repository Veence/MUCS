// Layer for displaying components
import SwiftUI

struct ComponentLayer: View {
    
    let s: GUIState
    
    var body: some View {
        
        // Components are in sheet coordinates
        ForEach(s.placedComponents, id: \.id) { comp in
            comp.comp.symbol.path(s.screenGrid).stroke(.white, lineWidth: 2)
                .offset(s._toScreen(loc: comp.pos))
        }
        
        // The sprite moves in screen coordinates, not sheet
        if let sprite = s.selectedComp, s.mouseIn {
            sprite.symbol.path(s.screenGrid).stroke(.blue, lineWidth: 2)
                .offset(s._toScreen(loc: s.mOff))
        }
    }
}
