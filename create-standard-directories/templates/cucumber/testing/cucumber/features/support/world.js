var request = require('request');

var World = function (callback) {
	// set up code goes here


	/**
	 *	Call a URL, and fail this test unless SUCCESS is returned.
	 */
	this.GET = function(url, cucumber_callback, my_callback) {

		// https://github.com/mikeal/request
		request(url, function (error, response, body) {

			if (error) {
				return cucumber_callback(error);
			} else if (response.statusCode != 200) {
		        //console.log("Body is " + body);
		        cucumber_callback.fail(new Error("Unexpected status code " + response.statusCode));
			} else {

				// Normal return. Parse the JSON
//				console.log(body);
				var json = JSON.parse(body);
//				console.log("JSON is " + json);
				my_callback(json);
			}

		});
	};


	/**
	 *	POST to a web service
	 */
	this.POST = function(url, json, cucumber_callback, my_callback) {

		// https://github.com/mikeal/request
//		console.log("POST, url=" + url + ", json=", json);
		request({
			method: 'POST',
			url: url,
			json: json
		}, function (error, response, body) {

//			console.log("Back, error="+error, body);

			if (error) {
				return cucumber_callback(error);
			} else if (response.statusCode != 200) {
		        //console.log("Body is " + body);
		        cucumber_callback.fail(new Error("Unexpected status code " + response.statusCode));
			} else {

				// Normal return. Should be a JSON object.
//				console.log(body);
				// console.log("type=" + typeof(body));
				// var json = JSON.parse(body);
				// console.log("JSON is ",json);
				my_callback(body);
			}
		});
	};




	/**
	 *	Send DEL to a web service
	 */
	this.DEL = function(url, cucumber_callback, my_callback) {

		// https://github.com/mikeal/request
//		console.log("DEL, url=" + url);
		request({
			method: 'DELETE',
			url: url
		}, function (error, response, body) {

//			console.log("Back, error="+error, body);

			if (error) {
				return cucumber_callback(error);
			} else if (response.statusCode != 200) {
		        //console.log("Body is " + body);
		        cucumber_callback.fail(new Error("Unexpected status code " + response.statusCode));
			} else {

				// Normal return. Should be a JSON object.
//				console.log(body);
				// console.log("type=" + typeof(body));
				// var json = JSON.parse(body);
				// console.log("JSON is ",json);
				my_callback(body);
			}
		});
	};


	// last line to tell cucumber.js the World is ready.
	callback(this);
};


exports.World = World;

