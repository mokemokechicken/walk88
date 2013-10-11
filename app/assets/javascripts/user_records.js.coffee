# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

Fitbit = ->
  that = {}
  that.update_by_fitbit = (record_id) ->
    console.log(record_id)
    $.post '/user_records/' + record_id + '/fitbit.json', (data) ->
      unless data.error
        $('#steps_'+record_id).html(data.step)
        $('#distance_'+record_id).html("%.2f".sprintf(data.dist))
  return that

window.Fitbit = Fitbit

WeeklyGraph = (opts) ->
  that = {}
  options = opts
  that.init = ->
    $.get "/weekly_records/#{opts.user_id}", (data) ->
      $(options.canvas).highcharts
        chart:
          type: 'spline'
        title:
          text: '日々の平均歩数（週毎)'
        xAxis:
         categories: (xx.week for xx in data)
        yAxis:
          min: 0
          plotLines: [{
            color: 'green'
            value: 10000
            width: 2
          },{
            color: 'red'
            value: 7500
            width: 1
          },{
            color: 'red'
            value: 5001
            width: 2
            dashStyle: 'Dash'
          }]
          title:
            text: '歩数'
          labels:
            formatter: ->
              this.value + 'do'
        tooltip:
          crosshairs: true
          shared: true
        series: [{
          name: '歩数'
          marker:
            symbol: 'square'
          data: (xx.step for xx in data)
        }
        ]
  return that

window.WeeklyGraph = WeeklyGraph