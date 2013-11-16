var countdown = 0
$(document).ready(function ()
{
    getState(null);
    $('#startStopBtn').click(function ()
    {
        var button = $("#startStopBtn").text();
        getState(button);
    });
});

function setState(state)
{
    $.ajax({
        type: "POST",
        url: "/pomodoros/setState",
        data: "button=" + button,
        cache: false,
        success: function(result) {
            //location.reload(true);
        }
    });
}
function getState(button)
{
    $.ajax({
        type: "GET",
        url: "/pomodoros/getState",
        data: "button=" + button,
        dataType: 'json',
        cache: false,
        success: function(result) {
            if(parseInt(result.duration)>0)
                $(".countdown").countdown(timesUp, parseInt(result.duration), "s remaining");
            else
            {
                clearInterval(countdown);
                $(".countdown").text('');
            }
            $("#startStopBtn").text(result.button);
        }
    });
}

function timesUp()
{
    $("#startStopBtn").text('Start');
    getState("Stop");
}

$.fn.countdown = function (callback, duration, message) {
    message = message || "";
    var container = $(this[0]).html(duration + message);
    countdown = setInterval(function () {
        if (--duration) {
            container.html(duration + message);
        } else {
            clearInterval(countdown);
            callback.call(container);
        }
    }, 1000);
};