Feature: Run a rails application with jetty

  Scenario: rails-3.2.x
    Given application with Gemfile.lock in "rails32x"
    Then jetty runs

    Given application without Gemfile.lock in "rails32x"
    Then jetty runs


  Scenario: rails-3.1.x
    Given application with Gemfile.lock in "rails31x"
    Then jetty runs

#    Given application without Gemfile.lock in "rails31x"
#    Then jetty runs


  Scenario: rails-3.0.x
    Given application with Gemfile.lock in "rails30x"
    Then jetty runs

    Given application without Gemfile.lock in "rails30x"
    Then jetty runs
