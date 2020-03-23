use "ttimer"
use "yoga"
use "collections"
use "linal"
use "promises"

type YogaNodeID is USize

class YogaNode
  let node:_YgnodeRef
  let children:Array[YogaNode]
  var _view:(Viewable|None)
  var last_bounds:R4 = R4fun.zero()
  var last_matrix:M4 = M4fun.id()
  
  fun _final() =>
    @printf("_final called on yoga node [%d]\n".cstring(), node)
    @YGNodeFree(node)
  
  new empty() =>
    children = Array[YogaNode](32)
    node = @YGNodeNew()
    _view = None
  
	new create() =>
    children = Array[YogaNode](32)
    node = @YGNodeNew()
    _view = None
  
	new view(_view':Viewable) =>
    children = Array[YogaNode](32)
    node = @YGNodeNew()
    _view = _view'
    fill()
    
  fun id():YogaNodeID =>
    node.usize()
  
  fun ref addChild(child:YogaNode) =>
    children.push(child)
    @YGNodeInsertChild(node, child.node, @YGNodeGetChildCount(node))
  
  fun ref addChildren(new_children:Array[YogaNode]) =>
    for child in new_children.values() do
      addChild(child)
    end
  
  fun ref layout() =>
    // Before we can calculate the layout, we need to see if any of our children sizeToFit their content. If we do, we need
    // to have them set the size on the appropriate yoga node
    @YGNodeCalculateLayout(node, @YGNodeStyleGetWidth(node), @YGNodeStyleGetHeight(node), _YgdirectionEnum.ltr())
  
  fun print() =>
    @YGNodePrint(node, _YgprintOptionsEnum.layout() or _YgprintOptionsEnum.style() or _YgprintOptionsEnum.children())
    @printf("\n".cstring())
  
  fun ref getNodeByID(nodeID:YogaNodeID, callback:GetYogaNodeCallback val ):Bool =>
    if id() == nodeID then
      return callback(this)
    end
    
    for child in children.values() do
      if child.getNodeByID(nodeID, callback) then
        return true
      end
    end
    false
  
  // Called when the node is first added to the render engine hierarchy
  fun ref start(frameContext:FrameContext):U64 =>
    var n:U64 = frameContext.renderNumber + 1
    
    frameContext.renderNumber = n
    frameContext.nodeID = id()
    
    match _view
    | let v:Viewable => v.viewable_start( frameContext.clone() )
    | None => frameContext.engine.startFinished()
    end
    
    for child in children.values() do
      n = child.start(frameContext)
      frameContext.renderNumber = n
    end
    n
  
  // Called when distributing events to nodes
  fun ref event(frameContext:FrameContext, anyEvent:AnyEvent val):U64 =>
    var n:U64 = frameContext.renderNumber + 1
  
    frameContext.renderNumber = n
    frameContext.matrix = last_matrix
    frameContext.nodeID = id()
    
    match _view
    | let v:Viewable => v.viewable_event( frameContext.clone(), anyEvent, last_bounds )
    end
  
    for child in children.values() do
      n = child.event(frameContext, anyEvent)
      frameContext.renderNumber = n
    end
    n
  
  // Called when the render engine hierarchy needs to... render
  fun ref render(frameContext:FrameContext):U64 =>
    _renderRecursive(frameContext, M4fun.id())
    
  fun ref _renderRecursive(frameContext:FrameContext, parent_matrix:M4):U64 =>
    var n:U64 = frameContext.renderNumber + 1
    let local_left:F32 = @YGNodeLayoutGetLeft(node)
    let local_top:F32 = @YGNodeLayoutGetTop(node)
    let local_width:F32 = @YGNodeLayoutGetWidth(node)
    let local_height:F32 = @YGNodeLayoutGetHeight(node)
    
    var local_matrix:M4 = M4fun.mul_m4(
        parent_matrix,
        M4fun.trans_v3(V3fun(local_left, local_top, 0))
      )
    
    local_matrix = M4fun.mul_m4(
            local_matrix,
            M4fun.trans_v3(V3fun(local_width/2, local_height/2, 0))
          )
    
    /*
    local_matrix = M4fun.mul_m4(
            local_matrix,
            M4fun.rot(Q4fun.from_euler(V3fun(0,0,F32.pi()/2)))
          )
    */
    
    frameContext.renderNumber = n
    frameContext.matrix = local_matrix
    frameContext.nodeID = id()
    
    last_bounds = R4fun( -local_width/2, -local_height/2, local_width, local_height)
    last_matrix = local_matrix
    
    match _view
    | let v:Viewable => v.viewable_render( frameContext.clone(), last_bounds )
    | None => frameContext.engine.renderFinished()
    end
    
    local_matrix = M4fun.mul_m4(
            local_matrix,
            M4fun.trans_v3(V3fun(-local_width/2, -local_height/2, 0))
          )
    
    for child in children.values() do
      n = child._renderRecursive(frameContext, local_matrix)
      frameContext.renderNumber = n
    end
    n
  
  fun ref fill() =>
    widthPercent(100)
    heightPercent(100)
  
  fun ref direction(v:U32) => @YGNodeStyleSetDirection(node, v)
  fun ref flexDirection(v:U32) => @YGNodeStyleSetFlexDirection(node, v)
  
  fun ref justifyContent(v:U32) => @YGNodeStyleSetJustifyContent(node, v)
  
  fun ref alignContent(v:U32) => @YGNodeStyleSetAlignContent(node, v)
  fun ref alignItems(v:U32) => @YGNodeStyleSetAlignItems(node, v)
  fun ref alignSelf(v:U32) => @YGNodeStyleSetAlignSelf(node, v)
  
  fun ref positionType(v:U32) => @YGNodeStyleSetPositionType(node, v)
  
  fun ref overflow(v:U32) => @YGNodeStyleSetOverflow(node, v)
  fun ref display(v:U32) => @YGNodeStyleSetDisplay(node, v)
  
  fun ref flexWrap(v:U32) => @YGNodeStyleSetFlexWrap(node, v)
  fun ref flex(v:F32) => @YGNodeStyleSetFlex(node, v)
  fun ref flexGrow(v:F32) => @YGNodeStyleSetFlexGrow(node, v)
  fun ref flexShrink(v:F32) => @YGNodeStyleSetFlexShrink(node, v)
  fun ref flexBasis(v:F32) => @YGNodeStyleSetFlexBasis(node, v)
  fun ref flexBasisPercent(v:F32) => @YGNodeStyleSetFlexBasisPercent(node, v)
  fun ref flexAuto() => @YGNodeStyleSetFlexBasisAuto(node)
  
  fun ref position(v1:U32, v2:F32) => @YGNodeStyleSetPosition(node, v1, v2)
  fun ref positionPercent(v1:U32, v2:F32) => @YGNodeStyleSetPositionPercent(node, v1, v2)
  
  fun ref margin(v1:U32, v2:F32) => @YGNodeStyleSetMargin(node, v1, v2)
  fun ref marginPercent(v1:U32, v2:F32) => @YGNodeStyleSetMarginPercent(node, v1, v2)
  fun ref marginAuto(v1:U32) => @YGNodeStyleSetMarginAuto(node, v1)
  
  fun ref padding(v1:U32, v2:F32) => @YGNodeStyleSetPadding(node, v1, v2)
  fun ref paddingPercent(v1:U32, v2:F32) => @YGNodeStyleSetPaddingPercent(node, v1, v2)
  
  fun ref border(v1:U32, v2:F32) => @YGNodeStyleSetBorder(node, v1, v2)
  
  fun ref width(v:F32) => @YGNodeStyleSetWidth(node, v)
  fun ref widthPercent(v:F32) => @YGNodeStyleSetWidthPercent(node, v)
  fun ref widthAuto() => @YGNodeStyleSetWidthAuto(node)
  
  fun ref height(v:F32) => @YGNodeStyleSetHeight(node, v)
  fun ref heightPercent(v:F32) => @YGNodeStyleSetHeightPercent(node, v)
  fun ref heightAuto() => @YGNodeStyleSetHeightAuto(node)
  
  fun ref minWidth(v:F32) => @YGNodeStyleSetMinWidth(node, v)
  fun ref minWidthPercent(v:F32) => @YGNodeStyleSetMinWidthPercent(node, v)
  
  fun ref minHeight(v:F32) => @YGNodeStyleSetMinHeight(node, v)
  fun ref minHeightPercent(v:F32) => @YGNodeStyleSetMinHeightPercent(node, v)
  
  fun ref maxWidth(v:F32) => @YGNodeStyleSetMaxWidth(node, v)
  fun ref maxWidthPercent(v:F32) => @YGNodeStyleSetMaxWidthPercent(node, v)
  
  fun ref maxHeight(v:F32) => @YGNodeStyleSetMaxHeight(node, v)
  fun ref maxHeightPercent(v:F32) => @YGNodeStyleSetMaxHeightPercent(node, v)
  
  fun ref aspectRatio(v:F32) => @YGNodeStyleSetAspectRatio(node, v)
  
  
  
  
  fun getWidth():F32 => @YGNodeStyleGetWidth(node)
  fun getHeight():F32 => @YGNodeStyleGetHeight(node)
  
  
  /*

primitive _YgalignEnum
  fun auto():U32 => 0x0
  fun flexstart():U32 => 0x1
  fun center():U32 => 0x2
  fun flexend():U32 => 0x3
  fun stretch():U32 => 0x4
  fun baseline():U32 => 0x5
  fun spacebetween():U32 => 0x6
  fun spacearound():U32 => 0x7
primitive _YgdimensionEnum
  fun width():U32 => 0x0
  fun height():U32 => 0x1
primitive _YgdirectionEnum
  fun inherit():U32 => 0x0
  fun ltr():U32 => 0x1
  fun rtl():U32 => 0x2
primitive _YgdisplayEnum
  fun flex():U32 => 0x0
  fun none():U32 => 0x1
primitive _YgedgeEnum
  fun left():U32 => 0x0
  fun top():U32 => 0x1
  fun right():U32 => 0x2
  fun bottom():U32 => 0x3
  fun start():U32 => 0x4
  fun end_pony():U32 => 0x5
  fun horizontal():U32 => 0x6
  fun vertical():U32 => 0x7
  fun all():U32 => 0x8
primitive _YgflexDirectionEnum
  fun column():U32 => 0x0
  fun columnreverse():U32 => 0x1
  fun row():U32 => 0x2
  fun rowreverse():U32 => 0x3
primitive _YgjustifyEnum
  fun flexstart():U32 => 0x0
  fun center():U32 => 0x1
  fun flexend():U32 => 0x2
  fun spacebetween():U32 => 0x3
  fun spacearound():U32 => 0x4
  fun spaceevenly():U32 => 0x5
primitive _YglogLevelEnum
  fun error_pony():U32 => 0x0
  fun warn():U32 => 0x1
  fun info():U32 => 0x2
  fun debug():U32 => 0x3
  fun verbose():U32 => 0x4
  fun fatal():U32 => 0x5
primitive _YgmeasureModeEnum
  fun undefined():U32 => 0x0
  fun exactly():U32 => 0x1
  fun atmost():U32 => 0x2
primitive _YgnodeTypeEnum
  fun default():U32 => 0x0
  fun text():U32 => 0x1
primitive _YgoverflowEnum
  fun visible():U32 => 0x0
  fun hidden():U32 => 0x1
  fun scroll():U32 => 0x2
primitive _YgpositionTypeEnum
  fun relative():U32 => 0x0
  fun absolute():U32 => 0x1
primitive _YgprintOptionsEnum
  fun layout():U32 => 0x1
  fun style():U32 => 0x2
  fun children():U32 => 0x4
primitive _YgunitEnum
  fun undefined():U32 => 0x0
  fun point():U32 => 0x1
  fun percent():U32 => 0x2
  fun auto():U32 => 0x3
primitive _YgwrapEnum
  fun nowrap():U32 => 0x0
  fun wrap():U32 => 0x1
  fun wrapreverse():U32 => 0x2
  */

/*
use @YGNodeNew[Pointer[_Ygnode]]()
use @YGNodeNewWithConfig[Pointer[_Ygnode]](config:Pointer[_Ygconfig] tag)
use @YGNodeClone[Pointer[_Ygnode]](node:Pointer[_Ygnode] tag)
use @YGNodeFree[None](node:Pointer[_Ygnode] tag)
use @YGNodeFreeRecursiveWithCleanupFunc[None](node:Pointer[_Ygnode] tag, cleanup:Pointer[None] tag)
use @YGNodeFreeRecursive[None](node:Pointer[_Ygnode] tag)
use @YGNodeReset[None](node:Pointer[_Ygnode] tag)
use @YGNodeInsertChild[None](node:Pointer[_Ygnode] tag, child:Pointer[_Ygnode] tag, index:U64)
use @YGNodeSwapChild[None](node:Pointer[_Ygnode] tag, child:Pointer[_Ygnode] tag, index:U64)
use @YGNodeRemoveChild[None](node:Pointer[_Ygnode] tag, child:Pointer[_Ygnode] tag)
use @YGNodeRemoveAllChildren[None](node:Pointer[_Ygnode] tag)
use @YGNodeGetChild[Pointer[_Ygnode]](node:Pointer[_Ygnode] tag, index:U64)
use @YGNodeGetOwner[Pointer[_Ygnode]](node:Pointer[_Ygnode] tag)
use @YGNodeGetParent[Pointer[_Ygnode]](node:Pointer[_Ygnode] tag)
use @YGNodeGetChildCount[U64](node:Pointer[_Ygnode] tag)
use @YGNodeSetIsReferenceBaseline[None](node:Pointer[_Ygnode] tag, isReferenceBaseline:U32)
use @YGNodeIsReferenceBaseline[U32](node:Pointer[_Ygnode] tag)
use @YGNodeCalculateLayout[None](node:Pointer[_Ygnode] tag, availableWidth:F32, availableHeight:F32, ownerDirection:U32)
use @YGNodeMarkDirty[None](node:Pointer[_Ygnode] tag)
use @YGNodeMarkDirtyAndPropogateToDescendants[None](node:Pointer[_Ygnode] tag)
use @YGNodePrint[None](node:Pointer[_Ygnode] tag, options:U32)
use @YGFloatIsUndefined[U32](value:F32)
use @YGNodeCanUseCachedMeasurement[U32](widthMode:U32, width:F32, heightMode:U32, height:F32, lastWidthMode:U32, lastWidth:F32, lastHeightMode:U32, lastHeight:F32, lastComputedWidth:F32, lastComputedHeight:F32, marginRow:F32, marginColumn:F32, config:Pointer[_Ygconfig] tag)
use @YGNodeCopyStyle[None](dstNode:Pointer[_Ygnode] tag, srcNode:Pointer[_Ygnode] tag)
use @YGNodeGetContext[Pointer[None]](node:Pointer[_Ygnode] tag)
use @YGNodeSetContext[None](node:Pointer[_Ygnode] tag, context:Pointer[None] tag)
use @YGConfigSetPrintTreeFlag[None](config:Pointer[_Ygconfig] tag, enabled:U32)
use @YGNodeHasMeasureFunc[U32](node:Pointer[_Ygnode] tag)
use @YGNodeSetMeasureFunc[None](node:Pointer[_Ygnode] tag, measureFunc:U32)
use @YGNodeHasBaselineFunc[U32](node:Pointer[_Ygnode] tag)
use @YGNodeSetBaselineFunc[None](node:Pointer[_Ygnode] tag, baselineFunc:Pointer[None] tag)
use @YGNodeGetDirtiedFunc[Pointer[None]](node:Pointer[_Ygnode] tag)
use @YGNodeSetDirtiedFunc[None](node:Pointer[_Ygnode] tag, dirtiedFunc:Pointer[None] tag)
use @YGNodeSetPrintFunc[None](node:Pointer[_Ygnode] tag, printFunc:Pointer[None] tag)
use @YGNodeGetHasNewLayout[U32](node:Pointer[_Ygnode] tag)
use @YGNodeSetHasNewLayout[None](node:Pointer[_Ygnode] tag, hasNewLayout:U32)
use @YGNodeGetNodeType[U32](node:Pointer[_Ygnode] tag)
use @YGNodeSetNodeType[None](node:Pointer[_Ygnode] tag, nodeType:U32)
use @YGNodeIsDirty[U32](node:Pointer[_Ygnode] tag)
use @YGNodeLayoutGetDidUseLegacyFlag[U32](node:Pointer[_Ygnode] tag)
use @YGNodeStyleSetDirection[None](node:Pointer[_Ygnode] tag, direction:U32)
use @YGNodeStyleGetDirection[U32](node:Pointer[_Ygnode] tag)
use @YGNodeStyleSetFlexDirection[None](node:Pointer[_Ygnode] tag, flexDirection:U32)
use @YGNodeStyleGetFlexDirection[U32](node:Pointer[_Ygnode] tag)
use @YGNodeStyleSetJustifyContent[None](node:Pointer[_Ygnode] tag, justifyContent:U32)
use @YGNodeStyleGetJustifyContent[U32](node:Pointer[_Ygnode] tag)
use @YGNodeStyleSetAlignContent[None](node:Pointer[_Ygnode] tag, alignContent:U32)
use @YGNodeStyleGetAlignContent[U32](node:Pointer[_Ygnode] tag)
use @YGNodeStyleSetAlignItems[None](node:Pointer[_Ygnode] tag, alignItems:U32)
use @YGNodeStyleGetAlignItems[U32](node:Pointer[_Ygnode] tag)
use @YGNodeStyleSetAlignSelf[None](node:Pointer[_Ygnode] tag, alignSelf:U32)
use @YGNodeStyleGetAlignSelf[U32](node:Pointer[_Ygnode] tag)
use @YGNodeStyleSetPositionType[None](node:Pointer[_Ygnode] tag, positionType:U32)
use @YGNodeStyleGetPositionType[U32](node:Pointer[_Ygnode] tag)
use @YGNodeStyleSetFlexWrap[None](node:Pointer[_Ygnode] tag, flexWrap:U32)
use @YGNodeStyleGetFlexWrap[U32](node:Pointer[_Ygnode] tag)
use @YGNodeStyleSetOverflow[None](node:Pointer[_Ygnode] tag, overflow:U32)
use @YGNodeStyleGetOverflow[U32](node:Pointer[_Ygnode] tag)
use @YGNodeStyleSetDisplay[None](node:Pointer[_Ygnode] tag, display:U32)
use @YGNodeStyleGetDisplay[U32](node:Pointer[_Ygnode] tag)
use @YGNodeStyleSetFlex[None](node:Pointer[_Ygnode] tag, flex:F32)
use @YGNodeStyleGetFlex[F32](node:Pointer[_Ygnode] tag)
use @YGNodeStyleSetFlexGrow[None](node:Pointer[_Ygnode] tag, flexGrow:F32)
use @YGNodeStyleGetFlexGrow[F32](node:Pointer[_Ygnode] tag)
use @YGNodeStyleSetFlexShrink[None](node:Pointer[_Ygnode] tag, flexShrink:F32)
use @YGNodeStyleGetFlexShrink[F32](node:Pointer[_Ygnode] tag)
use @YGNodeStyleSetFlexBasis[None](node:Pointer[_Ygnode] tag, flexBasis:F32)
use @YGNodeStyleSetFlexBasisPercent[None](node:Pointer[_Ygnode] tag, flexBasis:F32)
use @YGNodeStyleSetFlexBasisAuto[None](node:Pointer[_Ygnode] tag)
use @YGNodeStyleGetFlexBasis[U32](node:Pointer[_Ygnode] tag)
use @YGNodeStyleSetPosition[None](node:Pointer[_Ygnode] tag, edge:U32, position:F32)
use @YGNodeStyleSetPositionPercent[None](node:Pointer[_Ygnode] tag, edge:U32, position:F32)
use @YGNodeStyleGetPosition[U32](node:Pointer[_Ygnode] tag, edge:U32)
use @YGNodeStyleSetMargin[None](node:Pointer[_Ygnode] tag, edge:U32, margin:F32)
use @YGNodeStyleSetMarginPercent[None](node:Pointer[_Ygnode] tag, edge:U32, margin:F32)
use @YGNodeStyleSetMarginAuto[None](node:Pointer[_Ygnode] tag, edge:U32)
use @YGNodeStyleGetMargin[U32](node:Pointer[_Ygnode] tag, edge:U32)
use @YGNodeStyleSetPadding[None](node:Pointer[_Ygnode] tag, edge:U32, padding:F32)
use @YGNodeStyleSetPaddingPercent[None](node:Pointer[_Ygnode] tag, edge:U32, padding:F32)
use @YGNodeStyleGetPadding[U32](node:Pointer[_Ygnode] tag, edge:U32)
use @YGNodeStyleSetBorder[None](node:Pointer[_Ygnode] tag, edge:U32, border:F32)
use @YGNodeStyleGetBorder[F32](node:Pointer[_Ygnode] tag, edge:U32)
use @YGNodeStyleSetWidth[None](node:Pointer[_Ygnode] tag, width:F32)
use @YGNodeStyleSetWidthPercent[None](node:Pointer[_Ygnode] tag, width:F32)
use @YGNodeStyleSetWidthAuto[None](node:Pointer[_Ygnode] tag)
use @YGNodeStyleGetWidth[U32](node:Pointer[_Ygnode] tag)
use @YGNodeStyleSetHeight[None](node:Pointer[_Ygnode] tag, height:F32)
use @YGNodeStyleSetHeightPercent[None](node:Pointer[_Ygnode] tag, height:F32)
use @YGNodeStyleSetHeightAuto[None](node:Pointer[_Ygnode] tag)
use @YGNodeStyleGetHeight[U32](node:Pointer[_Ygnode] tag)
use @YGNodeStyleSetMinWidth[None](node:Pointer[_Ygnode] tag, minWidth:F32)
use @YGNodeStyleSetMinWidthPercent[None](node:Pointer[_Ygnode] tag, minWidth:F32)
use @YGNodeStyleGetMinWidth[U32](node:Pointer[_Ygnode] tag)
use @YGNodeStyleSetMinHeight[None](node:Pointer[_Ygnode] tag, minHeight:F32)
use @YGNodeStyleSetMinHeightPercent[None](node:Pointer[_Ygnode] tag, minHeight:F32)
use @YGNodeStyleGetMinHeight[U32](node:Pointer[_Ygnode] tag)
use @YGNodeStyleSetMaxWidth[None](node:Pointer[_Ygnode] tag, maxWidth:F32)
use @YGNodeStyleSetMaxWidthPercent[None](node:Pointer[_Ygnode] tag, maxWidth:F32)
use @YGNodeStyleGetMaxWidth[U32](node:Pointer[_Ygnode] tag)
use @YGNodeStyleSetMaxHeight[None](node:Pointer[_Ygnode] tag, maxHeight:F32)
use @YGNodeStyleSetMaxHeightPercent[None](node:Pointer[_Ygnode] tag, maxHeight:F32)
use @YGNodeStyleGetMaxHeight[U32](node:Pointer[_Ygnode] tag)
use @YGNodeStyleSetAspectRatio[None](node:Pointer[_Ygnode] tag, aspectRatio:F32)
use @YGNodeStyleGetAspectRatio[F32](node:Pointer[_Ygnode] tag)
use @YGNodeLayoutGetLeft[F32](node:Pointer[_Ygnode] tag)
use @YGNodeLayoutGetTop[F32](node:Pointer[_Ygnode] tag)
use @YGNodeLayoutGetRight[F32](node:Pointer[_Ygnode] tag)
use @YGNodeLayoutGetBottom[F32](node:Pointer[_Ygnode] tag)
use @YGNodeLayoutGetWidth[F32](node:Pointer[_Ygnode] tag)
use @YGNodeLayoutGetHeight[F32](node:Pointer[_Ygnode] tag)
use @YGNodeLayoutGetDirection[U32](node:Pointer[_Ygnode] tag)
use @YGNodeLayoutGetHadOverflow[U32](node:Pointer[_Ygnode] tag)
use @YGNodeLayoutGetDidLegacyStretchFlagAffectLayout[U32](node:Pointer[_Ygnode] tag)
use @YGNodeLayoutGetMargin[F32](node:Pointer[_Ygnode] tag, edge:U32)
use @YGNodeLayoutGetBorder[F32](node:Pointer[_Ygnode] tag, edge:U32)
use @YGNodeLayoutGetPadding[F32](node:Pointer[_Ygnode] tag, edge:U32)
use @YGConfigSetLogger[None](config:Pointer[_Ygconfig] tag, logger:Pointer[None] tag)
use @YGAssert[None](condition:U32, message:Pointer[U8] tag)
use @YGAssertWithNode[None](node:Pointer[_Ygnode] tag, condition:U32, message:Pointer[U8] tag)
use @YGAssertWithConfig[None](config:Pointer[_Ygconfig] tag, condition:U32, message:Pointer[U8] tag)
use @YGConfigSetPointScaleFactor[None](config:Pointer[_Ygconfig] tag, pixelsInPoint:F32)
use @YGConfigSetShouldDiffLayoutWithoutLegacyStretchBehaviour[None](config:Pointer[_Ygconfig] tag, shouldDiffLayout:U32)
use @YGConfigSetUseLegacyStretchBehaviour[None](config:Pointer[_Ygconfig] tag, useLegacyStretchBehaviour:U32)
use @YGConfigNew[Pointer[_Ygconfig]]()
use @YGConfigFree[None](config:Pointer[_Ygconfig] tag)
use @YGConfigCopy[None](dest:Pointer[_Ygconfig] tag, src:Pointer[_Ygconfig] tag)
use @YGConfigGetInstanceCount[I64]()
use @YGConfigSetExperimentalFeatureEnabled[None](config:Pointer[_Ygconfig] tag, feature:U32, enabled:U32)
use @YGConfigIsExperimentalFeatureEnabled[U32](config:Pointer[_Ygconfig] tag, feature:U32)
use @YGConfigSetUseWebDefaults[None](config:Pointer[_Ygconfig] tag, enabled:U32)
use @YGConfigGetUseWebDefaults[U32](config:Pointer[_Ygconfig] tag)
use @YGConfigSetCloneNodeFunc[None](config:Pointer[_Ygconfig] tag, callback:Pointer[None] tag)
use @YGConfigGetDefault[Pointer[_Ygconfig]]()
use @YGConfigSetContext[None](config:Pointer[_Ygconfig] tag, context:Pointer[None] tag)
use @YGConfigGetContext[Pointer[None]](config:Pointer[_Ygconfig] tag)
use @YGRoundValueToPixelGrid[F32](value:F32, pointScaleFactor:F32, forceCeil:U32, forceFloor:U32)
*/
