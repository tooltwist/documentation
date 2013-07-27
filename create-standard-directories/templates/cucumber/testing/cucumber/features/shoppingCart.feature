@ignore
Feature: Testing the shopping cart
	In order to take orders
	As an external application calling TEA
	I want to be able to manipulate the shopping cart

	Scenario: Creating a new shopping cart
		Given a clean database
		When I call the web service to create a new shopping cart
		Then the shopping cart should be in the database

	Scenario: Adding to the shopping cart
		Given the shopping cart from the previous scenario
		When I add 2 of product 63 to the shopping cart
		Then the shopping cart should contain 2 of product 63

	Scenario: Changing the product qty in the shopping cart
		Given the shopping cart from the previous scenario
		When I add 7 of product 63 to the shopping cart
		Then the shopping cart should contain 7 of product 63

	Scenario: Removing a product from the shopping cart
		Given the shopping cart from the previous scenario
		When I add 0 of product 63 to the shopping cart
		Then the shopping cart should not contain product 63

	Scenario: Adding multiple items to the shopping cart
		Given the shopping cart from the previous scenario
		When I add 1 of product 63 to the shopping cart
		And I add 2 of product 64 to the shopping cart
		And I add 3 of product 65 to the shopping cart
		Then the shopping cart should contain 1 of product 63
		And the shopping cart should contain 2 of product 64
		And the shopping cart should contain 3 of product 65

	Scenario: Removing the shopping cart
		Given the shopping cart from the previous scenario
		When I delete the shopping cart
		Then the shopping cart should not exist in the database
