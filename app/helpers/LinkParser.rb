module LinkParser
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

