/**
 * @jest-environment jsdom
 * @jest-environment-options {"url": "https://jestjs.io/"}
 */

import { Router } from 'html5-history-router'
export const router = new Router()

import {
  formSubmitHook,
  formInputEventHook,
  anchorClickEventHook,
  hookTransitionElements,
} from './htmlHandlers'

let event
beforeEach(() => {
  event = jest.fn()
  event.preventDefault = jest.fn()
  jest.spyOn(event, 'preventDefault')
})

describe('formSubmitHook', () => {
  let request

  beforeEach(() => {
    const form = document.createElement('form')
    form.method = 'put'
    form.action = '/action'
    form.innerHTML =
      '<input type="hidden" name="param1" value="value1">' +
      '<input type="hidden" name="param2" value="value2">'
    event.target = form

    request = jest.fn()

    formSubmitHook(event, request)
  })

  it('calls preventDefault', () => {
    expect(event.preventDefault).toBeCalled()
  })

  it('requests with form content', () => {
    expect(request).toBeCalledWith(
      'put',
      '/action',
      'param1=value1&param2=value2'
    )
  })
})

describe('formInputEventHook', () => {
  let form

  beforeEach(() => {
    form = { dispatchEvent: jest.fn() }
    jest.spyOn(form, 'dispatchEvent')

    formInputEventHook(event, form)
  })

  it('calls preventDefault', () => {
    expect(event.preventDefault).toBeCalled()
  })

  it('dispatches an event', () => {
    expect(form.dispatchEvent).toBeCalledWith(
      new Event('submit', { cancelable: true })
    )
  })
})

describe('anchorClickEventHook', () => {
  beforeEach(() => {
    event.target = { href: '/destination' }
    anchorClickEventHook(event)
  })

  it('calls preventDefault', () => {
    expect(event.preventDefault).toBeCalled()
  })

  it('pushstates the href', () => {
    expect(location.href).toEqual('https://jestjs.io/destination')
  })
})

describe('hookTransitionElements', () => {
  let body, elem

  beforeEach(() => {
    body = document.createElement('body')
  })

  describe('anchor handling', () => {
    describe('relative path', () => {
      beforeEach(() => {
        elem = document.createElement('a')
        elem.href = '/destination'
        body.appendChild(elem)
      })

      it('set hooks to relative anchors', () => {
        hookTransitionElements(body)
        elem.dispatchEvent(new Event('click'))

        expect(location.href).toEqual('https://jestjs.io/destination')
      })
    })

    describe('absolute path', () => {
      beforeEach(() => {
        elem = document.createElement('a')
        elem.href = 'http://example.com/'
        body.appendChild(elem)
      })

      it('set hooks to relative anchors', () => {
        hookTransitionElements(body)
        elem.dispatchEvent(new Event('click'))

        expect(location.href).not.toEqual('http://example.com/')
      })
    })
  })

  describe('form handling', () => {
    describe('submit hook', () => {
      beforeEach(() => {
        elem = document.createElement('form')
        elem.action = '/form'
        elem.method = 'post'
        body.appendChild(elem)
      })

      it('sets hooks to forms', () => {
        const request = jest.fn()
        hookTransitionElements(body, request)
        elem.dispatchEvent(new Event('submit', { target: elem }))

        expect(request).toBeCalledWith('post', '/form', '')
      })
    })

    describe('children event hook', () => {
      let request

      beforeEach(() => {
        const form = document.createElement('form')
        form.action = '/form2'
        form.method = 'post'
        body.appendChild(form)

        elem = document.createElement('input')
        elem.type = 'input'
        elem.name = 'i1'
        elem.value = 'v1'
        form.appendChild(elem)

        request = jest.fn()
      })

      it('wont set hooks', () => {
        hookTransitionElements(body, request)
        elem.dispatchEvent(new Event('blur'))
        expect(request).not.toBeCalled()
      })

      describe('with data-', () => {
        beforeEach(() => {
          elem.setAttribute('data-bormashino-submit-on', 'blur')
          hookTransitionElements(body, request)
          elem.dispatchEvent(new Event('blur'))
        })

        it('sets hooks to elements with "data-bormashino-submit-on"', () => {
          expect(request).toBeCalled()
        })
      })
    })
  })
})
