const addedHeadTags = []

export const applyServerResult = (src, target, router) => {
  // 現在フォーカスが当たっている要素のインデックスを取得
  const focusedPos = Array.from(
    document.querySelectorAll('input,textarea,button')
  ).indexOf(document.activeElement)

  switch (src[0]) {
    case 200:
      target.innerHTML = src[2][0]

      // 前回headに入れたタグを消す
      addedHeadTags.forEach((e) => e.remove())

      // headを更新
      const head = document.querySelector('head')
      const parser = new DOMParser()
      const doc = parser.parseFromString(src[2][0], 'text/html')
      const headTemplate = doc.querySelectorAll('template.bormashino-head')
      headTemplate.forEach((t) => {
        Array.from(t.content.children).forEach((e) => {
          // 古い<title>を除去
          if (e.tagName == 'TITLE')
            head.querySelectorAll('title').forEach((t1) => t1.remove())
          head.appendChild(e)
          addedHeadTags.push(e) // 次回更新時に消す
        })
      })

      // フォーカスを当て直す
      if (focusedPos > -1) {
        const target = Array.from(
          document.querySelectorAll('input,textarea,button')
        )[focusedPos]
        if (target) target.focus()
      }
      // 更新イベントを発生させる
      target.dispatchEvent(new Event('bormashino:updated'))

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
