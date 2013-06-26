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