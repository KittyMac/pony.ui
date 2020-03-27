use "utility"

primitive SwitchToColors is Action
primitive SwitchToButtons is Action
primitive SwitchToImages is Action
primitive SwitchToFonts is Action

type CatalogAction is (SwitchToColors | SwitchToButtons | SwitchToImages | SwitchToFonts)
  

actor Catalog is Controller
  // Our UI is a side-bar of menu items and a right panel which switches between the various tests
  
  let font:Font = Font(TestFontJson())
  let renderEngine:RenderEngine
    
	new create(renderEngine':RenderEngine) =>
    renderEngine = renderEngine'
  
    let scene = recover iso
      YogaNode.>alignItems(_YgalignEnum.flexstart())
              .>flexDirection(_YgflexDirectionEnum.row())
              .>view( Color.>color(RGBA(0.98,0.98,0.98,1)) )
              .>addChildren( [
          
          // Sidebar
          YogaNode.>width(210)
                  .>heightPercent(100)
                  .>view( Image("sidebar").>stretch(10,10,10,10) )
                  .>addChildren([
              menuButton("Colors", font, SwitchToColors)
              menuButton("Buttons", font, SwitchToButtons)
              menuButton("Images", font, SwitchToImages)
              menuButton("Fonts", font, SwitchToFonts)
          ])
          
          // Panel
          YogaNode.>name("Panel")
                  .>view( Clear )
                  .>fill()
                            
        ]
      )
    end
    
    renderEngine.addNode(consume scene)
  
  fun tag menuButton(title:String, font':Font, evt:CatalogAction):YogaNode =>
    YogaNode.>width(204)
            .>height(46)
            .>padding(_YgedgeEnum.all(), 6)
            .>padding(_YgedgeEnum.left(), 12)
            .>view( ImageButton( "white", "white").>pressedColor(RGBA.u32( 0x98cbf3ff ))
                                                  .>color(RGBA.u32( 0xffffff00 ))
                                                  .>action(this, evt) )
            .>addChild( YogaNode.>view( Label(title, font', 28).>left() ) )

    
  
  be action(evt:Action) =>
    match evt
    | SwitchToColors =>
      
      renderEngine.getNodeByName("Panel", { (node) => 
        node.removeChildren()
        node.addChild( YogaNode.>view( Color.>red() ) )
        true
      })
      
    | SwitchToButtons => Log.println("switch to buttons")
      
      renderEngine.getNodeByName("Panel", { (node) => 
        node.removeChildren()
        node.addChild( YogaNode.>view( Color.>green() ) )
        true
      })
      
    | SwitchToImages => Log.println("switch to images")
      
      renderEngine.getNodeByName("Panel", { (node) => 
        node.removeChildren()
        node.addChild( YogaNode.>view( Color.>yellow() ) )
        true
      })
      
    | SwitchToFonts => Log.println("switch to fonts")
      
      renderEngine.getNodeByName("Panel", { (node) => 
        node.removeChildren()
        node.addChild( YogaNode.>view( Color.>magenta() ) )
        true
      })
    end
    
