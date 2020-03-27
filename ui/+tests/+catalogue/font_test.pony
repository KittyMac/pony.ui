


actor FontTest
  
	new create(renderEngine:RenderEngine) =>
    let font:Font = Font(TestFontJson())
        
    let scene = recover iso 
      YogaNode.>alignItems(_YgalignEnum.flexstart())
              .>flexDirection(_YgflexDirectionEnum.row())
              .>flexWrap(_YgwrapEnum.wrap())
              .>padding(_YgedgeEnum.all(), 40)
              .>view( Color.>color(RGBA(0.98,0.98,0.98,1)) )
              .>addChildren( [
                                                        
          // lorem ipsum in 4 quadrants
          YogaNode.>widthPercent(25)
                  .>heightPercent(25)
                  .>view( Color.>red().>alpha(0.1) )
                  .>addChild( YogaNode.>view( Label(LoremText(), font).>size(128).>center() ) )
          YogaNode.>widthPercent(25)
                  .>heightPercent(25)
                  .>view( Color.>green().>alpha(0.1) )
                  .>addChild( YogaNode.>view( Label(LoremText(), font).>size(16).>right() ) )
          YogaNode.>widthPercent(25)
                  .>heightPercent(25)
                  .>view( Color.>blue().>alpha(0.1) )
                  .>addChild( YogaNode.>view( Label(LoremText(), font).>size(32).>top() ) )
          YogaNode.>widthPercent(25)
                  .>heightPercent(25)
                  .>view( Color.>yellow().>alpha(0.1) )
                  .>addChild( YogaNode.>view( Label(LoremText(), font).>size(64).>bottom() ) )
          
          
          YogaNode.>widthPercent(25)
                  .>heightPercent(25)
                  .>view( Color.>yellow().>alpha(0.1) )
                  .>addChild( YogaNode.>view( Label(LoremText(), font).>size(64).>center() ) )
          YogaNode.>widthPercent(25)
                  .>heightPercent(25)
                  .>view( Color.>red().>alpha(0.1) )
                  .>addChild( YogaNode.>view( Label(LoremText(), font).>size(128).>right() ) )
          YogaNode.>widthPercent(25)
                  .>heightPercent(25)
                  .>view( Color.>green().>alpha(0.1) )
                  .>addChild( YogaNode.>view( Label(LoremText(), font).>size(16).>top() ) )
          YogaNode.>widthPercent(25)
                  .>heightPercent(25)
                  .>view( Color.>blue().>alpha(0.1) )
                  .>addChild( YogaNode.>view( Label(LoremText(), font).>size(32).>bottom() ) )
          
          
          YogaNode.>widthPercent(25)
                  .>heightPercent(25)
                  .>view( Color.>blue().>alpha(0.1) )
                  .>addChild( YogaNode.>view( Label(LoremText(), font).>size(32).>center() ) )
          YogaNode.>widthPercent(25)
                  .>heightPercent(25)
                  .>view( Color.>yellow().>alpha(0.1) )
                  .>addChild( YogaNode.>view( Label(LoremText(), font).>size(64).>right() ) )
          YogaNode.>widthPercent(25)
                  .>heightPercent(25)
                  .>view( Color.>red().>alpha(0.1) )
                  .>addChild( YogaNode.>view( Label(LoremText(), font).>size(128).>top() ) )
          YogaNode.>widthPercent(25)
                  .>heightPercent(25)
                  .>view( Color.>green().>alpha(0.1) )
                  .>addChild( YogaNode.>view( Label(LoremText(), font).>size(16).>bottom() ) )
          
          
          YogaNode.>widthPercent(25)
                  .>heightPercent(25)
                  .>view( Color.>green().>alpha(0.1) )
                  .>addChild( YogaNode.>view( Label(LoremText(), font).>size(16).>center() ) )
          YogaNode.>widthPercent(25)
                  .>heightPercent(25)
                  .>view( Color.>blue().>alpha(0.1) )
                  .>addChild( YogaNode.>view( Label(LoremText(), font).>size(32).>right() ) )
          YogaNode.>widthPercent(25)
                  .>heightPercent(25)
                  .>view( Color.>yellow().>alpha(0.1) )
                  .>addChild( YogaNode.>view( Label(LoremText(), font).>size(64).>top() ) )
          YogaNode.>widthPercent(25)
                  .>heightPercent(25)
                  .>view( Color.>red().>alpha(0.1) )
                  .>addChild( YogaNode.>view( Label(LoremText(), font).>size(128).>bottom() ) )
                    
        ]
      )
    end
    
    renderEngine.addNode(consume scene)
