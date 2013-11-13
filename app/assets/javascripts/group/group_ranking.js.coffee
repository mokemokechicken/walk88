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

      $(options.canvas).highcharts
        chart:
          zoomType: 'x'
          type: 'spline'
        title:
          text: '日々の推移'
        xAxis:
          categories: (day.day for day in data.ranking[0])
        yAxis:
          min: 0
          title:
            text: '合計距離(Km)'
          labels:
            formatter: ->
              this.value + 'Km'
        tooltip:
          crosshairs: true
          shared: true
        series: series
  return that


window.GroupRanking = GroupRanking
