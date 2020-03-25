use "utility"


actor UICatalog
  // Our UI is a side-bar of menu items and a right panel which switches between the various tests
  
  let font:Font = Font(TestFontJson())
  
	new create(renderEngine:RenderEngine) =>
    let scene = recover iso
      YogaNode.>alignItems(_YgalignEnum.flexstart())
              .>flexDirection(_YgflexDirectionEnum.row())
              .>flexWrap(_YgwrapEnum.wrap())
              .>view( Color(RGBA(0.98,0.98,0.98,1)) )
              .>addChildren( [
          
          // Sidebar
          YogaNode.>width(210)
                  .>heightPercent(100)
                  .>view( Image("sidebar").>stretch(10,10,10,10) )
                  .>addChildren([
              menuButton("Colors", font)
              menuButton("Buttons", font)
              menuButton("Images", font)
              menuButton("Fonts", font)
          ])
          
          // Panel
          YogaNode.>name("Panel")
                  .>view(Clear.empty())
                  .>fill()
          
        ]
      )
    end
    renderEngine.addNode(consume scene)
  
  fun tag menuButton(title:String, font':Font):YogaNode =>
    // TODO: how to easily respond to events and cause actions to take place
    // against other nodes.
    // Ideas:
    // 1. Be able to attach a string identifier to any node, be able to quickly
    //    look that node up based upon its string identifier
    
    YogaNode.>width(204)
            .>height(46)
            .>padding(_YgedgeEnum.all(), 6)
            .>padding(_YgedgeEnum.left(), 12)
            .>view( ImageButton( "white", "white").>pressedColor(RGBA.u32( 0x98cbf3ff ))
                                                  .>color(RGBA.u32( 0xffffff00 ))
                                                  .>onClick({ () => Log.println("Clicked %s", title) }) )
            .>addChild( YogaNode.>view( Label(title, font', 28).>left() ) )
