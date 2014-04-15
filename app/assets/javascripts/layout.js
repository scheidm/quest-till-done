
$(document).ready(function(){
    var clock = $('#clock').FlipClock({
        autoStart: false,
        countdown: true,
        callbacks: {
            stop: function() {
                if(clock.getTime() <= 2)
                    $.ajax({
                        type: "GET",
                        dataType: "json",
                        url: "/timers/restart_countdown",
                        success: function(result) {
                            if(result.state == true)
                            {
                                clock.setTime(result.setting_time);
                                clock.start();
                            }
                        }
                    });
            }
        }
    });

    $('#avatar').popover({
        html: true,
        placement: "bottom",
        container: $(this).attr('id'),
        trigger: "manual",
        content: function () {
            return $('#userPopContent').html();
        }
    }).on("mouseenter", function () {
            var _this = this;
            $(this).popover("show");
            $(this).siblings(".popover").on("mouseleave", function () {
                $(_this).popover('hide');
            });
        }).on("mouseleave", function () {
            var _this = this;
            setTimeout(function () {
                if (!$(".popover:hover").length) {
                    $(_this).popover("hide")
                }
            }, 100);
        });

    $.ajax({
        type: "GET",
        url: "/timers/get_time_current",
        dataType: 'json',
        cache: false,
        success: function(result) {
            clock.setTime(result.current_time)
            if(result.state == true)
                clock.start();
        }
    });

    $('#startBtn').click(function()
    {
        clock.start();
        $.ajax({
            type: "POST",
            url: "/timers/start_countdown",
            success: function(result) {
            }
        });
    });
    $('#stopBtn').click(function()
    {
        clock.stop();
        $.ajax({
            type: "POST",
            url: "/timers/pause_countdown",
            data: "current_time=" + clock.getTime(),
            success: function(result) {
            }
        });
    });
    $('#resetBtn').click(function()
    {
        clock.stop();
        $.ajax({
            type: "GET",
            dataType: "json",
            url: "/timers/reset_countdown",
            success: function(result) {
                clock.setTime(result.setting_time);
            }
        });
    });

    /***************** Search *******************/
    $( "#search-bar" ).autocomplete({
        source: function( request, response ) {
            $.ajax({
                url: "/searches/all_autocomplete",
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
                            label: item.label,
                            value: item.value,
                            class: item.class
                        }
                    }));
                }
            });
        },
        select: function(event, ui) {
            event.preventDefault();
            $("#search-bar").val(ui.item.label);
        }
    }).data( "ui-autocomplete" )._renderItem = function( ul, item ) {
        var s = item.label;
        if(item.label.length > 18)
            s = item.label.substring(0, 18) + "...";
        return $( "<li>" )
            .append( "<a>" + s + " <span class='label label-"+item.class+"'>"+item.class+"</span></a>" )
            .appendTo( ul );
    };
});