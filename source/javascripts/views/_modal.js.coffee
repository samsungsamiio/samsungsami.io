class App.Views.Modal extends Backbone.View
  className: 'modal-overlay'
  events:
    'click': 'closeModal'
    'click .modal-close': 'closeModal'
    'click .modal-content': 'handleClick'

  initialize: ({content})->
    @content = content || ''
    @render()

  handleClick: (e)->
    e.stopPropagation()

  closeModal: (e)->
    e.preventDefault()
    @remove()

  render: ->
    @$el
      .html(ich.modal({
        content: @content
      }))
      .appendTo('body')
    @
