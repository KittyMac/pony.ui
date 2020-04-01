


actor FontTest is Controllerable
  
	fun ref mainNode():YogaNode iso^ =>
    let font:Font = Font(TestFontJson())    
    recover iso 
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
                  .>addChild( YogaNode.>view( Label(LoremText(), font).>size(16) ) )
          YogaNode.>widthPercent(25)
                  .>heightPercent(25)
                  .>view( Color.>green().>alpha(0.1) )
                  .>addChild( YogaNode.>view( Label(LoremText(), font).>size(16) ) )
          YogaNode.>widthPercent(25)
                  .>heightPercent(25)
                  .>view( Color.>blue().>alpha(0.1) )
                  .>addChild( YogaNode.>view( Label(LoremText(), font).>size(16) ) )
          YogaNode.>widthPercent(25)
                  .>heightPercent(25)
                  .>view( Color.>yellow().>alpha(0.1) )
                  .>addChild( YogaNode.>view( Label(LoremText(), font).>size(16) ) )
          
          
          YogaNode.>widthPercent(25)
                  .>heightPercent(25)
                  .>view( Color.>yellow().>alpha(0.1) )
                  .>addChild( YogaNode.>view( Label(LoremText(), font).>size(16) ) )
          YogaNode.>widthPercent(25)
                  .>heightPercent(25)
                  .>view( Color.>red().>alpha(0.1) )
                  .>addChild( YogaNode.>view( Label(LoremText(), font).>size(16) ) )
          YogaNode.>widthPercent(25)
                  .>heightPercent(25)
                  .>view( Color.>green().>alpha(0.1) )
                  .>addChild( YogaNode.>view( Label(LoremText(), font).>size(16) ) )
          YogaNode.>widthPercent(25)
                  .>heightPercent(25)
                  .>view( Color.>blue().>alpha(0.1) )
                  .>addChild( YogaNode.>view( Label(LoremText(), font).>size(16) ) )
          
          
          YogaNode.>widthPercent(25)
                  .>heightPercent(25)
                  .>view( Color.>blue().>alpha(0.1) )
                  .>addChild( YogaNode.>view( Label(LoremText(), font).>size(16) ) )
          YogaNode.>widthPercent(25)
                  .>heightPercent(25)
                  .>view( Color.>yellow().>alpha(0.1) )
                  .>addChild( YogaNode.>view( Label(LoremText(), font).>size(16) ) )
          YogaNode.>widthPercent(25)
                  .>heightPercent(25)
                  .>view( Color.>red().>alpha(0.1) )
                  .>addChild( YogaNode.>view( Label(LoremText(), font).>size(16) ) )
          YogaNode.>widthPercent(25)
                  .>heightPercent(25)
                  .>view( Color.>green().>alpha(0.1) )
                  .>addChild( YogaNode.>view( Label(LoremText(), font).>size(16) ) )
          
          
          YogaNode.>widthPercent(25)
                  .>heightPercent(25)
                  .>view( Color.>green().>alpha(0.1) )
                  .>addChild( YogaNode.>view( Label(LoremText(), font).>size(16) ) )
          YogaNode.>widthPercent(25)
                  .>heightPercent(25)
                  .>view( Color.>blue().>alpha(0.1) )
                  .>addChild( YogaNode.>view( Label(LoremText(), font).>size(16) ) )
          YogaNode.>widthPercent(25)
                  .>heightPercent(25)
                  .>view( Color.>yellow().>alpha(0.1) )
                  .>addChild( YogaNode.>view( Label(LoremText(), font).>size(16) ) )
          YogaNode.>widthPercent(25)
                  .>heightPercent(25)
                  .>view( Color.>red().>alpha(0.1) )
                  .>addChild( YogaNode.>view( Label(LoremText(), font).>size(16) ) )
                    
        ]
      )
    end
