/**
 * @jest-environment jsdom
 * @jest-environment-options {"url": "https://jestjs.io/"}
 */

import { Router } from 'html5-history-router'
export const router = new Router()
import { applyServerResult } from './applyServerResult.js'

describe('applyServerResult', () => {
  let target, content, ret, updateEventListener
  beforeEach(() => {
    target = document.createElement('div')
    target.innerHTML =
      '<div>content<input type="text" name="i1" value=""></div>'
    target.querySelector('input').focus()
    updateEventListener = jest.fn()
    target.addEventListener('bormashino:updated', updateEventListener)
  })

  describe('200', () => {
    beforeEach(() => {
      content = [
        200,
        {},
        ['<div>200 content <input type="text" name="i1" value=""></div>'],
      ]
      ret = applyServerResult(content, target, router)
    })

    it('replaces target content', () => {
      expect(target.innerHTML).toEqual(content[2][0])
    })

    it('returns true', () => {
      expect(ret).toEqual(true)
    })

    it('fires bormashino:updated', () => {
      expect(updateEventListener).toBeCalled()
    })

    describe('updating head', () => {
      let head
      beforeEach(() => {
        head = document.querySelector('head')
        const title = document.createElement('title')
        title.innerHTML = 'initial title'
        head.appendChild(title)

        applyServerResult(
          [
            200,
            {},
            [
              '<div>body</div><template class="bormashino-head"><title>new title</title><meta content="foo"></template>',
            ],
          ],
          target,
          router
        )
      })

      it('updates title', () => {
        expect(head.querySelectorAll('title').length).toEqual(1)
        expect(head.querySelector('title').innerHTML).toEqual('new title')
      })

      it('adds new meta', () => {
        expect(head.querySelector('meta').getAttribute('content')).toEqual(
          'foo'
        )
      })

      it('wont put head into body', () => {
        expect(target.querySelectorAll('head').length).toEqual(0)
      })

      describe('2nd update', () => {
        beforeEach(() => {
          applyServerResult(
            [
              200,
              {},
              [
                '<div>body></div><template class="bormashino-head"><title>new title 2</title><meta content="bar"><meta content="bar2"></template>',
              ],
            ],
            target,
            router
          )
          head = document.querySelector('head')
        })

        it('updates title', () => {
          expect(head.querySelectorAll('title').length).toEqual(1)
          expect(head.querySelector('title').innerHTML).toEqual('new title 2')
        })

        it('removes old meta', () => {
          expect(head.querySelectorAll('meta[content="foo"]').length).toEqual(0)
        })

        it('adds new metas', () => {
          expect(head.querySelectorAll('meta').length).toEqual(2)
        })
      })
    })
  })

  describe('302 relative location', () => {
    beforeEach(() => {
      content = [302, { Location: 'http://example.com:0/location' }, []]
      ret = applyServerResult(content, target, router)
    })

    it('pushstates the location', () => {
      expect(location.href).toEqual('https://jestjs.io/location')
    })

    it('returns true', () => {
      expect(ret).toEqual(false)
    })

    it('doesnt fire bormashino:updated', () => {
      expect(updateEventListener).not.toBeCalled()
    })
  })

  describe('302 absolute location', () => {
    beforeEach(() => {
      delete window.location
      window.location = { assign: jest.fn() }

      content = [302, { Location: 'http://absolute.example.com/location' }, []]

      ret = applyServerResult(content, target, router)
    })

    it('navigates to the location', () => {
      expect(location.href).toEqual(content[1]['Location'])
    })

    it('returns true', () => {
      expect(ret).toEqual(false)
    })
  })

  describe('unknown', () => {
    beforeEach(() => {
      content = [404, {}, ['<div>404 content</div>']]
      ret = applyServerResult(content, target, router)
    })

    it('replaces target content', () => {
      expect(target.innerHTML).toEqual(content[2][0])
    })

    it('returns true', () => {
      expect(ret).toEqual(true)
    })

    it('doesnt fire bormashino:updated', () => {
      expect(updateEventListener).not.toBeCalled()
    })
  })
})
