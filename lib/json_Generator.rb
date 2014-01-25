module JsonGenerator
  module EncounterModule
    def generateTree
      @encounters = Encounter.all
      data = []

      @encounters.each {|item|
        _endTime = item.end_time
        _endTime = (item.end_time.nil? ) ? 'Now' : item.end_time.to_formatted_s(:long)
        @TreeData = ({:data => item.created_at.to_formatted_s(:long) + ' - ' + _endTime, :attr => { :href => '/encounters/' + item.id.to_s, :rel => 'encounters' }})
        @TreeData[:children] = children = []
        item.nodes.each {|node|
          type = node.specific
          children <<  ({:data => type.description, :attr => { :href => '/'+ type.class.name.downcase + 's/' + type.id.to_s, :rel => type.class.name }})
        }
        data.push(@TreeData)
      }
      return data.to_json
    end
  end

  module ActionModule
    def generateTree
      return Action.all.to_json
    end
  end
end
