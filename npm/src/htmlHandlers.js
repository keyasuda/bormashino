import { Router } from 'html5-history-router'
export const router = new Router()

export const formSubmitHook = (e, request) => {
  e.preventDefault()
  const form = e.target
  const action = form.action
  const method = form.attributes['method'].value
  const payload = new URLSearchParams(new FormData(form)).toString()

  request(method, new URL(action).pathname, payload)
}

export const formInputEventHook = (e, form) => {
  e.preventDefault()
  form.dispatchEvent(new Event('submit', { cancelable: true }))
}

export const anchorClickEventHook = (e) => {
  e.preventDefault()
  router.pushState(e.target.href)
}

export const hookTransitionElements = (doc, request) => {
  doc.querySelectorAll('a').forEach((a) => {
    if (a.href.startsWith(location.origin)) {
      a.addEventListener('click', anchorClickEventHook, false)
    }
  })

  const submitHook = (e) => formSubmitHook(e, request)
  doc.querySelectorAll('form').forEach((f) => {
    f.addEventListener('submit', submitHook, false)

    f.querySelectorAll('[data-bormashino-submit-on]').forEach((i) => {
      const eventAttr = i.attributes['data-bormashino-submit-on']
      if (eventAttr) {
        i.addEventListener(
          eventAttr.value,
          (e) => formInputEventHook(e, f),
          false
        )
      }
    })
  })
}
