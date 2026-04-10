// Layer for displaying components
import SwiftUI

struct ComponentLayer: View {
    
    let s: GUIState
    
    var body: some View {
        
        // Components are in sheet coordinates
        ForEach(s.placedComponents, id: \.id) { comp in
            let sPos: CGSize = s._toScreen(loc: comp.pos)
            comp.comp.symbol.path(s.screenGrid)
                .stroke(.white, lineWidth: 2)
                .rotationEffect(.degrees(Double (comp.rot)), anchor: .topLeading)
                .offset(sPos)
        }
        
        // The sprite moves in screen coordinates, not sheet
        if let sprite = s.selectedComp, s.mouseIn {
            let mPos: CGSize = s._toScreen(loc: s.mOff)
            sprite.symbol.path(s.screenGrid)
                .stroke(.blue, lineWidth: 2)
                .rotationEffect(.degrees(Double (s.rot)), anchor: .topLeading)
                .offset(mPos)
        }
    }
}
