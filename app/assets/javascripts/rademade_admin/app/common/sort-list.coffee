swapDirection = (sortDirection) ->
  if sortDirection is 'asc' then 'desc' else 'asc'

getUrlParams = ->
  pl = /\+/g
  search = /([^&=]+)=?([^&]*)/g

  decode = (s) ->
    decodeURIComponent s.replace(pl, ' ')

  query = window.location.search.substring(1)
  urlParams = {}
  urlParams[decode(match[1])] = decode(match[2]) while match = search.exec(query)
  urlParams

paramsToString = (params) ->
  str = []
  for param of params
    str.push("#{param}=#{params[param]}")
  str.join('&')

initSorting = ->
  params = getUrlParams()

  params['direction'] ?= 'asc'

  $('[data-sort-column]').click ->
    column = $(this).data('sortColumn')
    params['direction'] = if column is params['sort']
      swapDirection(params['direction'])
    else
      'asc'

    params['sort'] = column
    params['page'] ?= '1'

    query_string = paramsToString(params)

    Turbolinks.visit("#{window.location.pathname}?#{query_string}")

$ ->
  $(document).on('ready page:load', initSorting)