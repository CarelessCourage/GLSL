export const useFBO = () => {
  const tres = useTres()
  const renderer = useRenderer({
    antialias: true,
    alpha: true,
  })

  return {
    renderer,
    tres
  }
}
