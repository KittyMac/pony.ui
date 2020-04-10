use "yoga"

actor ClipTest is Controllerable
  
	fun ref mainNode():YogaNode iso^ =>    
    recover iso 
      YogaNode.>alignItems(YGAlign.flexstart)
              .>flexDirection(YGFlexDirection.row)
              .>padding(YGEdge.all, 40)
              .>view( Color.>color(RGBA(0.98,0.98,0.98,1)) )
              .>addChildren( [
                                                
            YogaNode.>width(100)
                    .>height(100)
                    .>view( Color.>red().>alpha(0.25) )
                    .>addChild(
                      
                      YogaNode.>width(100)
                              .>height(100)
                              .>originPercent(50, 50)
                              .>view( Color.>green().>alpha(0.25) )
                      
              )
              
            YogaNode.>width(100)
                    .>height(100)
                    .>left(100)
                    .>clips(true)
                    .>view( Color.>red().>alpha(0.25) )
                    .>addChild(
                    
                      YogaNode.>width(100)
                              .>height(100)
                              .>clips(true)
                              .>originPercent(50, 50)
                              .>view( Color.>green().>alpha(0.25) )
                              .>addChild(
                                
                                YogaNode.>width(100)
                                        .>height(100)
                                        .>originPercent(-75, -75)
                                        .>view( Color.>blue().>alpha(0.25) )
                                
                              )
                    
              )
          ])
      end
