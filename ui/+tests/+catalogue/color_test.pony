
actor ColorTest
  
	new create(renderEngine:RenderEngine) =>
        
  let scene = recover iso 
    YogaNode.view( Color(RGBA(0.98,0.98,0.98,1)) ).>alignItems(_YgalignEnum.flexstart())
                                                  .>flexDirection(_YgflexDirectionEnum.row())
                                                  .>flexWrap(_YgwrapEnum.wrap())
                                                  .>padding(_YgedgeEnum.all(), 40)
                                                  .>addChildren( [
                                                      
          // lorem ipsum in 4 quadrants
          YogaNode.view( Color( RGBA.red() ) ).> widthPercent(50).>heightPercent(50)
          YogaNode.view( Color( RGBA.green() ) ).> widthPercent(50).>heightPercent(50)
          YogaNode.view( Color( RGBA.blue() ) ).> widthPercent(50).>heightPercent(50)
          YogaNode.view( Color( RGBA.yellow() ) ).> widthPercent(50).>heightPercent(50)
        ])
    end
    
    renderEngine.addNode(consume scene)
