


actor ImageTest
  
	new create(renderEngine:RenderEngine) =>
        
    let scene = recover iso 
      YogaNode.view( Color(RGBA(0.98,0.98,0.98,1)) ).>alignItems(_YgalignEnum.flexstart())
                                                    .>flexDirection(_YgflexDirectionEnum.row())
                                                    .>flexWrap(_YgwrapEnum.wrap())
                                                    .>padding(_YgedgeEnum.all(), 40)
                                                    .>addChildren( [
                                                        
          YogaNode.view( Image( "unpressed_button" ).>color(RGBA(1,1,1,1)).>sizeToFit() ).>width(256).>height(256)
          YogaNode.view( Image( "unpressed_button" ).>color(RGBA(1,0,0,1)).>sizeToFit() ).>width(256).>height(256)
          YogaNode.view( Image( "unpressed_button" ).>color(RGBA(0,1,0,1)).>sizeToFit() ).>width(256).>height(256)
          YogaNode.view( Image( "unpressed_button" ).>color(RGBA(0,0,1,1)).>sizeToFit() ).>width(256).>height(256)
          YogaNode.view( Image( "unpressed_button" ).>color(RGBA(1,1,1,0.25)).>sizeToFit() ).>width(256).>height(256)
          
          
          YogaNode.view( Image( "landscape_desert" ).>fill() ).>width(256).>height(512)
          
          YogaNode.view( Color.empty().>gray() ).>  width(256).>
                                                    height(512).>
                                                    addChild(
              YogaNode.view( Image( "landscape_desert" ).>aspectFit() )
          )
          
          YogaNode.view( Image( "landscape_desert" ).>aspectFill() ).>width(256).>height(512)
          
          YogaNode.view( Image( "landscape_desert" ).>fill() ).>width(512).>height(256)
          
          YogaNode.view( Color.empty().>gray() ).>  width(512).>
                                                    height(256).>
                                                    addChild(
              YogaNode.view( Image( "landscape_desert" ).>aspectFit() )
          )
          
          YogaNode.view( Image( "landscape_desert" ).>aspectFill() ).>width(512).>height(256)
          
          YogaNode.view( Image( "landscape_desert" ).>sizeToFit() )
          
        ]
      )
    end
    
    renderEngine.addNode(consume scene)
