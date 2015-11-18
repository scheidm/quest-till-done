
function quest_show(){
     var quest = $('#title-div').data('quest');
     var campaign = $('#title-div').data('campaign');
     document.title=["QTD", campaign, quest].join(' - ');
     var active = $('#title-div').data('act');
     if(active===1){
       document.title="* "+document.title;
     }
     var treeId = $('#tree-container').data('actionable-id');
     var showClosed = $('#show_all').data('show-all');
     var url = "getTree?id=" + treeId+"&show_all="+showClosed;
     questTree(url);
     $('#activeBtn').click(function()
     {
     var questId = { id: treeId}
        $.ajax({
           type: "POST",
           url: "set_active",
           data: questId,
           success: function(data) {
              $('.flashMessage').html("Successfully set current quest to active quest");
              window.location.reload();
          }
        });
     });
     var active = $('#active_quest').html().trim();
     if(active == "true")
        $('#activeBtn').prop('disabled', true);
     $('#activeBtn').click(function() {
        $('#activeBtn').prop('disabled', true);
     });
}
$(document).ready(function () {
  quest_show();
});
