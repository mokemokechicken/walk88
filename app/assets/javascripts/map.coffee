KML = "https://maps.google.co.jp/maps/ms?ie=UTF8&authuser=0&msa=0&output=kml&msid=205328521189507590527.0004df7bb3d55d4369ee1&ss=9"
Map = (options) ->
  that = {}
  that.options = options
  that.init = ->
    console.log(that.options)
    regist_event_handler_for_kml(options.kml, options.kml_url) if options.kml && options.kml_url
    $.get "/user_statuses?reverse_mode=#{that.options.reverse_mode}", (data) ->
      mapOptions =
        zoom: 12
        mapTypeId: google.maps.MapTypeId.ROADMAP

      vuser = data[0] if data.length > 0

      that.users = []
      for user in data
        that.users[user.id] = user
        vuser = user if user.id is that.options.user_id

      h = $('body > .container-fluid').height() - $('#menu').height()
      $('#listview').css('height', h)
      $('#mapview').css('height', h)
      $('#map').css('height', h - $('#panorama').height())

      map = that.map = new google.maps.Map($(options.canvas)[0], mapOptions)
      draw_routes_polyline(map, $(options.polyline).text())
      for s, i in data
        do (s, i) ->
          setTimeout ->
            marker = MK
              position: LL(s.lat, s.lon)
              map: map
              title: s.nickname
              icon: s.image
              zIndex: 10000-i
              animation: google.maps.Animation.DROP

            google.maps.event.addListener marker, 'click', (event) ->
              that.setUserMap s
          , i * 100

      that.pano = new google.maps.StreetViewPanorama($('#panorama')[0])
      that.sv = new google.maps.StreetViewService()
      that.setUserMap vuser

      $(window).resize ->
        h = $('body > .container-fluid').height() - $('#menu').height()
        $('#listview').css('height', h)
        $('#mapview').css('height', h)
        if $('#panorama').css('display') is 'none'
          $('#map').css('height', h)
        else
          $('#map').css('height', h - $('#panorama').height())
        google.maps.event.trigger that.map, 'resize'

      $('#listview').on 'mouseover', 'img', ->
        uid = $(@).parents('tr').data('user-id')
        that.setUserMap that.users[uid]

  that.setUserMap = (user) ->
    that.sv.getPanoramaByLocation LL(user.lat, user.lon), 100, (data, stat) ->
      if stat is google.maps.StreetViewStatus.OK
        that.pano.setPosition LL(user.lat, user.lon)
        that.pano.setPov
          heading: if user.bearing then user.bearing else 0
          pitch: 0
          zoom: 1
        $('#panorama').show()
        that.pano.setVisible true
        $('#map').css('height', $('#mapview').height() - $('#panorama').height())
        google.maps.event.trigger that.map, 'resize'
      else
        $('#panorama').hide()
        that.pano.setVisible false
        $('#map').css('height', $('#mapview').height())
        google.maps.event.trigger that.map, 'resize'
      that.map.setCenter LL(user.lat, user.lon)

  that.overlay_kml = (kml_url) ->
    console.log("load KML: " + kml_url)
    new google.maps.KmlLayer
      map: that.map
      preserveViewport: true
      url: kml_url

  kml_control_function = (prefix) ->
    (name) -> $("#"+prefix+"_" + name)

  regist_event_handler_for_kml = (kml_prefix, kml_url) ->
    ui = kml_control_function(kml_prefix)
    ui("add").on "click", ->
      that.added_url ||= []
      if that.added_url.indexOf(kml_url) == -1
        that.added_url.push(kml_url)
        that.overlay_kml(kml_url + '&__r='+Math.random())

  # シンプルな線
  draw_routes = (map) ->
    $.get '/locations', (data) ->
      new google.maps.Polyline
        map: map
        path: (LL(p.lat, p.lon) for p in data)
        strokeColor: '#cc33cc'
        strokeOpacity: 0.5

  # ルートっぽい線
  draw_route_by_directions_service = (map, origin, destination) ->
      ds = new google.maps.DirectionsService()
      request =
        origin: LL(origin.lat, origin.lon)
        destination: LL(destination.lat, destination.lon)
        travelMode: google.maps.TravelMode.WALKING
      ds.route request, (result, status) ->
        console.log(result, status)
        dr = new google.maps.DirectionsRenderer
          map: map
          directions: result
          preserveViewport: true
          # suppressMarkers: true

  # ルート
  draw_routes_polyline = (map, polyline) ->
    new google.maps.Polyline
      map: map
      path: google.maps.geometry.encoding.decodePath(polyline)
      strokeColor: '#3333cc'
      strokeOpacity: 0.5


  return that

# Short Cut Functions
LL = (lat, lon) -> new google.maps.LatLng(lat, lon)
MK = (options) -> new google.maps.Marker(options)

# For Public
window.Map = Map

