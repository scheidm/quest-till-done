# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$.rails.allowAction = (link) ->
  return true unless link.attr('data-confirm')
  $.rails.showConfirmDialog(link) # look bellow for implementations
  false # always stops the action since code runs asynchronously

# Modified snippets from http://stackoverflow.com/questions/14192009/how-can-i-display-delete-confirm-dialog-with-bootstraps-modal-not-like-brows
# to override rails confirm dialog box
$.rails.confirmed = (link) ->
  link.removeAttr('data-confirm')
  link.trigger('click.rails')

$.rails.showConfirmDialog = (link) ->
  message = link.attr 'data-confirm'
  html = """
         <div class="modal fade" id="confirmationDialog">
           <div class="modal-dialog">
              <div class="modal-content" style='overflow: auto;padding-bottom: 15px;'>
                 <div class="modal-header">
                   <a class="close" data-dismiss="modal">×</a>
                   <h3>#{message}</h3>
                 </div>
                 <div class="modal-body">
                   <p>Are you sure you want to delete?</p>
                   </br>
                   </br>
                   <div class="pull-right">
                    <a data-dismiss="modal" class="btn btn-default">Cancel</a>
                    <a data-dismiss="modal" class="btn btn-primary confirm">OK</a>
                   </div>
                 </div>
              </div>
           </div>
         </div>
         """
  $(html).modal()
  $('#confirmationDialog .confirm').on 'click', -> $.rails.confirmed(link)