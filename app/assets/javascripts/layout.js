var countdown = 0
$(document).ready(function ()
{
    getState(null);
    getTask();
    $('#startStopBtn').click(function ()
    {
        var button = $("#startStopBtn").text();
        getState(button);
        try {
            var tree = $.jstree._reference("#treeView");
            tree.refresh();
        } catch (e) {}
    });
    $('#detailLevel').mouseover(function (){
        $('#detailLevel').popover({
            html : true,
            content: function() {
                return $('#experience').html();
            }
        });
    });
    $('#detailLevel').popover({
        html : true,
        content: function() {
            return $('#experience').html();
        }
    });
    $('#badge').tooltip();

});

function setState(state)
{
    $.ajax({
        type: "POST",
        url: "/encounters/setState",
        data: "button=" + button,
        cache: false,
        success: function(result) {
            //location.reload(true);
        }
    });
};
function getState(button)
{
    $.ajax({
        type: "GET",
        url: "/encounters/getState",
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
};

function timesUp()
{
    $("#startStopBtn").text('Start');
    getState("Stop");
    try {
        var tree = $.jstree._reference("#treeView");
        tree.refresh();
    } catch (e) {}
};

function timer(callback, duration, message)
{
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

function getTask()
{
    $.ajax({
        type: "GET",
        url: "/actions/getTree",
        dataType: 'json',
        cache: false,
        success: function(result) {
            var html = buildList(result);
            $('#projectDropDown').html(html);
        }
    });
};
function buildList(data){
    var html = '<a data-toggle="dropdown" class="dropdown-toggle" href="#"><i class="icon-tasks"></i><span class="badge badge-grey">4</span></a>'
    html += '<ul class="pull-right dropdown-navbar dropdown-menu dropdown-caret dropdown-close"  href="#">';
    var numberOfProj = data.length
    html += '<li class="dropdown-header"><i class="icon-ok"></i>'+numberOfProj+' Projects ongoing</li>'
    for(var i=0; i<data.length; i++){
        html += '<li><a href="#"><div class="clearfix"><span class="pull-left">'+data[i].name+'</span>';
        html += '<span class="pull-right">'+data[i].status+'</span></div>'
        var progressBarBody = 'progress progress-mini';
        var progressBar;
        var progress = calculateDeadline(data[i]);
        if (progress > 80)
            progressBar = 'progress-bar progress-bar-danger';
        else if (progress > 60)
            progressBar = 'progress-bar progress-bar-warning';
        else if (progress > 40)
            progressBar = 'progress-bar'
        else
            progressBar = 'progress-bar progress-bar-success'
        if(data[i].status == 'In Progress')
            progressBarBody += ' progress-striped active'
        html += '<div class="'+progressBarBody+'"><div style="width:'+progress+'%" class="'+progressBar+'"></div></div>'
        html += '</a></li>'
    }
    html += '</ul>';
    return html;
};

function calculateDeadline(data)
{
    var deadline = new Date(Date.parse(data.deadline));
    var createdAt = new Date(Date.parse(data.created_at));
    var today = new Date();
    var dd = today.getUTCDate();
    var mm = today.getUTCMonth()+1;
    var yy = today.getUTCFullYear();
    var t = (deadline - today);
    var t2 = today - createdAt;
    var c = ((today - createdAt) / (deadline - createdAt))*100;
    if(deadline > today)
        return parseInt(((today - createdAt) / (deadline - createdAt))*100);
    else
        return 100;
};

$.fn.countdown = timer
