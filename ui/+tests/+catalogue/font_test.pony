


actor FontTest
  
	new create(renderEngine:RenderEngine) =>
        
    let scene = recover iso 
      YogaNode.view( Color(RGBA(0.98,0.98,0.98,1)) ).>alignItems(_YgalignEnum.flexstart())
                                                    .>flexDirection(_YgflexDirectionEnum.row())
                                                    .>flexWrap(_YgwrapEnum.wrap())
                                                    .>padding(_YgedgeEnum.all(), 40)
                                                    .>addChildren( [
                                                        
          // lorem ipsum in 4 quadrants
          YogaNode.view( Color( RGBA(1,0,0,0.1) ) ).> widthPercent(25).>
                                                      heightPercent(25).>
                                                      addChild(
            YogaNode.view( Label(LoremText(), "SourceSansProRegular").>size(128).>center() )
          )
          YogaNode.view( Color( RGBA(0,1,0,0.1) ) ).> widthPercent(25).>
                                                      heightPercent(25).>
                                                      addChild(
            YogaNode.view( Label(LoremText(), "SourceSansProRegular").>size(16).>right() )
          )
          YogaNode.view( Color( RGBA(0,0,1,0.1) ) ).> widthPercent(25).>
                                                      heightPercent(25).>
                                                      addChild(
            YogaNode.view( Label(LoremText(), "SourceSansProRegular").>size(32).>top() )
          )
          YogaNode.view( Color( RGBA(0,1,1,0.1) ) ).> widthPercent(25).>
                                                      heightPercent(25).>
                                                      addChild(
            YogaNode.view( Label(LoremText(), "SourceSansProRegular").>size(64).>bottom() )
          )
          
          
          
          
          YogaNode.view( Color( RGBA(0,1,1,0.1) ) ).> widthPercent(25).>
                                                      heightPercent(25).>
                                                      addChild(
            YogaNode.view( Label(LoremText(), "SourceSansProRegular").>size(64).>bottom() )
          )
          YogaNode.view( Color( RGBA(1,0,0,0.1) ) ).> widthPercent(25).>
                                                      heightPercent(25).>
                                                      addChild(
            YogaNode.view( Label(LoremText(), "SourceSansProRegular").>size(128).>center() )
          )
          YogaNode.view( Color( RGBA(0,1,0,0.1) ) ).> widthPercent(25).>
                                                      heightPercent(25).>
                                                      addChild(
            YogaNode.view( Label(LoremText(), "SourceSansProRegular").>size(16).>right() )
          )
          YogaNode.view( Color( RGBA(0,0,1,0.1) ) ).> widthPercent(25).>
                                                      heightPercent(25).>
                                                      addChild(
            YogaNode.view( Label(LoremText(), "SourceSansProRegular").>size(32).>top() )
          )
          
          
          
          
          
          YogaNode.view( Color( RGBA(0,0,1,0.1) ) ).> widthPercent(25).>
                                                      heightPercent(25).>
                                                      addChild(
            YogaNode.view( Label(LoremText(), "SourceSansProRegular").>size(32).>top() )
          )
          YogaNode.view( Color( RGBA(0,1,1,0.1) ) ).> widthPercent(25).>
                                                      heightPercent(25).>
                                                      addChild(
            YogaNode.view( Label(LoremText(), "SourceSansProRegular").>size(64).>bottom() )
          )
          YogaNode.view( Color( RGBA(1,0,0,0.1) ) ).> widthPercent(25).>
                                                      heightPercent(25).>
                                                      addChild(
            YogaNode.view( Label(LoremText(), "SourceSansProRegular").>size(128).>center() )
          )
          YogaNode.view( Color( RGBA(0,1,0,0.1) ) ).> widthPercent(25).>
                                                      heightPercent(25).>
                                                      addChild(
            YogaNode.view( Label(LoremText(), "SourceSansProRegular").>size(16).>right() )
          )
          
          
          
          
          
          YogaNode.view( Color( RGBA(0,1,0,0.1) ) ).> widthPercent(25).>
                                                      heightPercent(25).>
                                                      addChild(
            YogaNode.view( Label(LoremText(), "SourceSansProRegular").>size(16).>right() )
          )
          YogaNode.view( Color( RGBA(0,0,1,0.1) ) ).> widthPercent(25).>
                                                      heightPercent(25).>
                                                      addChild(
            YogaNode.view( Label(LoremText(), "SourceSansProRegular").>size(32).>top() )
          )
          YogaNode.view( Color( RGBA(0,1,1,0.1) ) ).> widthPercent(25).>
                                                      heightPercent(25).>
                                                      addChild(
            YogaNode.view( Label(LoremText(), "SourceSansProRegular").>size(64).>bottom() )
          )
          YogaNode.view( Color( RGBA(1,0,0,0.1) ) ).> widthPercent(25).>
                                                      heightPercent(25).>
                                                      addChild(
            YogaNode.view( Label(LoremText(), "SourceSansProRegular").>size(128).>center() )
          )
        ]
      )
    end
    
    renderEngine.addNode(consume scene)
