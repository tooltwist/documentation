---
category: example
path: '/thing/new'
title: 'Create a thing'
type: 'POST'

layout: nil
---

This method allows users to create a new 'thing'.

### Request

* The headers must include a **valid authentication token**.
* **The body can't be empty** and must include at least the name attribute, a `string` that will be used as the name of the thing.

```{
    parent: 'Furniture'
    name: 'Tables and Chairs'
    description: 'Tables, chairs, and various related things to sit on or at.'
}```

#### Orderly definition
```object {
  string parent?;
  string name;
  string description;
}*;```

### Response

**If succeeds**, returns the created thing.

```Status: 201 Created```
```{
    id: new_thing,
    name: 'Tables and Chairs'
}```

For errors responses, see the [response status codes documentation](#response-status-codes).
