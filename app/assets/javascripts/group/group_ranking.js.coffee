# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

GroupRanking = (options) ->
  that = {}
  that.init = ->
    $.getJSON '/group_ranking/by_day', (data) ->
      console.log(data)

      series = []
      for group in data.ranking
        sum = 0
        group_rec = []
        for day in group
          sum += day.distance
          group_rec.push sum
        series.push
          data: group_rec
          name: day.name
      series = convert_to_rank(series)

      $(options.canvas).highcharts
        chart:
          zoomType: 'x'
          type: 'spline'
        title:
          text: '順位の推移'
        xAxis:
          categories: (day.day for day in data.ranking[0])
        yAxis:
          reversed: true
          min: 1
          max: series.length
          type: 'category'
          title:
            text: '順位'
          labels:
            formatter: ->
              this.value + '位'
        tooltip:
          crosshairs: true
          shared: true
        series: series

  convert_to_rank = (series) ->
    dists = series.map((group) -> group.data)
    ranks = zip.apply(null, dists).map(number_to_rank)
    console.log(dists)
    console.log(ranks)
    group_ranks = zip.apply(null, ranks)
    for rank, i in group_ranks
      series[i].data = rank

    console.log(series)
    series

  number_to_rank = (arr) ->
    sorted = arr.slice().sort((a,b) -> b-a)
    arr.slice().map((v) -> sorted.indexOf(v)+1)

  zip = () ->
    lengthArray = (arr.length for arr in arguments)
    length = Math.min(lengthArray...)
    for i in [0...length]
      arr[i] for arr in arguments

  return that


window.GroupRanking = GroupRanking
