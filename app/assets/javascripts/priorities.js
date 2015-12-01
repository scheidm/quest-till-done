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
      $('#left-ul').empty();
      $('#right-ul').empty();
      var quests = JSON.parse(result);
      var campaigns=quests[2];
      var desc;
      $.each(quests[0], function() {
        this.description === null ? desc="": desc=this.description;
        $('#left-ul').append('<div class="panel panel-primary"><div class="panel-heading">'
          +'<a href=/campaigns/'+this.campaign_id+'>'
          +campaigns[this.campaign_id]+'</a> - <a href=/quests/'
          +this.id+'>'+this.name+'</a></div><div class="panel-body">'
          +'<a class="list-group-item"><p class="list-group-item-heading">'
          +desc+'</p><p class="list-group-item-text">deadline: '
          +displayEmptyIfNull(this.deadline)+'</p></a></div></div>');
      });
      $.each(quests[1], function() {
        this.description === null ? desc="": desc=this.description;
        $('#right-ul').append('<div class="panel panel-danger"><div class="panel-heading panel-deadline">'
          +'<a href=/campaigns/'+this.campaign_id+'>'
          +campaigns[this.campaign_id]+'</a> - <a href=/quests/'
          +this.id+'>'+this.name+'</a></div><div class="panel-body">'
          +'<a class="list-group-item"><p class="list-group-item-heading">'
          +desc+'</p><p class="list-group-item-text">deadline: '
          +displayEmptyIfNull(this.deadline)+'</p></a></div></div>');
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
