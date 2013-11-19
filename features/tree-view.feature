Feature: Tree-view
  Test the implementation of our various tree-view interfaces.

  Scenario: 
    When I go to http://54.200.206.254:1000/pomodoros
    Then I see the string "Quest"
    And I should leave
