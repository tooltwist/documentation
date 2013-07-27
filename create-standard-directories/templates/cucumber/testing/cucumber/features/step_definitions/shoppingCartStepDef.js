var redis = require('redis').createClient();


var cartId = null;

var aTest = function () {
	this.World = require("../support/world.js").World;



	this.Given(/^a clean database$/, function(callback) {

		// Clear out existing carts from REDIS
//		console.log("Deleting existing carts");
		redis.keys("cart-*", function(err, replies){
			if (err) return callback(err);
		    replies.forEach(function (key, i) {
//		        console.log("  deleting key " + key);
		        redis.del(key);
		    });
			callback();
		});

	});



	this.Given(/^the shopping cart from the previous scenario$/, function(callback) {
	  // Nothing to do here
	  callback();
	});



	this.When(/^I call the web service to create a new shopping cart$/, function(callback) {

		// The GET method is defined in world.js
//		console.log("Creating a new cart");
		this.GET('http://localhost:8080/newCart', callback, function(json){
			cartId = json.cartId;
//			console.log("  new cart is " + cartId);
			callback();
		});
	});



	this.When(/^I add (\d+) of product (\d+) to the shopping cart$/, function(qty, productId, callback) {

		// Add the item to the shopping cart
		var json = {
				cartId : cartId,
				productId: productId,
				qty: qty
		};
		this.POST('http://localhost:8080/addToCart', json, callback, function(json){
//			console.log("Have cart ", cart);
			callback();
		});
	});



	this.When(/^I delete the shopping cart$/, function(callback) {
		this.DEL('http://localhost:8080/cart/'+cartId, callback, function(json){
//			console.log("  reply is " + json);
			return callback();
		});
	});



	this.Then(/^the shopping cart should be in the database$/, function(callback) {

		// Get the cart details from the DB
//		console.log("Getting cart " + cartId);

		redis.get('cart-'+cartId, function(err, value) {

			// Add to the database
			if (value == null) {

				// The cart does not exist in REDIS
				return callback.fail(new Error("Cart not found in REDIS: " + cartId));

			} else {

				// The cart was found in REDIS. Check it can be parsed
				try {

					// Convert from a string to JSON
					cart = JSON.parse(value);
//					console.log("  got cart " + cart);
					return callback(); // All is ok

				} catch(err) {

					// Error parsing the string into JSON
					return callback.fail(new Error("Could not parse cart " + cartId = " from REDIS"));
				}
			}
		});
	});



	this.Then(/^the shopping cart should contain (\d+) of product (\d+)$/, function(qty, productId, callback) {

		// Select the cart and check the contents
		this.GET('http://localhost:8080/cart/'+cartId, callback, function(json){
			var cart = json;
//			console.log("  cart is now ", json);
			for (var i = 0; i < cart.items.length; i++) {
				var item = cart.items[i];
//				console.log("item " + i + " is ", item);
				if (item.productId == productId) {
//					console.log("Found product");
					if (item.qty == qty)
						return callback(); // All ok
					else
						return callback.fail(new Error("Expected " + qty + " of product " + productId + " but found " + item.qty));
				}
			}
			callback.fail(new Error("Product " + productId + " not in the shopping cart"));
		});
	});



	this.Then(/^the shopping cart should not contain product (\d+)$/, function(arg1, callback) {

		// Select the cart and check the contents
		this.GET('http://localhost:8080/cart/'+cartId, callback, function(json){
			var cart = json;
//			console.log("  cart is now ", json);
			for (var i = 0; i < cart.items.length; i++) {
				var item = cart.items[i];
//				console.log("item " + i + " is ", item);
				if (item.productId == productId) {
					return callback.fail(new Error("The shopping cart should not contain product " + productId));
				}
			}
			return callback(); // All ok
		});
	});



	this.Then(/^the shopping cart should not exist in the database$/, function(callback) {

		// Get the cart details from the DB
//		console.log("Getting cart " + cartId);

		redis.get('cart-'+cartId, function(err, value) {

			// Add to the database
			if (value == null) {

				// All is ok
				return callback();
			} else {

				// The cart still exists in REDIS
				return callback.fail(new Error("Cart was not removed from REDIS"));
			}
		});
	});




};

module.exports = aTest;
