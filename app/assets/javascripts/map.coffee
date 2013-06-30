KML = "https://maps.google.co.jp/maps/ms?ie=UTF8&authuser=0&msa=0&output=kml&msid=205328521189507590527.0004df7bb3d55d4369ee1&ss=9"
Map = (options) ->
  that = {}
  that.options = options
  that.init = ->
    console.log(that.options)
    regist_event_handler_for_kml(options.kml, options.kml_url) if options.kml && options.kml_url
    $.get '/user_statuses', (data) ->
      mapOptions = {zoom: 8, mapTypeId: google.maps.MapTypeId.ROADMAP}
      mapOptions.center = LL(data[0].lat, data[0].lon)
      map = that.map = new google.maps.Map($(options.canvas)[0], mapOptions);
      draw_routes(map)
      for s, i in data
        MK
          position: LL(s.lat, s.lon)
          map: map
          title: s.nickname
          icon: s.image
          zIndex: 10000-i

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


  return that

# Short Cut Functions
LL = (lat, lon) -> new google.maps.LatLng(lat, lon)
MK = (options) -> new google.maps.Marker(options)

# For Public
window.Map = Map

