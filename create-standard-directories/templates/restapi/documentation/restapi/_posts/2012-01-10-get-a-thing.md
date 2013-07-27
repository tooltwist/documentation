---
category: example
path: '/thing/:id'
title: 'Get a thing'
type: 'GET'

layout: nil
---

This method allows users to retrieve a 'thing'.

### Request

* The headers must include a **valid authentication token**.

### Response

Sends back details of a single 'thing'.

```Status: 200 OK```
```{
    {
        id: thing_2,
        parent: 'Furniture'
	name: 'Tables and Chairs'
	description: 'Tables, chairs, and various related things to sit on or at.'
    }
}```

For errors responses, see the [response status codes documentation](#response-status-codes).


### Testing

curl hostname:port/thing/id
