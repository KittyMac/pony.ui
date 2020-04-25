#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#define UNUSED(x) (void)(x)

#define HALRenderContext void

void RenderEngine_destroy(HALRenderContext * ctx) {
    UNUSED(ctx);
}

void * RenderEngine_init(HALRenderContext * ponyRenderEngine) {
  UNUSED(ponyRenderEngine);
  return (void *)1;
}

void * RenderEngine_malloc(size_t * size) {
  UNUSED(size);
  return NULL;
}

void * RenderEngine_retain(void * ptr, size_t size) {
  UNUSED(ptr);
  UNUSED(size);
  return NULL;
}

void RenderEngine_release(void * ptr, size_t size) {
  UNUSED(ptr);
  UNUSED(size);
}

size_t RenderEngine_maxConcurrentFrames(void) {
  return 3;
}

void RenderEngine_render(HALRenderContext * ctx,
                         uint64_t frameNumber,
                         uint64_t renderNumber,
                         uint32_t shaderType,
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
    UNUSED(num_vertices);
    UNUSED(vertices);
    UNUSED(size_vertices_array);
    UNUSED(globalR);
    UNUSED(globalG);
    UNUSED(globalB);
    UNUSED(globalA);
    UNUSED(textureName);
}

void RenderEngine_textureInfo(HALRenderContext * ctx, const char * textureName, float * width, float * height) {
  UNUSED(ctx);
  UNUSED(textureName);
  UNUSED(width);
  UNUSED(height);
}

void RenderEngine_createTextureFromBytes(HALRenderContext * ctx, const char * textureName, void * textureBytes, size_t countBytes) {
  UNUSED(ctx);
  UNUSED(textureName);
  UNUSED(textureBytes);
  UNUSED(countBytes);
}

void RenderEngine_createTextureFromUrl(HALRenderContext * ctx, const char * url) {
  UNUSED(ctx);
  UNUSED(url);
}

void RenderEngine_beginKeyboardInput(HALRenderContext * ctx) {
  UNUSED(ctx);
}

void RenderEngine_endKeyboardInput(HALRenderContext * ctx) {
  UNUSED(ctx);
}

void RenderEngine_pushClips(HALRenderContext * ctx,
                            uint64_t frameNumber,
                            uint64_t renderNumber,
                            uint32_t num_floats,
                            void * vertices,
                            uint32_t size_vertices_array) {
  UNUSED(ctx);
  UNUSED(frameNumber);
  UNUSED(renderNumber);
  UNUSED(num_floats);
  UNUSED(vertices);
  UNUSED(size_vertices_array);
}

void RenderEngine_popClips(HALRenderContext * ctx,
                           uint64_t frameNumber,
                           uint64_t renderNumber,
                           uint32_t num_floats,
                           void * vertices,
                           uint32_t size_vertices_array) {
  UNUSED(ctx);
  UNUSED(frameNumber);
  UNUSED(renderNumber);
  UNUSED(num_floats);
  UNUSED(vertices);
  UNUSED(size_vertices_array);
}

float RenderEngine_safeTop(void) {
  return 0.0f;
}

float RenderEngine_safeLeft(void) {
  return 0.0f;
}

float RenderEngine_safeBottom(void) {
  return 0.0f;
}

float RenderEngine_safeRight(void) {
  return 0.0f;
}