function test2_response_download(id){
  var q1 = $('#test2-input-q1').val()
  var q2 = $('#test2-input-q2').val()
  var images = $('#drop-region-q3 img').clone()
  
  var h = $('<html></html>')
  var b = $('<body></body>')
  
  b.appendTo(h)
   .append('<h2>ASSIGNMENT RESPONSES<h2>')
   .append(`<div id='idnum'>ID: ${id}</div>`)
   .append(`<div id='q1'>Q1: ${q1}</div>`)
   .append(`<div id='q2'>Q2: ${q2}</div>`)
   .append('<div id="q3"></div>')
   
  b.find('#q3')
    .append(images)
   
  $('<a></a>')
    .attr('id', 'test2-download-link')
    .attr('href', 'data:text/html;charset=utf-8,' + encodeURIComponent(h[0].outerHTML))
    .attr('download', 'responses.html')
    .hide()
    .appendTo('body')[0]
    .click()
    $('#test2-download-link').remove()
}
