Dust = require 'dustjs'
$ = require 'jquery'
_ = require 'underscore'
{EventEmitter2} = require 'EventEmitter2'
ServerEvents = require 'sockevents'

Dust.onLoad = (name, out) ->
  await require ["views/#{name}"], defer view
  view Dust
  out null, Dust.cache[name]

UUID = ->
  'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace /[xy]/g, (c) ->
    r = Math.random()*16|0
    v = if c is 'x' then r else (r&0x3|0x8)
    return v.toString 16

Base = Dust.makeBase
  controllers: []
  Controller: (chunk, context, bodies, params) -> chunk.map (chunk) ->
    if !SERVER?
      uuid = UUID()
      handler = (data) ->
        await require ["controllers/#{params.type}"], defer Controller
        context.get('controllers').push ->
          controller = new Controller uuid, params.type, ServerEvents, LocalEvents
          controller.data = data
          controller.bind()
        context = context.push _(data).extend id:uuid
        chunk.render(bodies.block, context).end()
      if params.listen
        ServerEvents.once params.listen, handler
      else
        handler {}
    else
      handler = (data) ->
        context = context.push data
        chunk.render(bodies.block, context).end()
      if params.listen
        ServerEvents.once params.listen, handler
      else
        handler {}
    if params.emit
      ServerEvents.emit params.emit

class Controller extends EventEmitter2
  constructor: (@uuid, @template, @ServerEvents, @LocalEvents) ->
    @el = $ "[data-controller-id=#{@uuid}]"
  
  bindings: {}
  events: {}
  
  bind: ->
    for event, handler of @events
      [ev, selector...] = event.split ' '
      selector = selector.join(' ')
      @el.undelegate selector, event
      @el.delegate selector, event, _(@[handler]).bind(@)

  render: ->
    require ["views/#{template}"], defer()
    await dust.render template, @data, defer err, html

module.exports =
  Controller: Controller
  Base: Base