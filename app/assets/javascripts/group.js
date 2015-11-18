function group_show(){
     var group = $('#title-div').data('group');
     document.title = "QTD - "+group;
          $("#treeView").jstree({
              core : { "animation" : 100 },

              themes : { "theme" : "apple", "icons" : true, "dots": true },
              "json_data": {
                  "ajax" : {
                      "url" : "/groups/timeline?id=" + $('#treeView').attr('data-id')
                  }
              },
              "types" : {
                  "types" : {
                      "encounter" : {
                        "icon" : {
                            "image" : "/assets/encounter.png"
                        },
                      },
                      "round" : {
                        "icon" : {
                            "image" : "/assets/round.png"
                        },
                      },
                      "link" : {
                        "icon" : {
                            "image" : "/assets/link.png"
                        },
                      },
                      "note" : {
                          "icon" : {
                              "image" : "/assets/note.png"
                          },
                      },
                      "campaign" : {
                        "icon" : {
                            "image" : "/assets/campaign.png"
                        },
                      },
                      "quest" : {
                          "icon" : {
                              "image" : "/assets/quest.png"
                          },
                      },
                      "image" : {
                          "icon" : {
                              "image" : "/assets/image.png"
                          },
                      },
                      "default" : {
                          "valid_children" : [ "default" ]
                      }
                  }
              }  ,

              plugins: ["themes", "json_data", "dnd", "ui", "types" ],
          }).bind("select_node.jstree", function (e, data)
              {
                  window.location= data.rslt.obj.attr("href");
              }
          ).bind("loaded.jstree", function (event, data) {
                       $(this).jstree("open_all");
          }) ;

      $( "#user_list" ).autocomplete({
          source: function( request, response ) {
              $.ajax({
                  url: "/searches/user_autocomplete",
                  dataType: "json",
                  data: {
                      featureClass: "P",
                      style: "full",
                      maxRows: 12,
                      query: request.term
                  },
                  success: function( data ) {
                      response( $.map( data, function( item ) {
                          return {
                              label: item.username,
                              value: item.id
                          }
                      }));
                  }
                  })
              },select: function(event, ui) {
                     event.preventDefault();
                     $("#user_list").val(ui.item.label);
                     $("#user_list_id").val(ui.item.value);
               }
      });
}
$(document).ready(function(){
  group_show();
});
