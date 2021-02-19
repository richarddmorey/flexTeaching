function test2_response_download(id){
  var q1 = $('#test2-input-q1').val()
  var q2 = $('#test2-input-q2').val()
  var text = `ASSIGNMENT TEST2\nID: ${id}\nQ1: ${q1}\nQ2: ${q2}\n`
  $('<a></a>')
    .attr('id', 'test2-download-link')
    .attr('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(text))
    .attr('download', 'responses.txt')
    .hide()
    .appendTo('body')[0]
    .click()
    $('#test2-download-link').remove()
}
