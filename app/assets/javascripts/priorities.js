function priorities_index(){
    document.title='QTD - Priorities';
    $('#priority-body').hide();
    $('#loading-image').hide();
    $('#myNavmenu').offcanvas({
      canvas: "#myNavmenuCanvas",
      placement: "left",
      target: "#myNavmenu",
      toggle: "offcanvas"
    })
    $('.all_link').click(function(e){
      e.preventDefault();
      $('.campaign_link').parent().removeClass("active");
      $(this).parent().addClass("active");
      $('#priority-message').hide();
      $('#loading-image').show();
      $.ajax({
       type: 'GET',
       url: '/priorities/get_all_priorities',
       data: 'id=' + $(this).attr("id"),
       success: populatePriorities,
       complete: hideLoadingImage
      });
    })
    $('.campaign_link').click(function(e){
      e.preventDefault();
      $('.campaign_link').parent().removeClass("active");
      $('.all_link').parent().removeClass("active");
      $(this).parent().addClass("active");
      $('#priority-message').hide();
      $('#loading-image').show();
      $.ajax({
       type: 'GET',
       url: '/priorities/get_priorities',
       data: 'id=' + $(this).attr("id"),
       success: populatePriorities,
       complete: hideLoadingImage
      });
    })

    function populatePriorities(result) {
      $('#actionables').empty();
      var quests = JSON.parse(result);
      var campaigns=quests.pop();
      var desc;
      var panelClass={ 0: 'panel-warning',
        1: 'panel-info',
        2: 'panel-danger',
        3: 'panel-info',
      }
      var count=0;
      var quest;
      var campaign;
      $.each(quests, function() {
        console.log(count);
        quest=this;
        $.each(quest, function() {
          campaign=campaigns[this.campaign_id];
          this.description === null ? desc="": desc=this.description;
          $('#actionables').append('<div class="panel '+panelClass[count]+' col-md-5"><div class="panel-heading">'
            +'<a href=/campaign/'+this.campaign_id+' alt="'+campaign['name']
            +'"><btn class="btn btn-circle" style="background-color:#'+campaign['group_color']
            +'"><div class="inner-circle" title="'+campaign['name']+'" style="background-color:#'+campaign['color']
            +'">'+campaign['name'].substr(0,1).toUpperCase()
            +'</div></btn></a>'
            +'<a href=/campaigns/'+this.campaign_id+'>'
            +campaign['name']+'</a> - <a href=/quests/'
            +this.id+'>'+this.name+'</a></div><div class="panel-body">'
            +'<a class="list-group-item"><p class="list-group-item-heading">'
            +desc+'</p><p class="list-group-item-text">deadline: '
            +displayEmptyIfNull(this.deadline)+'</p></a></div></div><div class="col-md-1"></div>');

        });
        count+=1;
      });

    }

    function displayEmptyIfNull(value) {
      if (typeof value === "undefined" || value === null)
        return "";
      return value;
    }
    function hideLoadingImage() {
        $('#loading-image').hide();
        $('#priority-body').show();
    }
}
$(document).ready(function(){
  priorities_index();
});
