$(document).ready(function ()
{
    $.ajax({
        type: "GET",
        url: "/pomodoros/getState",
        cache: false,
        success: function(result) {
            $("#startStopBtn").text(result);
        }
    });
    $('#startStopBtn').text()
    $('#startStopBtn').click(function ()
    {
        var state = $("#startStopBtn").text();
        $.ajax({
            type: "POST",
            url: "/pomodoros/set",
            data: "state=" + state,
            cache: false,
            success: function(result) {
                $("#startStopBtn").text(result);
            }
        });
    });

});