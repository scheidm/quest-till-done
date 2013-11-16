$.fn.countdown = function (callback, duration, message) {
    if(duration == '0') return;
    message = message || "";
    var container = $(this[0]).html(duration + message);
    var countdown = setInterval(function () {
        if (--duration) {
            container.html(duration + message);
        } else {
            clearInterval(countdown);
            callback.call(container);
        }
    }, 1000);
};