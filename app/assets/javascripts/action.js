$(document).ready(function(){
    // Disable past dates, plugins from http://www.eyecon.ro/bootstrap-datepicker/
    var nowTemp = new Date();
    var now = new Date(nowTemp.getFullYear(), nowTemp.getMonth(), nowTemp.getDate(), 0, 0, 0, 0);

    $('.datepicker').datepicker({
        onRender: function(date) {
            return date.valueOf() < now.valueOf() ? 'disabled' : '';
        },
        format: 'yyyy-mm-dd'
    }).on('changeDate', function(ev) {
            $('.datepicker').datepicker('hide');
        }).datepicker();
});