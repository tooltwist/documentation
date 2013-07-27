---
category: example
path: '/thing'
title: 'Update a thing'
type: 'POST'

layout: nil
---

This method allows users to create a new 'thing'.

### Request

* The headers must include a **valid authentication token**.
* **The body can't be empty** and must include at least the name attribute, a `string` that will be used as the name of the thing.

```{
    id: '987',
    parent: 'Furniture'
    name: 'Tables and Chairs'
    description: 'Tables, chairs, and various related things to sit on or at.'
}```

#### Orderly definition
```object {
  integer id;
  string parent?;
  string name;
  string description;
}*;```

### Response

**If succeeds**, returns a status code of 'ok'.

```Status: 200 OK```
```{
    result: 'ok'
}```

For errors responses, see the [response status codes documentation](#response-status-codes).
