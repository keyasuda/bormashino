export const applyServerResult = (src, target, router) => {
  // 現在フォーカスが当たっている要素のインデックスを取得
  const focusedPos = Array.from(
    document.querySelectorAll('input,textarea,button')
  ).indexOf(document.activeElement)

  switch (src[0]) {
    case 200:
      target.innerHTML = src[2][0]

      // フォーカスを当て直す
      if (focusedPos > -1) {
        const target = Array.from(
          document.querySelectorAll('input,textarea,button')
        )[focusedPos]
        if (target) target.focus()
      }
      return true

    case 302:
      const loc = new URL(src[1]['Location'])

      if (loc.host == 'example.com:0') {
        const path = loc.pathname + loc.search
        router.pushState(path)
      } else {
        location.href = src[1]['Location']
      }
      return false

    default:
      console.error(src)
      target.innerHTML = src[2][0]
      return true
  }
}
