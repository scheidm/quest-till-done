var note = {
    CheckDescription: function(description) {
        return (description.length > 0)
    }
}
function toggle_record_expansion(id){
  var brief=$('#rec-'+id+' .brief');
  if( brief.is(":visible") ){
    $('#rec-'+id+' .brief').hide();
    $('#rec-'+id+' .description').show();
    $('#rec-'+id+'-btn').text("Show Less");
  } else {
    $('#rec-'+id+' .brief').show();
    $('#rec-'+id+' .description').hide();
    $('#rec-'+id+'-btn').text("Show More");
  }
}
