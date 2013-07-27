---
category: example
path: '/thing/:id'
title: 'Delete a thing'
type: 'DELETE'

layout: nil
---

This method deletes a 'thing'.

### Request

* **`:id`** is the id the product to delete.
* The headers must include a **valid authentication token**.
* **The body is omitted**.

### Response

Sends back a collection of things.

```Status: 200 OK```
```{
    code: 200,
    message: 'Your thing (id: 736) was deleted'
}```

For errors responses, see the [response status codes documentation](#response-status-codes).
