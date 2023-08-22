import * as THREE from 'three'
import { useTresContext } from '@tresjs/core'

export const useFBO = (width?: number, height?: number, dpr = 500) => {
  const state = useTresContext()
  const renderTarget = shallowRef<THREE.WebGLRenderTarget>(new THREE.WebGLRenderTarget(10 * dpr, 10 * dpr))
  
  const size = computed(() => {
    const sizes = state.sizes
    const _width = width ? width * dpr : sizes?.width.value || 10 * dpr
    const _height = height ? height * dpr : sizes?.height.value || 10 * dpr
    return {
      width: _width,
      height: _height,
    }
  })
  
  watch(size, val => {
    renderTarget.value = new THREE.WebGLRenderTarget(val.width, val.height)
  })

  onBeforeUnmount(() => {
    renderTarget.value.dispose()
  })
  
  return renderTarget
}