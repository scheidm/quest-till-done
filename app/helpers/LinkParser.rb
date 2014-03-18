module LinkParser
  # The function yields a collection of links found in the strings given.
  # Used for casting comments from github into the appropriate type of record.
  def find_links(strings)
    links=[]
    re = /http:\/\/\S*/i

    matches = strings.match re

    matches.each do |match|
      links.push(match)
    end
    links
  end
end

