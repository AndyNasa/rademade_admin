currentClass = []

initSelect = ->
  console.log 'Initializing select...'
  $(".select-wrapper input[type='hidden']").each ->
    initItem $(this)
    

initItem = ($item) ->
  url         = $item.data('relListUrl')
  isMultiple  = $item.data('relMultiple')

  $item.select2(
    multiple : isMultiple
    placeholder : 'Enter search phrase'

    initSelection : (element, callback) ->
      ids = element.val().replace(/\s*/g, '').split(',')
      $.getJSON(url, {search : {id_in : ids}}).done (data) ->
        data = if isMultiple then data else data[0]
        $item.select2('enable', true)
        callback(data)
        addTable($item) if isMultiple
        hideTags()

    ajax :
      url : url
      dataType : 'json'
      data : (term) -> {q: term}
      results : (data) -> {results: data}
  ).on 'change', (e) ->
    $select = $(this)
    $table = $select.siblings('.select2-items-list')
    addTable($select) if $table.length is 0
    addItem(e.added, $table)
    hideTags()
  $item.select2('enable', false) if $item.val().length > 0

hideTags = ->
  $('.select2-search-choice').hide()

addTable = ($item) ->
  $parent = $item.parent()
  $parent.children('.select2-items-list').remove()
  $parent.append('<ul class="select2-items-list"></ul>')

  $table = $parent.children('.select2-items-list')

  $($item.select2('data')).each ->
    addItem this, $table

  $table.sortable
    stop : -> changeSelectValue($table, $item)

  $table.disableSelection()

addItem = (item, $table) ->
  $table.append([
    '<li data-id=', item.id, '>'
      '<span>', item.text, '</span>'
      '<button data-edit="', item.edit_url, '">Edit</button>'
      '<button data-remove>Delete</button>'
    '</li>'
  ].join(''))

  $('li[data-id="' + item.id + '"] [data-remove]').on 'click', (e) ->
    removeItem(item.id, $table) if confirm 'Вы действительно хотите удалить данную модель?'

removeItem = (id, $table) ->
  $table.children('li[data-id="' + id + '"]').remove()
  changeSelectValue $table, $table.siblings('.select-wrapper')

changeSelectValue = ($table, $input) ->
  itemsList = []

  $table.children('li').each ->
    $li = $(this)
    itemsList.push({ id : $li.data('id'), text : $li.text() })

  $input.select2('data', itemsList)
  hideTags()

getId = (data) ->
  if data.data._id
    return data.data._id.$oid
  else
    return data.data.id

selectOnSubmit = (e, modelClassName, data) ->
  dataId = getId(data)
  $select = $(".select-wrapper [data-rel-class='" + modelClassName + "']")
  newData = []
  if $select.data('relMultiple')
    newData.push($select.val()) if $select.val()
    newData.push(dataId)
  else
    newData = dataId

  $select.select2('destroy')
  $select.val(newData)
  initItem($select)

selectCurrent = (event, data) ->
  currentClass.push(data)


$ ->
  $(document)
    .on('ready page:load init-select', initSelect)
    .on('form-saved', selectOnSubmit)