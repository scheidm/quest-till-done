$(function(){
    $( "#record_quests" ).autocomplete({
        source: function( request, response ) {
            $.ajax({
                url: "/searches/quest_autocomplete",
                dataType: "json",
                data: {
                    featureClass: "P",
                    style: "full",
                    maxRows: 12,
                    query: request.term
                },
                success: function( data ) {
                    response( $.map( data, function( item ) {
                        return {
                            label: item.name,
                            value: item.id,
                            status: item.status
                        }
                    }));
                }
            });
        },
        select: function(event, ui) {
            event.preventDefault();
            $("#record_quests").val(ui.item.label);
            $("#record_quest_id").val(ui.item.value);
            var css = ui.item.status.toString().trim().replace(/ /g,'');
            $("#record_quest_status").html("<h3 style='margin-top:0px;margin-bottom:0px'><span class='label label-"+ css+"'>"+ ui.item.status +"</span></h3>");
        }
    }).data( "ui-autocomplete" )._renderItem = function( ul, item ) {
        var css = item.status.toString().trim().replace(/ /g,'');
        return $( "<li>" )
            .append( "<a>" + item.label + " <span class='label label-"+ css+"'>"+ item.status +"</span></a>" )
            .appendTo( ul );
    };
    $('#note').click(function(e){
        e.preventDefault();
        $('.new_record').addClass('record-form-hidden');
        $('.record-type-item').removeClass('record-type-selected');
        $('#note-form').removeClass('record-form-hidden');

        $('#note').addClass('record-type-selected')
    });
    $('#link').click(function(e){
        e.preventDefault();
        $('.new_record').addClass('record-form-hidden');
        $('.record-type-item').removeClass('record-type-selected');
        $('#link-form').removeClass('record-form-hidden');
        $('#link').addClass('record-type-selected')
    });
    $('#image').click(function(e){
        e.preventDefault();
        $('.new_record').addClass('record-form-hidden');
        $('.record-type-item').removeClass('record-type-selected');
        $('#image-form').removeClass('record-form-hidden');
        $('#image').addClass('record-type-selected')
    });
});