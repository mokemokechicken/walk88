Map = (options) ->
  that = {}
  that.options = options
  that.init = ->
    console.log(that.options)
    $.get '/user_statuses', (data) ->
      mapOptions = {zoom: 8, mapTypeId: google.maps.MapTypeId.ROADMAP}
      mapOptions.center = LL(data[0].lat, data[0].lon)
      map = that.map = new google.maps.Map($(options.canvas)[0], mapOptions);
      for s in data
        console.log s
        MK
          position: LL(s.lat, s.lon)
          map: map
          title: s.nickname
          icon: s.image

  return that

LL = (lat, lon) -> new google.maps.LatLng(lat, lon)
MK = (options) -> new google.maps.Marker(options)

window.Map = Map


###
  mapOptions =
    center: new google.maps.LatLng(-34.397, 150.644)
    zoom: 8
    mapTypeId: google.maps.MapTypeId.ROADMAP
  that.map = new  google.maps.Map($(options.canvas)[0], mapOptions);
###
