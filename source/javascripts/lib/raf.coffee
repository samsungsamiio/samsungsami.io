window.raf = window.requestAnimationFrame ||
  window.webkitRequestAnimationFrame ||
  window.mozRequestAnimationFrame ||
  window.msRequestAnimationFrame ||
  window.oRequestAnimationFrame ||
  # IE Fallback, you can even fallback to onscroll
  (callback)->
    window.setTimeout(callback, 1000/60)
