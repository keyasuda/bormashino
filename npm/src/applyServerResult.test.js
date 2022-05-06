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
