Dust = require 'dustjs'
$ = require 'jquery'
_ = require 'underscore'
Emitter = require 'emitter'

class Controller extends Emitter
  constructor: (node) ->
    @node = node
  
  bindings: {}
  events: {}
  
  render: (cb, node) ->
    if @tagName?
      @el = $("<#{@tagName}></#{@tagName}>")
    else
      @el = $('<div></div>')
    if @className?
      @el.addClass @className
    if @id?
      @el.attr 'id', @id
    node ?= @node
    if @template?
      if node.raw?
        node = node.raw
      await Dust.render @template, (node.toJSON?() or node), defer err, html
    @el.empty().html html
    for event, handler of @events
      [ev, selector...] = event.split ' '
      selector = selector.join(' ')
      @el.undelegate selector, event
      @el.delegate selector, event, _(@[handler]).bind(@)
    if cb? then cb.call @

module.exports = Controller