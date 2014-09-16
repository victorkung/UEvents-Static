window.Events = {

  last_date: new Date("April 18, 1993")

  params: {}

  setSchoolParams: ->
    Events.params['school_id'] = $('#school-select option:selected').attr('data-school-id');

  setCalendarParams: ->
    if $('.calendar .select').length > 0
      date = $('.calendar .select')[0].dataset.date
      Events.params['day'] = date.substring(8, 10)
      Events.params['month'] = date.substring(5, 7)
      Events.params['year'] = date.substring(0, 4)
    else
      delete(Events.params['day'])
      delete(Events.params['month'])
      delete(Events.params['year'])

  setSearchParams: ->
    query = $('#q_title_cont').val()
    Events.params['q'] = {'title_cont': query}

  setFilterParams: ->
    if $('.search-tags tr.tag-filter.select').length > 0
      tagName = $('.search-tags tr.tag-filter.select').attr('data-tag-name')
      Events.params['filter'] = tagName if !!tagName

  filterList: ->
    $('.loading-gif').show()
    Events.setCalendarParams()
    Events.setSearchParams()
    Events.setFilterParams()
    Events.setSchoolParams()
    Events.ajaxRequest('/events', Events.params)
    Event.params = {}

  setApprovalParams: ->
    approval_selection = $('nav li.select').children()[0].innerHTML
    if approval_selection == "All Events"
      return
    else if approval_selection == "Approved"
      Events.params['is_approved'] = true
    else if approval_selection == "Unapproved"
      Events.params['is_approved'] = false

  filterAdminList: ->
    $('.loading-gif').show()
    Events.setCalendarParams()
    Events.setSearchParams()
    Events.setApprovalParams()
    Events.ajaxRequest('/admin/events', Events.params)
    Event.params = {}

  setActiveTagFilter: (e) ->
    if $(e.currentTarget).html() == $('tr.select').html() && !$(e.currentTarget).is('all-events')
      $('tr.select').removeClass('select')
      $('#all-events').addClass('select')
      Events.filterList()
    else
      Events.params['filter'] = null
      $('tr.select').removeClass('select')
      $(e.currentTarget).addClass('select')
      Events.filterList()

  updateTag: (e) ->
    Events.params['tag_id'] = $(e.currentTarget).attr('data-tag-id')
    Events.params['event_id'] = $(e.currentTarget).closest('section').attr('data-event-id')

    Events.setCalendarParams()
    Events.setSearchParams()
    Events.ajaxRequest('/admin/events/' + Events.params['event_id'] + '/update_tag', Events.params)
    Event.params = {}

  updateDisplay: (e) ->
    return if $(e.currentTarget).hasClass('admin-event-show') || $(e.currentTarget).hasClass('admin-event-hide')
    Events.params['event_id'] = $(e.currentTarget).closest('section').attr('data-event-id')
    Events.ajaxRequest('/admin/events/' + Events.params['event_id'] + '/update_display', Events.params)
    Event.params = {}

  updateApproval: (e) ->
    return if $(e.currentTarget).hasClass('admin-event-show') || $(e.currentTarget).hasClass('admin-event-hide')
    Events.params['event_id'] = $(e.currentTarget).closest('section').attr('data-event-id')
    Events.ajaxRequest('/admin/events/' + Events.params['event_id'] + '/update_approval', Events.params)
    Event.params = {}

  ajaxRequest: (url, params) ->
    $.ajax
      type: "GET"
      url: url
      dataType: "script"
      data: params
      error: ->
        alert 'Oops. Something went wrong.'

  throttle: ->
    setTimeout(Events.checkScrollHeight(), 50)

  getDocHeight: ->
    D = document
    Math.max Math.max(D.body.scrollHeight, D.documentElement.scrollHeight), Math.max(D.body.offsetHeight, D.documentElement.offsetHeight), Math.max(D.body.clientHeight, D.documentElement.clientHeight)

  checkScrollHeight: ->
    if $(window).scrollTop() + $(window).height() > (Events.getDocHeight() - 75)
      return if running

      $('.loading-gif').show()
      running = true
      date = $('.event-groups').attr('data-end-date')
      current_day = (new Date(date)).getDate() + 1
      next_date = new Date(date)
      next_date.setDate(current_day + 1)

      if next_date.getTime() != Events.last_date.getTime()
        Events.last_date = next_date

        Events.params["day"] = next_date.getDate()
        Events.params["month"] = next_date.getMonth() + 1
        Events.params["year"] = next_date.getYear() + 1900
        Events.setFilterParams()
        Events.setSearchParams()

        if location.pathname.indexOf("/admin/events") == 0
          Events.setApprovalParams()
          Events.ajaxRequest('/admin/add_events', Events.params)
        else
          Events.ajaxRequest('/add_events', Events.params)

        Event.params = {}
        running = false
  }

$ ->

  if location.pathname == "/events" || (location.pathname.indexOf("/admin/events") == 0)
    $(window).on("scroll", Events.throttle)

  $('td.day').on 'click', (e) ->
    $(this).closest(".calendar").find(".select").removeClass("select");
    $(this).addClass('select')
    Events.filterList()

  $('#calendar td.day').on 'click', (e) ->
    $(this).closest(".calendar").find(".select").removeClass("select");
    $(this).addClass('select')
    Events.filterList()

  $('#admin-calendar td.day').on 'click', (e) ->
    $(this).closest(".calendar").find(".select").removeClass("select");
    $(this).addClass('select')
    Events.filterAdminList()

  $('#school-select').change ->
    Events.filterList()

  $('form#search').submit ->
    Events.filterList()
    false

  $('form#admin-search').submit ->
    Events.filterAdminList()
    false

  $('.search-tags tr').on 'click', (e) ->
    Events.setActiveTagFilter(e)

  $('body').on 'click', '.event-card', (e) ->
    event_id = $(e.currentTarget).attr('data-event-id')
    if event_id
      window.location = '/events/' + event_id

  $('body').on 'click', '.admin-event-tags li', (e) ->
    Events.updateTag(e)

  $('body').on 'click', '.display-tags .admin-event-btn', (e) ->
    Events.updateDisplay(e)

  $('body').on 'click', '.approval-tags .admin-event-btn', (e) ->
    Events.updateApproval(e)

  $('body').on 'click', '.admin-event-card', ->
    $(this).find(".event-description").slideToggle(400)

  $('.event-rsvp li').on 'click', ->
    $('.loading-gif').show()

  $('.close-btn').on 'click', ->
    $(this).parent('div').fadeOut 500

  if $('.event-banner').length > 0
    event_id = $('.main-events').attr('data-event-id')
    $.ajax
      type: "GET"
      url: '/events/' + event_id + '/friends'
      dataType: "json"
      success: (data) ->
        console.log(data)
        $('#num-friends').html(data)
      error: ->
        alert 'Oops. Something went wrong.'


  # Sticky Header by Jason Wong
  $(window).scroll ->
    scrollFromTop = $(this).scrollTop() + $('header').outerHeight(true)
    $(".event-day").each ->
      offsetTop = $(this).offset().top
      wrapper = $(this).parent()
      wrapperOffsetTop = wrapper.offset().top
      topPosition = scrollFromTop - wrapperOffsetTop
      if (topPosition < 0)
        topPosition = 0
      $(this).css
        top: topPosition
