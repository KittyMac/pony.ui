use "yoga"
use "utility"
use "collections"
use "laba"

primitive PerformLabaAnimation is Action

actor LabaTest is Controllerable
  """
  Most image search APIs require you to pay to call them, and that's too rediculous to contemplate for this little example program. 
  So I have included a save search for kittens, which will be loaded no matter what yiou put in the field.
  http://api.qwant.com/api/search/images?count=250&q=kittens&t=images&local=en_US&uiv=4
  """
  
  let font:Font = Font(TestFontJson())
  
  let labaKey:String = "laba_key"
  
	fun ref mainNode():YogaNode iso^ =>
    
    recover iso 
      let sampleBox = {(title:String val, children:Array[YogaNode]): YogaNode =>
        YogaNode.>columns().>size(200,240).>marginAll(2)
                .>view(Border.>gray())
                .>addChildren([
                    YogaNode.>height(40)
                            .>view(Color.>gray())
                            .>view(Label.>value(title).>font(font, 18).>center().>renderInsetAll(4))
                    
                    YogaNode.>center().>shrink()
                            .>addChildren(children)
                ])
      }
      
      let sample1 = {(title:String val, laba1:String val): YogaNode =>
        sampleBox(title, [
            YogaNode.>name("Red")
                    .>size(50,50)
                    .>laba(laba1, None, {(node:YogaNode, self:Laba) => self.reset()})
                    .>view( Color.>red() )
        ])
      }
      let sample2 = {(title:String val, laba1:String val, laba2:String val): YogaNode =>
        sampleBox(title, [
            YogaNode.>size(50,50)
                    .>laba(laba1, None, {(node:YogaNode, self:Laba) => self.reset()})
                    .>view( Color.>blue() )
            YogaNode.>size(50,50)
                    .>laba(laba2, None, {(node:YogaNode, self:Laba) => self.reset()})
                    .>view( Color.>red() )
        ])
      }
      let sample3 = {(title:String val, laba1:String val, laba2:String val, laba3:String val): YogaNode =>
        sampleBox(title, [
            YogaNode.>size(50,50)
                    .>laba(laba1, None, {(node:YogaNode, self:Laba) => self.reset()})
                    .>view( Color.>blue() )
            YogaNode.>size(50,50)
                    .>laba(laba2, None, {(node:YogaNode, self:Laba) => self.reset()})
                    .>view( Color.>red() )
            YogaNode.>size(50,50)
                    .>laba(laba3, None, {(node:YogaNode, self:Laba) => self.reset()})
                    .>view( Color.>yellow() )
        ])
      }
      
      
      
      YogaNode.>paddingAll(6).>columns().>columnsReversed()
              .>view( Color.>color(RGBA(0.98,0.98,0.98,1)) )
              .>addChildren( [
            
            // Scroll view containing all of the examples
            YogaNode.>paddingLeft(6).>paddingRight(6).>shrink()
                    .>clips(true)
                    .>view( Scroll.>horizontal(false) )
                    .>addChildren([
                  
                      YogaNode.>fit().>rows().>wrap()
                              .>addChildren([
                                  sample3("Staggered Delay", "!fI!>|id0|id0|id0", "!fI!>|id0|id0", "!fI!>|id0")
                                  sample3("Invert Staggered Delay", "!f!I!>|id0", "!f!I!>|id0|id0", "!f!I!>|id0|id0|id0")
                                  sample1("Simple Movement", "<|^|>|v100|>|^|<")
                                  sample1("Linear Movement", "e0<|^|>|v100|>|^|<")
                                  sample2("Width & Height", "", "w100|w50|h100|h50")
                                  sample2("Scale", "", "!s0.8|s1.2|s0.8")
                                  sample3("Rotation", "e0r3.14", "e0p3.14", "e0a3.14")
                                  sample1("Move To", "x-50y-50|x50y-50|x-50y50|x50y50")
                              ])
                          
                    ])
             
          ])
      end
    
  be action(evt:Action) =>
    if engine as RenderEngine then
        match evt
        | PerformLabaAnimation => performLabaAnimation()
        end
    end
  
  fun ref performLabaAnimation() =>
    try
      match getSyncData(labaKey)?
      | let labaString:String val =>
        if engine as RenderEngine then
          engine.getNodeByName("Red", { (node) =>
            if node as YogaNode then
              // reset the node, then set the laba animation
              node.>left(0).>top(0).>size(200,200)
                  .>laba(labaString)
            end
            LayoutNeeded
          })
        end
      end
    end
    