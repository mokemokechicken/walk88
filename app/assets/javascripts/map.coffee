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

      if data.length > 0
        mapOptions.center = LL(data[0].lat, data[0].lon)
        vuser = data[0]

      for user in data
        if user.id == that.options.user_id
          mapOptions.center = LL(user.lat, user.lon)
          vuser = user

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
              that.map.setCenter LL(s.lat, s.lon)
              that.sv.getPanoramaByLocation LL(s.lat, s.lon), 100, (data, stat) ->
                if stat is google.maps.StreetViewStatus.OK
                  that.pano.setPano data.location.pano
                  that.pano.setPov
                    heading: if s.bearing then s.bearing else 0
                    pitch: 0
                    zoom: 1
                  that.pano.setVisible true
                else
                  that.pano.setVisible false
              that.pano.setPosition LL(s.lat, s.lon)
          , i * 100

      panoramaOptions =
        position: LL(vuser.lat, vuser.lon)
        pov:
          heading: if vuser.bearing then vuser.bearing else 0
          pitch: 0
          zoom: 1

      that.pano = new google.maps.StreetViewPanorama($('#panorama')[0])
      that.sv = new google.maps.StreetViewService()
      that.sv.getPanoramaByLocation LL(vuser.lat, vuser.lon), 100, (data, stat) ->
        if stat is google.maps.StreetViewStatus.OK
          that.pano.setPano data.location.pano
          that.pano.setPov
            heading: if vuser.bearing then vuser.bearing else 0
            pitch: 0
            zoom: 1
          that.pano.setVisible true
        else
          that.pano.setVisible false

      $(window).resize ->
        h = $('body > .container-fluid').height() - $('#menu').height()
        $('#listview').css('height', h)
        $('#mapview').css('height', h)
        if $('#panorama').css('display') is 'none'
          $('#map').css('height', h)
        else
          $('#map').css('height', h - $('#panorama').height())
        google.maps.event.trigger that.map, 'resize'

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

