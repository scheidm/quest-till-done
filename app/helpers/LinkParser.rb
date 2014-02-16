class LinkParser

		
  def initialize()
    @Links=[]
  end

  def findLinks(strings)
    re = /http:\/\/\S*/i

    matches = strings.match re

    matches.each do |match|
      links.push(match)
    end

  end

  def getLinks()
    links.each do |link|
      puts link
    end
  end
end

