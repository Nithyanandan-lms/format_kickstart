@format @format_kickstart @format_kickstart_visibility @_file_upload @javascript
Feature: Check the kickstart course format features.
  Background: Create users to check the visbility.
    Given the following "users" exist:
      | username | firstname | lastname | email              |
      | coursecreator1 | Coursecreator   | user1   | coursecreator1@test.com  |
      | coursecreator2 | Coursecreator   | User2   | coursecreator2@test.com  |
      | user1    | User      | One      | one@example.com |
      | user2    | User      | Two      | two@example.com |
      | user3    | User      | Three    | thr@example.com |
    And the following "courses" exist:
      | fullname | shortname | category | enablecompletion | showcompletionconditions | format    | newsitems |
      | Course 1 | C1        | 0        | 1                | 1                        | kickstart | 1         |
      | Course 2 | C2        | 0        | 1                | 1                        | kickstart | 1         |
      | Course 3 | C3        | 0        | 1                | 1                        | kickstart | 1         |
      | Course 4 | C4        | 0        | 1                | 1                        | kickstart | 1         |
    And the following "categories" exist:
      | name | category | idnumber |
      | Cat 1 | 0 | CAT1 |
      | Cat 2 | 0 | CAT2 |
    And the following "role assigns" exist:
      | user    | role          | contextlevel | reference |
      | coursecreator1 | coursecreator       | Category     | CAT1      |
      | coursecreator1 | coursecreator       | Category     | CAT2      |
      | coursecreator1 | coursecreator       | Category     | CAT1      |
    And the following "activities" exist:
      | activity | name      | course | idnumber  | content               |
      | page     | TestPage1 | C3     | page1     | Example page1 content |
      | page     | TestPage2 | C3     | page2     | Example page2 content |
    And the following "course enrolments" exist:
      | user  | course | role           |
      | user1 | C1     | editingteacher |
      | user2 | C1     | student |

  Scenario: Check the template actions.
    # Admin view.
    Given I log in as "admin"
    And I create a kickstart template with:
      | Title | Test template 1 |
      | Tags  | template 1      |
      | Course backup file (.mbz) | /course/format/kickstart/tests/course.mbz|
    Then I should see "Template successfully created"
    Then I should see "Test template 1" in the "template 1" "table_row"
    And I click on "Edit" "button" in the "Test template 1" "table_row"
    And I set the following fields to these values:
      | Title | Demo template 1|
    And I press "Save changes"
    And I should see "Template successfully edited"
    Then I should see "Demo template 1" in the "template 1" "table_row"
    And I click on "Delete" "button" in the "Demo template 1" "table_row"
    And I press "Delete"
    And I should see "Template successfully deleted"
    And I log out

  Scenario: Check the import template format kickstart.
    Given I log in as "admin"
    And I navigate to "Courses > Course default settings" in site administration
    And I set the following fields to these values:
      | Format | Kickstart format|
    And I press "Save changes"
    Then I navigate to "Plugins > Course formats > Manage templates" in site administration
    And I press "Create template"
    And I set the following fields to these values:
      | Title | Test template 1|
    And I upload "/course/format/kickstart/tests/course-10-online.mbz" file to "Course backup file (.mbz)" filemanager
    And I press "Save changes"
    And I should see "Template successfully created"
    And I press "Create template"
    And I set the following fields to these values:
      | Title | Test template 2|
    And I upload "/course/format/kickstart/tests/course.mbz" file to "Course backup file (.mbz)" filemanager
    And I press "Save changes"
    And I should see "Template successfully created"
    And I log out
    Then I log in as "coursecreator1"
    And I am on course index
    And I follow "Cat 1"
    And I click on "More" "button"
    Then I should see "Add a new course"
    And I click on "Add a new course" "link"
    And I set the following fields to these values:
      | Course full name | Test course 1|
      | Course short name | Test course 1|
      | Course category | Cat 1 |
    And I press "Save and display"
    And I click kickstart template ".use-template[data-templatename=\"Test template 1\"]"
    And I click on "Import" "button" in the ".modal" "css_element"
    And I start watching to see if a new page loads
    Then I should see "Introduction"
    And I log out

  Scenario: Check the access to restrict template for free plugin.
    Given I log in as "admin"
    And I navigate to "Plugins > Course formats > Manage templates" in site administration
    And I press "Create template"
    And I set the following fields to these values:
      | Title | Test template 1|
    And I upload "/course/format/kickstart/tests/course.mbz" file to "Course backup file (.mbz)" filemanager
    And I press "Save changes"
    And I should see "Template successfully created"
    And I press "Create template"
    And I set the following fields to these values:
      | Title | Test template 2|
    And I upload "/course/format/kickstart/tests/course.mbz" file to "Course backup file (.mbz)" filemanager
    And I press "Save changes"
    And I press "Create template"
    And I set the following fields to these values:
      | Title | Test template 3|
    And I upload "/course/format/kickstart/tests/course.mbz" file to "Course backup file (.mbz)" filemanager
    And I press "Save changes"
    And I press "Create template"
    And I set the following fields to these values:
      | Title | Test template 4|
    And I upload "/course/format/kickstart/tests/course.mbz" file to "Course backup file (.mbz)" filemanager
    And I press "Save changes"
    And I should see "You are using the maximum number (4) of templates allowed in Kickstart free edition."
    And I press "Create template"
    And I should see "Buy Kickstart Pro"
    And I log out

  Scenario: Check the format plugin template access.
    Given I log in as "admin"
    Then I navigate to "Plugins > Course formats > Manage templates" in site administration
    And I should see course format "Single activity"
    And I should see course format "Social"
    And I should see course format "Custom sections"
    And I should see course format "Weekly sections"
    And I navigate to "Plugins > Course formats > Manage course formats" in site administration
    Then I click on disable link single activity
    Then I navigate to "Plugins > Course formats > Manage templates" in site administration
    And I should not see course format "Single activity"
    Then I am on "Course 1" course homepage
    And I should see "Course template" in the ".tertiary-navigation-selector .dropdown-toggle" "css_element"
    And I should not see course format "Single activity"
    And I click on ".use-template[data-templatename=\"Custom sections\"]" "css_element" in the ".template-list" "css_element"
    And I click on "Import" "button" in the ".modal-dialog" "css_element"
    And I start watching to see if a new page loads
    Then I should see "Course 1"
    Then ".course-content ul.section" "css_element" should exist
    And I navigate to "Plugins > Course formats > Manage templates" in site administration
    Then I click on enable link custom sections
    And I should see "Edit template"
    And I set the following fields to these values:
      | Course layout | Show one section per page |
    Then I press "Save changes"
    Then I am on "Course 2" course homepage
    And I click on ".use-template[data-templatename=\"Weekly sections\"]" "css_element" in the ".template-list" "css_element"
    And I click on "Import" "button" in the ".modal" "css_element"
    Then I should see "Course 2"
    Then ".format-weeks ul.weeks" "css_element" should exist

  Scenario: Check the single activity format template
    Given I log in as "admin"
    And I am on "Course 3" course homepage with editing mode on
    And I should see course format "Single activity"
    And I click kickstart single activity format template
    And I click on "Import" "button" in the ".modal" "css_element"
    And I check single activity condition kickstart:
      | Forum name | Test Forum |
    And I navigate to "Plugins > Course formats > Manage templates" in site administration
    Then I click on enable link single activity
    And I should see "Edit template"
    And I set the following fields to these values:
      | Type of activity | Page |
    Then I press "Save changes"
    Then I am on "Course 3" course homepage
