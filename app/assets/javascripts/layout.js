
$(document).ready(function(){
    var clock = $('#clock').FlipClock({
        autoStart: false,
        countdown: true
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
        url: "/timers/get_current_time",
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
            url: "/timers/start_timer",
            success: function(result) {
            }
        });
    });
    $('#stopBtn').click(function()
    {
        clock.stop();
        $.ajax({
            type: "POST",
            url: "/timers/stop_timer",
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
            url: "/timers/reset_timer",
            success: function(result) {
                var x = result.setting_time;
                clock.setTime(result.setting_time);
            }
        });
    });
});