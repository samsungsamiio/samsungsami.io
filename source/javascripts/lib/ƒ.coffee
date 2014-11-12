window['ƒ'] = (behaviorName='', scope)->
  selectors = for _, name of behaviorName.split(', ') when behaviorName isnt ''
    "._#{name}"
  document.querySelectorAll(selectors.join(", "))
