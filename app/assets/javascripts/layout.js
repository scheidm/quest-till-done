$(document).ready(function ()
{
    getState();
    $('#startStopBtn').click(function ()
    {
        var state = $("#startStopBtn").text();
        setState(state);
    });
});

function setState(state)
{
    $.ajax({
        type: "GET",
        url: "/pomodoros/setState",
        data: "state=" + state,
        cache: false,
        success: function(result) {
            location.reload(true);
        }
    });
}
function getState()
{
    $.ajax({
        type: "GET",
        url: "/pomodoros/getState",
        dataType: 'json',
        cache: false,
        success: function(result) {
            $(".countdown").countdown(timesUp, parseInt(result.duration), "s remaining");
            $("#startStopBtn").text(result.state);
        }
    });
}

function timesUp()
{
    $("#startStopBtn").text("Stop");
    setState("Stop");
}