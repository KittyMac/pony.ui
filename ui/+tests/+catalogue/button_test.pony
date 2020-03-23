


actor ButtonTest
  
  let font:Font = Font(TestFontJson())
  
	new create(renderEngine:RenderEngine) =>
    let scene = recover iso 
      YogaNode.view( Color(RGBA(0.98,0.98,0.98,1)) ).>alignItems(_YgalignEnum.flexstart())
                                                    .>flexDirection(_YgflexDirectionEnum.row())
                                                    .>flexWrap(_YgwrapEnum.wrap())
                                                    .>padding(_YgedgeEnum.all(), 40)
                                                    .>addChildren( [
                                                      
          // the big, red button
          YogaNode.view( Button.empty().>onClick({ 
            () =>
              @printf("clicked 1!\n".cstring())
            }) ).>width(100)
                .>height(100)
                .>addChildren([
              YogaNode.view( Color(RGBA.red()) )
              YogaNode.view( Color(RGBA.blue()) )
          ])
          
          // clear tap area
          YogaNode.view( ClearButton.empty().>onClick({ 
            () =>
              @printf("clicked 2!\n".cstring())
            }) ).>width(200)
                .>height(60)
                .>addChildren([
              YogaNode.view( Color(RGBA.gray()) ) .>addChild(
                YogaNode.view( Label("Clear Tap Area", font).>center().>blue() )
              )
          ])
          
          // button with images for up and down states
          YogaNode.view( ImageButton( "unpressed_button", "pressed_button" ).>sizeToFit()
                                                                            .>onClick({ 
            () =>
              @printf("clicked 3!\n".cstring())
            }) )
          
          
          // button with a stretchable image
          YogaNode.view( ImageButton( "stretch_button", "stretch_button" ).>stretch(32,32,32,32)
                                                                          .>pressedColor(RGBA(0.8, 0.8, 1.0, 1.0))
                                                                          .>onClick({ 
            () =>
              @printf("clicked 4!\n".cstring())
            }) ).>width(300)
                .>height(80) .>addChild(
              YogaNode.view( Label("Click me!", font, 28).>center() )
            )
          
        ]
      )
    end
  
    renderEngine.addNode(consume scene)
    
