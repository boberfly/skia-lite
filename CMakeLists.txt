project(skia)
cmake_minimum_required(VERSION 2.8)
enable_language(CXX ASM)

function(set_prefix var prefix)
  string(REGEX REPLACE "(^|;)([^;]+)" "\\1${prefix}\\2" tmp "${ARGN}")
  set(${var} "${tmp}" PARENT_SCOPE)
endfunction()

# Use ccache if we're told to.
if(DEFINED ENV{CCACHE})
  set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE $ENV{CCACHE})
  set_property(GLOBAL PROPERTY RULE_LAUNCH_LINK $ENV{CCACHE})
endif()

if("$ENV{CFG_ENABLE_DEBUG_SKIA}" STREQUAL "1")
  add_definitions(
    -DDSK_DEBUG
    -DGR_DEBUG=1
    -DGR_GL_LOG_CALLS=1
    -DGR_GL_LOG_CALLS_START=1
  )
  if(MSVC)
    add_definitions(-Zi)
  else()
    add_definitions(-g)
  endif()
else()
  add_definitions(
    -DSK_RELEASE
    -DGR_RELEASE=1
  )
  if(MSVC)
    add_definitions(-Os)
  else()
    add_definitions(-O3)
  endif()
endif()

add_definitions(
  -DSK_A32_SHIFT=24
  -DSK_R32_SHIFT=16
  -DSK_G32_SHIFT=8
  -DSK_B32_SHIFT=0
  -DGR_GL_USE_NEW_SHADER_SOURCE_SIGNATURE=1
  -DSK_SUPPORT_GPU=1
  -DSK_GL=1
  -DSK_VULKAN=1
)

if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  add_definitions(-Wno-c++11-extensions)
endif()

if(NOT WIN32)
  add_definitions(-fPIC)
endif()

include(ExternalProject)
# Freetype
ExternalProject_Add( freetype_internal
  PREFIX ${CMAKE_SOURCE_DIR}/third_party/freetype
  SOURCE_DIR ${CMAKE_SOURCE_DIR}/third_party/freetype
  INSTALL_DIR ${CMAKE_SOURCE_DIR}/third_party/freetype/out
  CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_SOURCE_DIR}/third_party/freetype/out
)
include_directories( third_party/freetype/out/include/freetype2 )
# Vulkan
if( NOT APPLE )
  find_package( Vulkan REQUIRED )
  include_directories( ${Vulkan_INCLUDE_DIR} )
endif()

include_directories(
  ./
  include/android
  include/atlastext
  include/c
  include/codec
  include/config
  include/core
  include/docs
  include/effects
  include/encode
  include/gpu
  include/pathops
  include/ports
  include/private
  include/svg
  include/third_party
  include/utils
  src/c
  src/core
  src/image
  src/opts
  src/ports
  src/sfnt
  src/utils
  third_party/etc1
  third_party/vulkanmemoryallocator
  src/gpu
  )

set_prefix(SKIA_C_SRC src/c/
  sk_paint.cpp
  sk_effects.cpp
  sk_imageinfo.cpp
  sk_surface.cpp
  )
set_prefix(SKIA_CORE_SRC src/core/
  SkResourceCache.cpp
  SkScan_Path.cpp
  SkHalf.cpp
  SkMask.cpp
  SkRecordDraw.cpp
  SkVertState.cpp
  SkPicture.cpp
  SkUtilsArm.cpp
  SkRasterPipelineBlitter.cpp
  SkImageInfo.cpp
  SkRTree.cpp
  SkStrikeCache.cpp
  SkTaskGroup.cpp
  SkBitmapController.cpp
  SkTypefaceCache.cpp
  SkModeColorFilter.cpp
  SkAutoPixmapStorage.cpp
  SkBlitter_RGB565.cpp
  SkBitmapDevice.cpp
  SkExecutor.cpp
  SkLineClipper.cpp
  SkImageFilter.cpp
  SkImageFilterCache.cpp
  SkDraw_text.cpp
  SkBlitRow_D32.cpp
  SkFont.cpp
  SkPoint.cpp
  SkFontDescriptor.cpp
  SkMatrixImageFilter.cpp
  SkScan.cpp
  SkClipStackDevice.cpp
  SkStrokeRec.cpp
  SkScan_Antihair.cpp
  SkNormalMapSource.cpp
  SkScan_AntiPath.cpp
  SkXfermodeInterpretation.cpp
  SkOpts.cpp
  SkGraphics.cpp
  SkDrawable.cpp
  SkVertices.cpp
  SkFontLCDConfig.cpp
  SkPoint3.cpp
  SkSharedMutex.cpp
  SkTSearch.cpp
  SkYUVPlanesCache.cpp
  SkGaussFilter.cpp
  SkBlitter_Sprite.cpp
  SkRemoteGlyphCache.cpp
  SkAnalyticEdge.cpp
  SkBlitter_A8.cpp
  SkRRect.cpp
  SkDescriptor.cpp
  SkDeferredDisplayListRecorder.cpp
  SkBlurMask.cpp
  SkAlphaRuns.cpp
  SkSpinlock.cpp
  SkClipStack.cpp
  SkGlyphRunPainter.cpp
  SkUtils.cpp
  SkATrace.cpp
  SkBitmapProvider.cpp
  SkFontMgr.cpp
  SkDevice.cpp
  SkPaint.cpp
  SkReadBuffer.cpp
  SkDocument.cpp
  SkDrawShadowInfo.cpp
  SkMD5.cpp
  SkCubicClipper.cpp
  SkWriteBuffer.cpp
  SkArenaAlloc.cpp
  SkContourMeasure.cpp
  SkDataTable.cpp
  SkSpecialImage.cpp
  SkCpu.cpp
  SkPtrRecorder.cpp
  SkGlyph.cpp
  SkDeferredDisplayList.cpp
  SkPictureRecord.cpp
  SkPictureData.cpp
  SkCubicMap.cpp
  SkDebug.cpp
  SkOverdrawCanvas.cpp
  SkScan_AAAPath.cpp
  SkPath_serial.cpp
  SkColor.cpp
  SkAnnotation.cpp
  SkBlitter_ARGB32.cpp
  SkMaskGamma.cpp
  SkBuffer.cpp
  SkNormalFlatSource.cpp
  SkStringUtils.cpp
  SkPromiseImageTexture.cpp
  SkAAClip.cpp
  SkBlendMode.cpp
  SkPathEffect.cpp
  SkTypeface.cpp
  SkDistanceFieldGen.cpp
  SkRasterPipeline.cpp
  SkRecorder.cpp
  SkSemaphore.cpp
  SkThreadID.cpp
  SkWriter32.cpp
  SkMiniRecorder.cpp
  SkDrawLooper.cpp
  SkYUVMath.cpp
  SkBBHFactory.cpp
  SkSwizzle.cpp
  SkImageGenerator.cpp
  SkGlyphRun.cpp
  SkBitmapProcState_matrixProcs.cpp
  SkColorFilter.cpp
  SkTime.cpp
  SkData.cpp
  SkMatrix.cpp
  SkMaskCache.cpp
  SkGeometry.cpp
  SkBitmap.cpp
  SkStrikeSpec.cpp
  SkCachedData.cpp
  SkPathMeasure.cpp
  SkPath.cpp
  SkPicture_none.cpp
  SkTLS.cpp
  SkNormalSource.cpp
  SkMultiPictureDraw.cpp
  SkColorSpace.cpp
  SkRecordedDrawable.cpp
  SkPicturePlayback.cpp
  SkScalar.cpp
  SkTextBlob.cpp
  SkDraw_vertices.cpp
  SkSpriteBlitter_RGB565.cpp
  SkRecords.cpp
  SkPictureFlat.cpp
  SkFlattenable.cpp
  SkCanvasPriv.cpp
  SkGpuBlurUtils.cpp
  SkQuadClipper.cpp
  SkPixelRef.cpp
  SkPictureImageGenerator.cpp
  SkRecordOpts.cpp
  SkDraw.cpp
  SkGlobalInitialization_core.cpp
  SkBlurMF.cpp
  SkRect.cpp
  SkMaskFilter.cpp
  SkConvertPixels.cpp
  SkForceCPlusPlusLinking.cpp
  SkLocalMatrixImageFilter.cpp
  SkEdgeBuilder.cpp
  SkLatticeIter.cpp
  SkPaintPriv.cpp
  SkTypeface_remote.cpp
  SkRecord.cpp
  SkRegion_path.cpp
  SkSurfaceCharacterization.cpp
  SkBitmapCache.cpp
  SkYUVASizeInfo.cpp
  SkXfermode.cpp
  SkCanvas.cpp
  SkMath.cpp
  SkBitmapProcState.cpp
  SkStroke.cpp
  SkRegion.cpp
  SkDeque.cpp
  SkRasterClip.cpp
  SkColorSpaceXformSteps.cpp
  SkScalerContext.cpp
  SkMaskBlurFilter.cpp
  SkPathRef.cpp
  SkICC.cpp
  SkPixmap.cpp
  SkString.cpp
  SkScan_Hairline.cpp
  SkSpriteBlitter_ARGB32.cpp
  SkEdgeClipper.cpp
  SkStream.cpp
  SkBigPicture.cpp
  SkStrike.cpp
  SkEdge.cpp
  SkPictureRecorder.cpp
  SkRWBuffer.cpp
  SkBlitter.cpp
  SkSpecialSurface.cpp
  SkMipMap.cpp
  SkVM.cpp
  SkFontStream.cpp
  SkColorFilter_Matrix.cpp
  SkMallocPixelRef.cpp
  SkStrokerPriv.cpp
  SkUnPreMultiply.cpp
  SkMatrix44.cpp
  )
set_prefix(SKIA_EFFECTS_SRC src/effects/
  imagefilters/SkBlurImageFilter.cpp
  imagefilters/SkMergeImageFilter.cpp
  imagefilters/SkMorphologyImageFilter.cpp
  imagefilters/SkArithmeticImageFilter.cpp
  imagefilters/SkDropShadowImageFilter.cpp
  imagefilters/SkComposeImageFilter.cpp
  imagefilters/SkAlphaThresholdFilter.cpp
  imagefilters/SkLightingImageFilter.cpp
  imagefilters/SkDisplacementMapEffect.cpp
  imagefilters/SkImageSource.cpp
  imagefilters/SkPictureImageFilter.cpp
  imagefilters/SkTileImageFilter.cpp
  imagefilters/SkXfermodeImageFilter.cpp
  imagefilters/SkOffsetImageFilter.cpp
  imagefilters/SkMatrixConvolutionImageFilter.cpp
  imagefilters/SkColorFilterImageFilter.cpp
  imagefilters/SkMagnifierImageFilter.cpp
  imagefilters/SkPaintImageFilter.cpp
  SkShaderMaskFilter.cpp
  SkEmbossMaskFilter.cpp
  SkColorMatrix.cpp
  SkHighContrastFilter.cpp
  SkTrimPathEffect.cpp
  SkCornerPathEffect.cpp
  SkOverdrawColorFilter.cpp
  SkDiscretePathEffect.cpp
  SkLayerDrawLooper.cpp
  SkLumaColorFilter.cpp
  SkDashPathEffect.cpp
  SkOpPathEffect.cpp
  Sk2DPathEffect.cpp
  SkColorMatrixFilter.cpp
  SkEmbossMask.cpp
  SkTableColorFilter.cpp
  SkTableMaskFilter.cpp
  SkPackBits.cpp
  Sk1DPathEffect.cpp
  )
set_prefix(SKIA_GPU_SRC src/gpu/
  ccpr/GrCCPathProcessor.cpp
  ccpr/GrCoverageCountingPathRenderer_none.cpp
  ccpr/GrVSCoverageProcessor.cpp
  ccpr/GrCCCubicShader.cpp
  ccpr/GrCCClipProcessor.cpp
  ccpr/GrCoverageCountingPathRenderer.cpp
  ccpr/GrOctoBounds.cpp
  ccpr/GrCCCoverageProcessor.cpp
  ccpr/GrCCStroker.cpp
  ccpr/GrCCFiller.cpp
  ccpr/GrCCFillGeometry.cpp
  ccpr/GrSampleMaskProcessor.cpp
  ccpr/GrCCConicShader.cpp
  ccpr/GrCCStrokeGeometry.cpp
  ccpr/GrCCQuadraticShader.cpp
  ccpr/GrCCDrawPathsOp.cpp
  ccpr/GrCCPerFlushResources.cpp
  ccpr/GrCCPathCache.cpp
  ccpr/GrCCClipPath.cpp
  ccpr/GrCCAtlas.cpp
  ccpr/GrStencilAtlasOp.cpp
  ccpr/GrGSCoverageProcessor.cpp
  effects/GrTextureDomain.cpp
  effects/GrMatrixConvolutionEffect.cpp
  effects/GrGaussianConvolutionFragmentProcessor.cpp
  effects/GrDistanceFieldGeoProc.cpp
  effects/GrSRGBEffect.cpp
  effects/GrConvexPolyEffect.cpp
  effects/GrYUVtoRGBEffect.cpp
  effects/GrCoverageSetOpXP.cpp
  effects/GrOvalEffect.cpp
  effects/GrRRectEffect.cpp
  effects/GrShadowGeoProc.cpp
  effects/GrXfermodeFragmentProcessor.cpp
  effects/GrBitmapTextGeoProc.cpp
  effects/GrPorterDuffXferProcessor.cpp
  effects/GrBicubicEffect.cpp
  effects/GrBezierEffect.cpp
  effects/GrSkSLFP.cpp
  effects/GrDisableColorXP.cpp
  effects/GrCustomXfermode.cpp
  geometry/GrPathUtils.cpp
  geometry/GrShape.cpp
  geometry/GrQuadUtils.cpp
  geometry/GrQuad.cpp
  glsl/GrGLSLProgramBuilder.cpp
  glsl/GrGLSLBlend.cpp
  glsl/GrGLSLFragmentShaderBuilder.cpp
  glsl/GrGLSLVarying.cpp
  glsl/GrGLSLGeometryProcessor.cpp
  glsl/GrGLSLUtil.cpp
  glsl/GrGLSLVertexGeoBuilder.cpp
  glsl/GrGLSLShaderBuilder.cpp
  glsl/GrGLSLXferProcessor.cpp
  glsl/GrGLSLPrimitiveProcessor.cpp
  glsl/GrGLSLFragmentProcessor.cpp
  glsl/GrGLSL.cpp
  glsl/GrGLSLProgramDataManager.cpp
  gradients/generated/GrUnrolledBinaryGradientColorizer.cpp
  gradients/generated/GrTwoPointConicalGradientLayout.cpp
  gradients/generated/GrTextureGradientColorizer.cpp
  gradients/generated/GrSweepGradientLayout.cpp
  gradients/generated/GrRadialGradientLayout.cpp
  gradients/generated/GrSingleIntervalGradientColorizer.cpp
  gradients/generated/GrTiledGradientEffect.cpp
  gradients/generated/GrClampedGradientEffect.cpp
  gradients/generated/GrLinearGradientLayout.cpp
  gradients/generated/GrDualIntervalGradientColorizer.cpp
  gradients/GrGradientShader.cpp
  gradients/GrGradientBitmapCache.cpp
  ops/GrClearOp.cpp
  ops/GrOvalOpFactory.cpp
  ops/GrAALinearizingConvexPathRenderer.cpp
  ops/GrDrawAtlasOp.cpp
  ops/GrDashOp.cpp
  ops/GrLatticeOp.cpp
  ops/GrOp.cpp
  ops/GrMeshDrawOp.cpp
  ops/GrSemaphoreOp.cpp
  ops/GrAAConvexPathRenderer.cpp
  ops/GrStencilAndCoverPathRenderer.cpp
  ops/GrTextureOp.cpp
  ops/GrSmallPathRenderer.cpp
  ops/GrAtlasTextOp.cpp
  ops/GrTessellatingPathRenderer.cpp
  ops/GrQuadPerEdgeAA.cpp
  ops/GrDefaultPathRenderer.cpp
  ops/GrTransferFromOp.cpp
  ops/GrCopySurfaceOp.cpp
  ops/GrSimpleMeshDrawOpHelper.cpp
  ops/GrAAHairLinePathRenderer.cpp
  ops/GrClearStencilClipOp.cpp
  ops/GrFillRRectOp.cpp
  ops/GrDebugMarkerOp.cpp
  ops/GrDrawableOp.cpp
  ops/GrDrawPathOp.cpp
  ops/GrRegionOp.cpp
  ops/GrStrokeRectOp.cpp
  ops/GrDrawVerticesOp.cpp
  ops/GrDashLinePathRenderer.cpp
  ops/GrShadowRRectOp.cpp
  ops/GrStencilPathOp.cpp
  ops/GrAAConvexTessellator.cpp
  ops/GrFillRectOp.cpp
  text/GrTextBlob.cpp
  text/GrTextContext.cpp
  text/GrAtlasManager.cpp
  text/GrTextBlobVertexRegenerator.cpp
  text/GrDistanceFieldAdjustTable.cpp
  text/GrStrikeCache.cpp
  text/GrTextBlobCache.cpp
  text/GrSDFMaskFilter.cpp
  GrImageTextureMaker.cpp
  GrSwizzle.cpp
  GrBackendTextureImageGenerator.cpp
  GrPathRendererChain.cpp
  GrSurfaceProxy.cpp
  GrStencilAttachment.cpp
  GrContext.cpp
  GrContext_Base.cpp
  GrPaint.cpp
  GrProcessor.cpp
  GrContextThreadSafeProxy.cpp
  GrReducedClip.cpp
  GrDeinstantiateProxyTracker.cpp
  GrRenderTargetProxy.cpp
  GrDrawOpTest.cpp
  SkGr.cpp
  GrStyle.cpp
  GrShaderVar.cpp
  GrBackendSurface.cpp
  GrPipeline.cpp
  GrSWMaskHelper.cpp
  GrResourceProvider.cpp
  GrProxyProvider.cpp
  GrBufferAllocPool.cpp
  GrTextureProducer.cpp
  GrCaps.cpp
  GrYUVProvider.cpp
  GrGpuBuffer.cpp
  GrStencilSettings.cpp
  GrAuditTrail.cpp
  GrOnFlushResourceProvider.cpp
  GrGpuCommandBuffer.cpp
  GrDefaultGeoProcFactory.cpp
  GrSoftwarePathRenderer.cpp
  GrFixedClip.cpp
  GrImageContext.cpp
  GrFragmentProcessor.cpp
  GrColorSpaceInfo.cpp
  GrGpu.cpp
  GrProcessorSet.cpp
  GrAHardwareBufferUtils.cpp
  GrSurfaceContext.cpp
  GrAHardwareBufferImageGenerator.cpp
  GrProcessorAnalysis.cpp
  GrProcessorUnitTest.cpp
  GrMemoryPool.cpp
  GrShaderUtils.cpp
  GrTextureContext.cpp
  GrPath.cpp
  GrDDLContext.cpp
  GrDriverBugWorkarounds.cpp
  GrRenderTargetOpList.cpp
  GrLegacyDirectContext.cpp
  GrGpuResource.cpp
  GrResourceAllocator.cpp
  GrRectanizer_pow2.cpp
  GrPathRendering.cpp
  GrDataUtils.cpp
  GrBlurUtils.cpp
  GrPrimitiveProcessor.cpp
  GrShaderCaps.cpp
  SkGpuDevice.cpp
  GrTestUtils.cpp
  GrRecordingContext.cpp
  GrDrawOpAtlas.cpp
  SkGpuDevice_drawTexture.cpp
  GrTexture.cpp
  GrDrawingManager.cpp
  GrSamplePatternDictionary.cpp
  GrResourceCache.cpp
  GrProgramDesc.cpp
  GrRenderTargetContext.cpp
  GrPathRendering_none.cpp
  GrPathProcessor.cpp
  GrColorSpaceXform.cpp
  GrRectanizer_skyline.cpp
  GrTextureProxy.cpp
  GrTessellator.cpp
  GrTextureOpList.cpp
  GrOpList.cpp
  GrOpFlushState.cpp
  GrPathRenderer.cpp
  GrTextureMaker.cpp
  GrRenderTarget.cpp
  GrTextureRenderTargetProxy.cpp
  GrClipStackClip.cpp
  GrDistanceFieldGenFromVector.cpp
  GrBitmapTextureMaker.cpp
  GrTextureAdjuster.cpp
  GrXferProcessor.cpp
  GrSurface.cpp
  GrContextPriv.cpp
  )
set_prefix(SKIA_GL_SRC src/gpu/gl/
  GrGLTextureRenderTarget.cpp
  GrGLTypesPriv.cpp
  GrGLCaps.cpp
  GrGLGLSL.cpp
  GrGLGpuCommandBuffer.cpp
  GrGLVertexArray.cpp
  GrGLPath.cpp
  GrGLBuffer.cpp
  GrGLPathRendering.cpp
  GrGLVaryingHandler.cpp
  GrGLAssembleHelpers.cpp
  GrGLProgram.cpp
  GrGLMakeNativeInterface_none.cpp
  GrGLAssembleGLESInterfaceAutogen.cpp
  GrGLInterfaceAutogen.cpp
  GrGLTexture.cpp
  GrGLUniformHandler.cpp
  GrGLUtil.cpp
  GrGLAssembleInterface.cpp
  GrGLAssembleGLInterfaceAutogen.cpp
  GrGLSemaphore.cpp
  GrGLExtensions.cpp
  GrGLGpu.cpp
  GrGLAssembleWebGLInterfaceAutogen.cpp
  GrGLStencilAttachment.cpp
  GrGLGpuProgramCache.cpp
  GrGLProgramDataManager.cpp
  GrGLContext.cpp
  GrGLRenderTarget.cpp
  )
set_prefix(SKIA_VK_SRC src/gpu/vk/
  GrVkPipeline.cpp
  GrVkPipelineLayout.cpp
  GrVkPipelineStateBuilder.cpp
  GrVkResourceProvider.cpp
  GrVkExtensions.cpp
  GrVkSamplerYcbcrConversion.cpp
  GrVkImageView.cpp
  GrVkTypesPriv.cpp
  GrVkBufferView.cpp
  GrVkTexture.cpp
  GrVkSemaphore.cpp
  GrVkCommandPool.cpp
  GrVkPipelineState.cpp
  GrVkBuffer.cpp
  GrVkUtil.cpp
  GrVkGpu.cpp
  GrVkPipelineStateDataManager.cpp
  GrVkSecondaryCBDrawContext.cpp
  GrVkMemory.cpp
  GrVkFramebuffer.cpp
  GrVkAMDMemoryAllocator.cpp
  GrVkRenderPass.cpp
  GrVkUniformHandler.cpp
  GrVkSampler.cpp
  GrVkUniformBuffer.cpp
  GrVkStencilAttachment.cpp
  GrVkCommandBuffer.cpp
  GrVkDescriptorPool.cpp
  GrVkPipelineStateCache.cpp
  GrVkInterface.cpp
  GrVkTransferBuffer.cpp
  GrVkImage.cpp
  GrVkGpuCommandBuffer.cpp
  GrVkIndexBuffer.cpp
  GrVkTextureRenderTarget.cpp
  GrVkVertexBuffer.cpp
  GrVkDescriptorSetManager.cpp
  GrVkCaps.cpp
  GrVkVaryingHandler.cpp
  GrVkDescriptorSet.cpp
  GrVkRenderTarget.cpp
  )
set_prefix(SKIA_IMAGE_SRC src/image/
  SkImage_Raster.cpp
  SkImage_GpuYUVA.cpp
  SkSurface_Raster.cpp
  SkSurface.cpp
  SkImage_Gpu.cpp
  SkImage.cpp
  SkImage_Lazy.cpp
  SkImage_GpuBase.cpp
  SkSurface_Gpu.cpp
  )
set_prefix(SKIA_OPTS_SRC src/opts/
  SkOpts_avx.cpp
  SkOpts_ssse3.cpp
  SkOpts_sse42.cpp
  SkOpts_crc32.cpp
  SkOpts_sse41.cpp
  SkOpts_hsw.cpp
  )
set_prefix(SKIA_PATHOPS_SRC src/pathops/
  SkPathOpsRect.cpp
  SkPathOpsDebug.cpp
  SkOpBuilder.cpp
  SkDCubicToQuads.cpp
  SkDConicLineIntersection.cpp
  SkOpCubicHull.cpp
  SkDCubicLineIntersection.cpp
  SkDQuadLineIntersection.cpp
  SkReduceOrder.cpp
  SkPathOpsTightBounds.cpp
  SkPathOpsLine.cpp
  SkOpContour.cpp
  SkPathOpsCommon.cpp
  SkIntersections.cpp
  SkPathWriter.cpp
  SkPathOpsConic.cpp
  SkOpSegment.cpp
  SkPathOpsCubic.cpp
  SkPathOpsWinding.cpp
  SkOpEdgeBuilder.cpp
  SkOpAngle.cpp
  SkPathOpsQuad.cpp
  SkOpCoincidence.cpp
  SkPathOpsSimplify.cpp
  SkAddIntersections.cpp
  SkDLineIntersection.cpp
  SkPathOpsAsWinding.cpp
  SkPathOpsTypes.cpp
  SkPathOpsCurve.cpp
  SkOpSpan.cpp
  SkPathOpsTSect.cpp
  SkPathOpsOp.cpp
  )
set_prefix(SKIA_SFNT_SRC src/sfnt/
  SkOTTable_name.cpp
  SkOTUtils.cpp
  )
set_prefix(SKIA_SHADERS_SRC src/shaders/
  gradients/SkSweepGradient.cpp
  gradients/SkLinearGradient.cpp
  gradients/SkTwoPointConicalGradient.cpp
  gradients/SkRadialGradient.cpp
  gradients/SkGradientShader.cpp
  gradients/Sk4fLinearGradient.cpp
  gradients/Sk4fGradientBase.cpp
  SkPictureShader.cpp
  SkComposeShader.cpp
  SkColorShader.cpp
  SkLocalMatrixShader.cpp
  SkColorFilterShader.cpp
  SkRTShader.cpp
  SkShader.cpp
  SkLightingShader.cpp
  SkLights.cpp
  SkImageShader.cpp
  SkBitmapProcShader.cpp
  SkPerlinNoiseShader.cpp
  )
set_prefix(SKIA_SKSL_SRC src/sksl/
  ir/SkSLVariableReference.cpp
  ir/SkSLSymbolTable.cpp
  ir/SkSLType.cpp
  ir/SkSLSetting.cpp
  SkSLASTNode.cpp
  SkSLMain.cpp
  SkSLParser.cpp
  SkSLLexer.cpp
  SkSLCPPCodeGenerator.cpp
  SkSLByteCodeGenerator.cpp
  SkSLHCodeGenerator.cpp
  SkSLMetalCodeGenerator.cpp
  SkSLCompiler.cpp
  SkSLIRGenerator.cpp
  SkSLByteCode.cpp
  SkSLUtil.cpp
  SkSLCPPUniformCTypes.cpp
  SkSLSPIRVCodeGenerator.cpp
  SkSLGLSLCodeGenerator.cpp
  SkSLPipelineStageCodeGenerator.cpp
  SkSLCFGGenerator.cpp
  SkSLJIT.cpp
  SkSLOutputStream.cpp
  SkSLString.cpp
  )
set_prefix(SKIA_UTILS_SRC src/utils/
  SkAnimCodecPlayer.cpp
  SkPatchUtils.cpp
  SkMultiPictureDocument.cpp
  SkNWayCanvas.cpp
  SkEventTracer.cpp
# SkLuaCanvas.cpp
  SkCamera.cpp
  SkJSONWriter.cpp
  SkShadowTessellator.cpp
  SkThreadUtils_pthread.cpp
  SkParse.cpp
# SkLua.cpp
  SkFrontBufferedStream.cpp
  SkPaintFilterCanvas.cpp
  SkWhitelistTypefaces.cpp
  Sk3D.cpp
  SkFloatToDecimal.cpp
  SkCanvasStack.cpp
  SkCanvasStateUtils.cpp
  SkThreadUtils_win.cpp
  SkBase64.cpp
  SkDashPath.cpp
  SkParseColor.cpp
  SkJSON.cpp
  SkMatrix22.cpp
  SkTextUtils.cpp
  SkPolyUtils.cpp
  SkOSPath.cpp
  SkParsePath.cpp
  SkShadowUtils.cpp
  SkUTF.cpp
  SkInterpolator.cpp
  SkNullCanvas.cpp
#  SkShaperJSONWriter.cpp
  SkCharToGlyphCache.cpp
  )
set_prefix(SKIA_THIRDPARTY_SRC third_party/
  etc1/etc1.cpp
  )

if(APPLE)
  add_definitions(-DSK_USE_POSIX_THREADS)
  include_directories(include/utils/mac)
  include_directories(src/utils/mac)

  set_prefix(SKIA_GL_PLATFORM_SRC src/gpu/gl/mac/
    GrGLCreateNativeInterface_mac.cpp
    )

  set_prefix(SKIA_PORTS_SRC src/ports/
    SkDebug_stdio.cpp
    SkFontHost_mac.cpp
    SkGlobalInitialization_default.cpp
    SkImageDecoder_empty.cpp
    SkMemory_malloc.cpp
    SkOSFile_posix.cpp
    SkOSFile_stdio.cpp
    SkTLS_pthread.cpp
    )

  set(SKIA_FONTS_SRC "")

  set_prefix(SKIA_UTILS_PLATFORM_SRC src/utils/mac/
    SkCreateCGImageRef.cpp
    SkStream_mac.cpp
    )
endif() # MacOS X

if(WIN32)
  add_definitions(-D_WIN32_WINNT=0x0600 -DSK_BUILD_FOR_WIN32)
  include_directories(include/utils/win)
  include_directories(src/utils/win)

  if (CMAKE_COMPILER_IS_GNUCC)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=gnu++0x -Wno-deprecated-declarations")
    include_directories(/mingw64/include/freetype2)
  endif()

  set_prefix(SKIA_GL_PLATFORM_SRC src/gpu/gl/win/
    GrGLCreateNativeInterface_win.cpp
    )

  set_prefix(SKIA_PORTS_SRC src/ports/
    SkDebug_win.cpp
    SkFontHost_win.cpp
    SkGlobalInitialization_default.cpp
    SkImageDecoder_empty.cpp
    SkMemory_malloc.cpp
    SkOSFile_win.cpp
    SkOSFile_stdio.cpp
    SkTLS_win.cpp
    )

  set_prefix(SKIA_UTILS_PLATFORM_SRC src/utils/win/
    SkAutoCoInitialize.cpp
    SkHRESULT.cpp
    SkIStream.cpp
    SkWGL_win.cpp
    )

  add_definitions(-DSK_INCLUDE_FREETYPE)
  set_prefix(SKIA_PORTS_2_SRC src/ports/
    SkFontConfigInterface_direct.cpp
    SkFontHost_FreeType.cpp
    SkFontHost_FreeType_common.cpp
    SkFontHost_fontconfig.cpp
    )

  set_prefix(SKIA_FONTS_SRC src/fonts/
    SkFontMgr_fontconfig.cpp
    )
endif() # Windows

#message(STATUS "Building for target: $ENV{TARGET}")

if($ENV{TARGET} MATCHES ".*android.*")
  add_definitions(-DSK_BUILD_FOR_ANDROID -DEGL_EGLEXT_PROTOTYPES)
  include_directories(platform_tools/android/third_party/cpufeatures)

  # FIXME: The skia version we updated to doesn't have android FontMgr class.
  # However, this was added to skia upstream recently, so next time we update
  # skia this should be removed and have the android FontMgr source file added
  # to the makefile.
  add_definitions(-DSK_FONTHOST_DOES_NOT_USE_FONTMGR=1)

  set_prefix(SKIA_GL_PLATFORM_SRC src/gpu/gl/android/
    GrGLCreateNativeInterface_android.cpp
    )

  set_prefix(SKIA_PORTS_SRC src/ports/
    SkDebug_android.cpp
    SkFontConfigInterface_android.cpp
    SkFontConfigParser_android.cpp
    SkFontHost_FreeType.cpp
    SkFontHost_FreeType_common.cpp
    SkFontHost_fontconfig.cpp
    SkGlobalInitialization_default.cpp
    SkImageDecoder_empty.cpp
    SkMemory_malloc.cpp
    SkOSFile_posix.cpp
    SkOSFile_stdio.cpp
    SkTLS_pthread.cpp
    )

  set_prefix(SKIA_UTILS_PLATFORM_SRC platform_tools/android/third_party/cpufeatures/
    cpu-features.c
    )
elseif(${CMAKE_SYSTEM_NAME} STREQUAL "Linux")
  set_prefix(SKIA_GL_PLATFORM_SRC src/gpu/gl/glx/
    GrGLMakeNativeInterface_glx.cpp
    )

  set_prefix(SKIA_PORTS_SRC src/ports/
    SkDebug_stdio.cpp
    SkFontConfigInterface_direct_factory.cpp
    SkFontConfigInterface_direct.cpp
    SkFontHost_FreeType.cpp
    SkFontHost_FreeType_common.cpp
  #  SkFontMgr_empty_factory.cpp
    SkFontMgr_fontconfig_factory.cpp
    SkFontMgr_fontconfig.cpp
    SkFontMgr_FontConfigInterface_factory.cpp
    SkFontMgr_FontConfigInterface.cpp
    SkGlobalInitialization_default.cpp
    SkImageGenerator_none.cpp
    SkMemory_malloc.cpp
    SkOSFile_posix.cpp
    SkOSFile_stdio.cpp
    SkTLS_pthread.cpp
    )

#  set_prefix(SKIA_FONTS_SRC src/fonts/
#    SkFontMgr_fontconfig.cpp
#    )
endif()

set(SKIA_SRC
#  src/skia-c.cpp
  ${SKIA_CORE_SRC}
  ${SKIA_EFFECTS_SRC}
#  ${SKIA_FONTS_SRC}
  ${SKIA_GPU_SRC}
  ${SKIA_GL_SRC}
  ${SKIA_GL_PLATFORM_SRC}
  ${SKIA_VK_SRC}
  ${SKIA_IMAGE_SRC}
  ${SKIA_PATHOPS_SRC}
  ${SKIA_PORTS_SRC}
  ${SKIA_PORTS_2_SRC}
  ${SKIA_SFNT_SRC}
  ${SKIA_SHADERS_SRC}
  ${SKIA_THIRDPARTY_SRC}
  ${SKIA_UTILS_SRC}
  ${SKIA_UTILS_PLATFORM_SRC}
  )

add_library(skia STATIC ${SKIA_SRC})
target_link_libraries(skia freetype)
add_dependencies(skia internal_freetype)
install(TARGETS skia ARCHIVE DESTINATION lib)
install(DIRECTORY include/ DESTINATION include)
#install(DIRECTORY src/ DESTINATION src)
