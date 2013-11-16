$(document).ready(function ()
{
    getState();
    $('#startStopBtn').click(function ()
    {
        var state = $("#startStopBtn").text();
        $.ajax({
            type: "GET",
            url: "/pomodoros/setState",
            data: "state=" + state,
            cache: false,
            success: function(result) {
                location.reload(true);
            }
        });
    });
});

function getState()
{
    $.ajax({
        type: "GET",
        url: "/pomodoros/getState",
        cache: false,
        success: function(result) {
            $("#startStopBtn").text(result);
        }
    });
}