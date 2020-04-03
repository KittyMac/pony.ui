use "ttimer"
use "yoga"
use "linal"

use @RenderEngine_textureInfo[TextureInfo](ctx:RenderContextRef tag, textureName:Pointer[U8] tag, widthPtr:Pointer[F32], heightPtr:Pointer[F32])
use @RenderEngine_render[None]( ctx:RenderContextRef tag, 
                        frameNumber:U64, 
                       renderNumber:U64, 
                         shaderType:U32,
                         numIndices:U32,
                            indices:UnsafePointer[U32] tag,
                 size_indices_array:U32,
                        numVertices:U32,
                           vertices:UnsafePointer[F32] tag, 
                size_vertices_array:U32, 
                            globalR:F32, 
                            globalG:F32, 
                            globalB:F32, 
                            globalA:F32, 
                        textureName:Pointer[U8] tag)

struct TextureInfo
  let image_width:U32 = 0
  let image_height:U32 = 0
  let texture_width:U32 = 0
  let texture_height:U32 = 0
    
primitive ShaderType
  fun finished():U32 => 0
  fun flat():U32 => 1
  fun textured():U32 => 2
  fun sdf():U32 => 3

primitive RenderPrimitive
  """
  Rendering actors can call this concurrently safely to submit geometry to the platform rendering engine
  """
  fun tag buildVCT(frameContext:FrameContext val, vertices:AlignedArray[F32], v:V3, c:RGBA, st:V2) =>
    let p = M4fun.mul_v3_point_3x4(frameContext.matrix, v)
    vertices.push(p._1); vertices.push(p._2); vertices.push(p._3)
    vertices.push(c.r); vertices.push(c.g); vertices.push(c.b); vertices.push(c.a)
    vertices.push(st._1); vertices.push(st._2)
  
  fun tag buildVC(frameContext:FrameContext val, vertices:AlignedArray[F32], v:V3, c:RGBA) =>
    let p = M4fun.mul_v3_point_3x4(frameContext.matrix, v)
    vertices.push(p._1); vertices.push(p._2); vertices.push(p._3)
    vertices.push(c.r); vertices.push(c.g); vertices.push(c.b); vertices.push(c.a)
    
  fun tag buildVT(frameContext:FrameContext val, vertices:AlignedArray[F32], v:V3, st:V2) =>
    let p = M4fun.mul_v3_point_3x4(frameContext.matrix, v)
    vertices.push(p._1); vertices.push(p._2); vertices.push(p._3)
    vertices.push(st._1); vertices.push(st._2)
    
  fun tag renderFinished(frameContext:FrameContext val) =>
    frameContext.engine.renderFinished()
  
  fun tag startFinished(frameContext:FrameContext val) =>
    frameContext.engine.startFinished()
  
  fun tag renderCachedGeometry(frameContext:FrameContext val, partNum:U64, shaderType:U32, vertices:AlignedArray[F32], indices:AlignedArray[U32], gc:RGBA val, t:Pointer[U8] tag) =>
    @RenderEngine_render( frameContext.renderContext,
                          frameContext.frameNumber,
                          (frameContext.renderNumber * 100) + partNum,
                          shaderType, 
                          indices.size().u32(), 
                          indices.cpointer(), 
                          indices.reserved().u32(),
                          vertices.size().u32(), 
                          vertices.cpointer(),
                          vertices.reserved().u32(),
                          gc.r, gc.g, gc.b, gc.a,
                          t)
    
  
  




