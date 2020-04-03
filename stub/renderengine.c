#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#define UNUSED(x) (void)(x)

void RenderEngine_destroy(void * ctx) {
    UNUSED(ctx);
}

void * RenderEngine_init(void * ponyRenderEngine) {
  UNUSED(ponyRenderEngine);
  return (void *)1;
}

void RenderEngine_render(HALRenderContext * ctx,
                         uint64_t frameNumber,
                         uint64_t renderNumber,
                         uint32_t shaderType,
                         uint32_t num_indices,
                         uint32_t * indices,
                         uint32_t size_indices_array,
                         uint32_t num_vertices,
                         void * vertices,
                         uint32_t size_vertices_array,
                         float globalR,
                         float globalG,
                         float globalB,
                         float globalA,
                         const char * textureName) {
    UNUSED(ctx);
    UNUSED(frameNumber);
    UNUSED(renderNumber);
    UNUSED(shaderType);
    UNUSED(num_indices);
    UNUSED(indices);
    UNUSED(size_indices_array);
    UNUSED(num_vertices);
    UNUSED(vertices);
    UNUSED(size_vertices_array);
    UNUSED(globalR);
    UNUSED(globalG);
    UNUSED(globalB);
    UNUSED(globalA);
    UNUSED(textureName);
}