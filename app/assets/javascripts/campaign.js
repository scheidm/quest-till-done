function  campaign_timeline(){
          $("#treeView").jstree({
              core : { "animation" : 100 },

              themes : { "theme" : "apple", "icons" : true, "dots": true },
              "json_data": {
                  "ajax" : {
                      "url" : "/campaigns/get_campaign_timeline?id=" + $('#treeView').attr('data-id')
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
}
function campaign_show(){
    campaign_tree_display();
    $('#timeline').click(campaign_timeline);
}
function  campaign_tree_display(){
     var campaign = $('#title-div').data('campaign');
     document.title=["QTD", campaign].join(' - ');
     var treeId = $('#tree-container').data('actionable-id');
     var showClosed = $('#show_all').data('show-all');
     var url = "getTree?id=" + treeId+"&show_all="+showClosed;
     console.log(url);
     questTree(url);
}
