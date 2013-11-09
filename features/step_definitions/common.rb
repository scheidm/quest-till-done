require 'rspec/expectations'
#Debug
When /^DEBUG window$/ do
  require 'debug'
  debugger
end

When /^DEBUG element with (id|class|text) "([^"]+)"$/ do |key, val|
  t = @browser.elements(key.to_sym => val)[0]
  require 'debug'
  debugger
end

When /^I go to (.*)$/ do |url|
  @browser = SCHEMA.browser
  @browser.goto url
end 

#Choose
When /^I chose "([^"]*)" from select with (id|class) "([^"]*)"/ do |txt, type, field_id|
  supportstep "I wait for an element with id \"#{field_id}\""
  @browser.select(type.to_sym => field_id).select(txt)
end

When /^from (input|select) "([^"]+)" I choose "([^"]+)"$/ do |type, id, str|
  raise "Menu missing!" unless step "I see a #{type} with id \"#{id}\""
  puts "Menu found"
  supportstep "I wait for it to appear"
  menu=@elem
  if type=="select" 
    raise "Option missing!" unless step "there is a option with text \"#{str}\""
  else
    raise "Option missing!" unless step "there is a input with value \"#{str}\""
  end
  @browser.wait_until(timeout=30*SCHEMA.multiplier) do
    menu.click
    @elem.exists?
  end
  puts "Option found"
  supportstep "I wait for it to appear"
  @elem.click
end

#new window
When /^In a new window, (.*?)$/ do |substep|
  @browser.driver.switch_to.window(@browser.driver.window_handles.last)
  supportstep "#{substep}"
end

When /^waiting on: ([^,]+), I repeat: (.*?)$/ do |boolstep,steplist|
  todo=steplist.split(', ')
  @browser.wait_until(timeout=60*SCHEMA.multiplier) do
    todo.each do |substep|
      step substep
    end
    step boolstep
  end
end

#search
When /^I search using scroll element with (id|class|value) "([^"]+)" until I find string "([^"]+)"$/ do |key, link_id, str|
    found = false
    begin  
       if step "I see the string \"#{str}\"" then
         found = true
         break
       end
       if step "I see a link with class \"arrow-right return-top\"" then
          more_pages=true
          supportstep "I click on link with class \"arrow-right return-top\""
          else more_pages=false
       end
    end while more_pages
    raise "can't find string!" if not found 
end

Then /^I see the string "([^"]+)"$/ do |str|
  begin
     @browser.body.text.should match str
  rescue Watir::Wait::TimeoutError,StandardError
    false
  end
end

Then /^I wait for it to appear$/ do
  raise @elem.inspect unless @browser.wait_until(timeout=30*SCHEMA.multiplier) do
     @elem.visible?
  end
end

Then /^I wait for (a|an) ([0-9a-zA-Z\-_ ]+) with (id|class|value|text|tag_name|type|name|title) "([^"]+)"$/ do |grammar, elem_type, key, link_id|
  raise "Step failed: I see a #{elem_type} with #{key} \"#{link_id}\"" unless step "I see a #{elem_type} with #{key} \"#{link_id}\""
  true
end

Then /^I see (a|an) ([0-9a-zA-Z\-_ ]+) with (id|class|value|text|tag_name|type|name|title) "([^"]+)"$/ do |grammar, elem_type, key, link_id|
  begin
    step "there is a #{elem_type} with #{key} \"#{link_id}\""
    @browser.wait_until(timeout=30*SCHEMA.multiplier) do
      @elem.visible?
    end
    true
  rescue
    false
  end
end

Then /^there is (a|an) ([0-9a-zA-Z\-_ ]+) with (id|class|value|text|tag_name|type|name|title) "([^"]+)"$/ do |grammar, elem_type, key, link_id|
  begin
    cust={"field" => :text_field , "text area" => :textarea} 
    x=cust[elem_type]
    x=elem_type.to_sym if x.nil?
    @browser.wait_until(timeout=30*SCHEMA.multiplier) do
      @elem=@browser.send(x, key.to_sym => link_id)
      @elem.exists?
    end
    true
  rescue
    puts 'fail!'
    false
  end
end

#Click
Then /^I click on (a|an) ([0-9a-zA-Z\-_]+) with (id|class|value|text|tag_name|type|name|title) "([^"]+)"$/ do |grammar, elem_type, key, link_id|
  step "I wait for a #{elem_type} with #{key} \"#{link_id}\""
  @elem.click
end

#Enter
{:text_field => "field", :textarea =>"text area"}.each do |meth, label|
  When /^I entered a random phone number in the #{label} with id "([^"]+)"/ do |field_id|
    @permtext=Time.now.to_i.to_s
    step "I entered \"#{@permtext}\" in the #{label} with id \"#{field_id}\""
  end
end

{:text_field => "field", :textarea =>"text area"}.each do |meth, label|
When /^I entered a permutation of email "([^@]+)@([^"]+)" in the #{label} with id "([^"]+)"/ do |user,domain, field_id|
    rnum = Time.now.to_i.to_s
    @email = user+"+"+rnum+"@"+domain
    step "I entered \"#{@email}\" in the #{label} with id \"#{field_id}\""
  end
end

{:text_field => "field", :textarea =>"text area"}.each do |meth, label|
  When %r{^I entered a permutation of "([^"]*)" in the #{label} with id "([^"]+)"} do |txt, field_id|
    @permtext = txt+Time.now.to_i.to_s
    step "I entered \"#{@permtext}\" in the #{label} with id \"#{field_id}\""
  end
end

{:text_field => "field", :textarea =>"text area"}.each do |meth, label|
  When %r{^I entered the last permuted string in the #{label} with id "([^"]+)"} do |field_id|
    raise "no previous string available" if @permtext.nil?
    step "I entered \"#{@permtext}\" in the #{label} with id \"#{field_id}\""
  end
end

{:text_field => "field", :textarea =>"text area"}.each do |meth, label|
  When %r{^I entered "([^"]*)" in the #{label} with id "([^"]+)"} do |txt, field_id|
    step "I wait for a #{label} with id \"#{field_id}\""
    @elem.set txt
  end
end

#wait
Then /^I wait for the string "([^"]+)"$/ do |str|
  @browser.wait_until(timeout=30*SCHEMA.multiplier) do
     step "I see the string \"#{str}\""
  end
end

Then /^(.*)the last permuted string$/ do |substep|
   step "#{substep}the string \"#{@permtext}\""
end

#Leave
Then /^I should leave$/ do
  @browser.close
end

Then /^I confirm any alert$/ do
  t=@browser.alert
  begin
    @browser.wait_until(timeout=120*SCHEMA.multiplier) do
      t.exists?
    end
    t.ok
  rescue Watir::Wait::TimeoutError
    puts "no alert"
  end
end

When /^I wait (\d+) seconds?/ do |time|
  sleep time.to_i
end

When /^I click until (.*)$/ do |boolean|
  @browser.wait_until(timeout=30*SCHEMA.multiplier) do
    @elem.click
    eval boolean
  end
end
