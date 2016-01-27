---
title: "Develop Rules for devices"
---

# Develop Rules for devices

SAMI Rules are a way to trigger device Actions based on SAMI messages. Any SAMI device owner can quickly and intuitively define smart device interactions via the <a href="https://blog.samsungsami.io/data/rules/iot/2015/09/23/sami-rules-make-your-devices-work-together.html" target="_blank">Rules UI in the User Portal</a>. Using the Rules APIs, developers can programmatically create and manage Rules for a device owner within an application.

This article is an introduction to development using the Rules API. Below, we cover some basic Rules APIs, explain how the [Rule body](#the-rule-body) is structured, and describe a case of [invalid Rules](#invalid-rules).

## Rules administration

Some basic APIs are summarized below. For the complete Rules API specification, see the [API spec](/sami/api-spec.html#rules).

When the Rule body is returned, it is formatted as a JSON object. The structure is explained in [**The Rule Body**](#the-rule-body).
{:.info}

### Getting Rules

`GET /rules`
{:.pa.param.http}

This call returns all of the current application's Rules. To get Rules for a user other than that specified by the token, you can query their user ID `uid`{:.param} in the URL. See the API [here](/sami/api-spec.html#get-rules).

### Getting a specific Rule

`GET /rules/<ruleId>`
{:.pa.param.http}

You can also retrieve a Rule by its unique Rule ID, `ruleId`{:.param}. This returns the Rule body in JSON format, along with information such as the corresponding user ID, the Rule name and description, and whether or not the Rule is enabled. See the API [here](/sami/api-spec.html#get-a-rule).

### Creating a Rule

`POST /rules`
{:.pa.param.http}

To create a Rule, you must POST the Rule name and body in the request body. You may also optionally include the Rule description and enable or disable the Rule. See the API [here](/sami/api-spec.html#create-a-rule).

### Updating a Rule

`PUT /rules/<ruleId>`
{:.pa.param.http}

The same request body parameters used to [create a Rule](#creating-a-rule) can be modified with this call, using the Rule ID. See the API [here](/sami/api-spec.html#update-a-rule).

### Testing an Action

`POST /rules/<ruleId>/actions`
{:.pa.param.http}

With this call you can test-run the [Actions](#actions) associated with the Rule, using the Rule ID (`ruleId`{:.param}).

Any testable Actions will actually be sent to your device, so be prepared!
{:.warning}

An Action is testable if the definition of the Action is static. This means:

* There is no device [defined by a "matched" selector](#define-a-source-device) (i.e., the device is defined dynamically by a condition matched).
* There is no `valueFrom`{:.param} used to [define the Action parameters](#define-the-action-parameters) (i.e., a [value is defined dynamically](#dynamic-value-definitions) by a condition matched).

In case any Action is not testable, the POST request returns a 400 error and no Action will be executed (including those which are testable). See [**Invalid Rules**](#invalid-rules) for the error code format. 
{:.info}

## The Rule body

As seen above, the Rule body is formatted in JSON. At the top level, the body has two objects as below. An "if" object defines the conditions; a "then" object defines the Actions to send to a [specified destination device](#define-a-destination-device) once the conditions are met.

~~~json
{ 
  "if": { 
    ...
  },
  "then": {
    ...
  }
}
~~~

### Conditions

SAMI checks all incoming messages against the conditions specified in each Rule.

In order to trigger a Rule, *all* conditions must be met.
{:.info}

Rule conditions are defined in an "if" structure wrapped by an "and" operator.

~~~json
{ 
  "if": { 
    "and": [
    ]
  } 
}
~~~

A condition is defined with at least one SAMI device `field`{:.param}. An `operator`{:.param} compares the field value from the incoming message to a user-specified `operand`{:.param} value.

~~~json
{ 
  "if": { 
    "and": [ { 
      "sdid": ... the device...,
      "field": ... the field...,
      "operator": ... the operator...,
      "operand": { "value": ... the value... }
    } ]
  } 
}
~~~

Now let's look at each piece of the Rule condition.

#### Define a source device

You can define the source device `sdid`{:.param} that triggers a Rule condition by specifying its device ID. 

~~~json
{
  "sdid": "d1111aaaa",
  ...
}
~~~

Alternatively, a Rule condition can trigger if "any" device (owned by the user) of a [device type](/sami/sami-documentation/sami-basics.html#device-id-and-device-type) matches the condition. Use `dtid`{:.param} to specify the device type ID.

~~~json
{ 
  "sdid": {
    "selector": "any",
    "dtid": "dt777eeee"
  },
  ...
}
~~~

A Rule condition can also trigger if "every" device (owned by the user) of a device type matches the condition.

~~~json
{ 
  "sdid": {
    "selector": "every",
    "dtid": "dt777eeee"
  },
  ...
}
~~~

If your Rule has multiple conditions, you can only define *one* "any" for a specific device type. To have more than one condition using this "any" device, do the following: 

The first condition using this "any" device should specify an "any" selector. The following conditions that also use this "any" device should specify a "matched" selector. 

All conditions should match on the same source device.
{:.info}

~~~
{ 
  "if": { 
    "and": [ { 
        "sdid": {
          "selector": "any",
          "dtid": "dt1”
        },
        ...
      },{ 
        "sdid": {
          "selector": "any",
          "dtid": "dt2”
        },
        ...
      }, {
        "sdid": {
          "selector": "matched",
          "dtid": "dt2”
        },
        ...
      }, {
        "sdid": {
          "selector": "matched",
          "dtid": "dt1”
        },
        ...
      }
    ]
  } 
}
~~~

#### Define the device field

A Rule condition tests the specified device `field`{:.param}. This must be a valid field for the specified source device, `sdid`{:.param}.

~~~json
{
  "sdid": "d1111aaaa",
  "field": "steps.walking.count",
  ...
}
~~~

Some fields can be defined using groups in a hierarchy. Above, the groups and the final field `count` are separated with "."

Read our <a href="https://blog.samsungsami.io/portals/development/data/2015/03/26/the-simple-manifest-device-types-in-1-minute.html" target="_blank">blog post about the Simple Manifest</a> to learn more about device fields and groups.

#### Define the operator

The `operator`{:.param} tests whether or not the condition is true.

~~~json
{
  "sdid": "d1111aaaa",
  "field": "state",
  "operator": "=",
  ...
}
~~~

Below are the possible operators, dependent on the valueClass of the field:

|valueClass of the field |valid operators
|----------------------- |----------------
|all valueClasses |`=`, `!=`<br><br>`is in message`, `is not in message`
|String |`<`, `<=`, `>`, `>=`<br><br>`contains`, `does not contain`
|Long, Double, Float |`<`, `<=`, `>`, `>=`
|Boolean |No additional operators

#### Define the operand

The operator compares the `operand`{:.param} value to that of the incoming message field.

~~~json
{
  "sdid": "d1111aaaa",
  "field": "state",
  "operator": "=",
  "operand": { "value": "on" }
}
~~~

### Example conditions

Below are examples of conditions, using the syntax described above.

If the state of my bedroom's lightbulb is **on**:

~~~json
{
  "if": {
    "and": [ {
      "sdid": "d1111aaaa",
      "field": "state",
      "operator": "=",
      "operand": { "value": "on" }
    } ]
  },
  ...
}
~~~

If the state of *any* of my lightbulbs is **on**:

~~~json
{
  "if": {
    "and": [ {
      "sdid": {
        "selector": "any",
        "dtid": "dt777eeee"
      },
      "field": "state",
      "operator": "=",
      "operand": { "value": "on" }
    } ]
  },
  ...
}
~~~

If the state of any of my lightbulbs is **on** *and* the light color is **red**:

~~~json
{
  "if": {
    "and": [ {
      "sdid": {
        "selector": "any",
        "dtid": "dt777eeee"
      },
      "field": "state",
      "operator": "=",
      "operand": { "value": "on" }
    }, {
      "sdid": {
        "selector": "matched",
        "dtid": "dt777eeee"
      },
      "field": "color",
      "operator": "=",
      "operand": { "value": "red" }
    } ]
  },
  ...
}
~~~

If *all* of my lightbulbs are **on**:

~~~json
{
  "if": {
    "and": [ {
      "sdid": {
        "selector": "every",
        "dtid": "dt777eeee"
      },
      "field": "state",
      "operator": "=",
      "operand": { "value": "on" }
    } ]
  },
  ...
}
~~~

### Actions

If conditions of a Rule are met, the Actions of the Rule are sent.

Rule Actions are defined in a "then" structure: 

~~~json
{ 
  "then": {
    ...
  }
}
~~~

An Action is defined with a destination device that receives the Action, and an Action to send with some parameters (see below).

SAMI supports multiple Actions for each Rule. If the Rule conditions are met, *all* Actions will be sent.
{:.info}

#### Define a destination device

You can define the destination device `ddid`{:.param} that receives Rule Actions by specifying its device ID.

~~~json
{
  "ddid": "d1111aaaa",
  ...
}
~~~

Alternatively, you can use the device that matched one of the ["any" conditions](#define-a-source-device) of the Rule:

~~~json
{ 
  "ddid": {
    "selector": "matched",
    "dtid": "dt777eeee"
  },
  ...
}
~~~

And you can also send the Action to "every" device of a device type:

~~~json
{ 
  "ddid": {
    "selector": "every",
    "dtid": "dt777eeee"
  },
  ...
}
~~~

#### Define the Action to send

A Rule sends the specified `action`{:.param}. This must be a valid Action for the specified destination device, `ddid`{:.param}.

~~~json
{
  "ddid": "d1111aaaa",
  "action": "setOn",
  ...
}
~~~

To learn more about Actions, read [**Posting a message with Actions**](/sami/sami-documentation/sending-and-receiving-data.html#posting-a-message-with-actions).
{:.info}

#### Define the Action parameters

Some Actions include parameters. Below, the value of the parameter is defined under `parameters`{:.param}:

~~~json
{
  "ddid": "d1111aaaa",
  "action": "setColor",
  "parameters": {
    "colorName": {
      "value": "red"
    }
  }
}
~~~

Below is a compound parameter:

~~~json
{
  "ddid": "d1111aaaa",
  "action": "setColor",
  "parameters": {
    "colorRGB": {
      "value": {
        "r": { "value": 255 },
        "g": { "value": 0 },
        "b": { "value": 0 },
      }
    }
  }
}
~~~

And here are multiple parameters:

~~~json
{
  "ddid": "d1111aaaa",
  "action": "setColor",
  "parameters": {
    "r": { "value": 255 },
    "g": { "value": 0 },
    "b": { "value": 0 },
  }
}
~~~

### Example Rules

Below are examples of Actions with conditions, using the syntax described above.

If the state of my bedroom's *first* lightbulb is **on**, then **turn on** my bedroom's *second* lightbulb: 

~~~json
{
  "if": {
    "and": [ {
      "sdid": "d1111aaaa",
      "field": "state",
      "operator": "=",
      "operand": { "value": "on" }
    } ]
  },
  "then": [ {
    "ddid": "d2222aaaa",
    "action": "setOn",
  } ]
}
~~~

If the state of *any* of my lightbulbs is **on**, then **set their color** to red:

~~~json
{
  "if": {
    "and": [ {
      "sdid": {
        "selector": "any",
        "dtid": "dt777eeee"
      },
      "field": "state",
      "operator": "=",
      "operand": { "value": "on" }
    } ]
  },
  "then": [ {
    "ddid": "d1111aaaa",
    "action": "setColor",
    "parameters": {
    "colorName": {
      "value": "red"
    }
  } ]
}
~~~

If the temperature of the room is **more than 72°F**, then **turn on** my bedroom's light and **set the color** to red:

~~~json
{
  "if": {
    "and": [ {
      "sdid": "d333bbbb",
      "field": "temperature",
      "operator": ">=",
      "operand": { "value": 72 }
    } ]
  },
  "then": [ {
      "ddid": "d1111aaaa",
      "action": "setOn",
    }, {
      "ddid": "d1111aaaa",
      "action": "setColor",
      "parameters": {
        "colorRGB": {
          "value": {
            "r": { "value": 255 },
            "g": { "value": 0 },
            "b": { "value": 0 },
          }
        }
      }
    }
  ]
}
~~~

## Advanced Rules

So far, we have discussed how to construct a Rule body to define basic Rules. SAMI also allows developers to create advanced Rules, which we describe below.

### Dynamic value definitions

Rather than specifying a static value in your Rule (e.g., for the condition [operand](#define-the-operand) or an Action [parameter](#define-the-action-parameters)), you may want to use a value from an incoming message or a specific device. Or you might want to compare the field value from an incoming message to the value in another device.

You can *dynamically* define the value from a device field. This is accomplished by replacing `value`{:.param} in the Rule with `valueFrom`{:.param}, where a device and field are also specified:

~~~json
"valueFrom": {
  "sdid": ...,
  "field": ...
}
~~~

Read <a href="https://blog.samsungsami.io/rules/iot/2015/10/13/sami-rules-your-devices-can-speak-up.html" target="_blank">**this blog post**</a> to learn how values can be dynamically defined within the User Portal.
{:.info}

#### Define valueFrom device

The source device `sdid`{:.param} can be defined from its device ID:

~~~json
"valueFrom": {
  "sdid": "d1111aaaa",
  "field": ...
}
~~~

You can also use a "matched" selector. This selects a device of a specified device type that has been matched in an ["any" condition](#define-a-source-device):

~~~json
"valueFrom": {
  "sdid": {
    "selector": "matched",
    "dtid": "dt777eeee"
  },
  "field": ...
}
~~~

#### Define valueFrom field

The device field is defined [as in a Rule condition](#define-the-device-field).

### Applying operations to values

Before using a value from a device field as a parameter or condition value, you may also perform an operation on the value, using a combination of `value`{:.param} and `valueFrom`{:.param}. 

An operation replaces `value`{:.param} or `valueFrom`{:.param}. For example, if a temperature value is normally specified as:

~~~json
"value": 72
~~~

You can use the following operation to specify the temperature plus 5 degrees.

~~~json
"add": [ 
  {
    "valueFrom":  {
      "sdid": "d333bbbb",
      "field": "temperature"
    }
  }, { 
    "value": 5 
  }
]
~~~

Operations can be used to specify the value of both the condition and the Action parameter. The following example Rule sends an Action that displays the temperature in a string:

~~~json
{
  "if": {
    "and": [ {
      "sdid": "d333bbbb",
      "field": "temperature",
      "operator": ">=",
      "operand": { 
        "add": [ 
          {
            "valueFrom":  {
              "sdid": "d444cccc",
              "field": "temperature"
            }
          }, {
            "value": 5
          } 
       ]
     }
  },
  "then": [ {
      "ddid": "d5555cccc",
      "action": "display",
      "parameters": {
        "text": {
          "concat": [ 
            { 
              "value": "Temperature is " 
            }, {
              "valueFrom": {
                "sdid": "d333bbbb",
                "field": "temperature"
              }
            }, {
              "value": "°F"
            }
          ]
        }
      }
    }
  ]
}
~~~

These are the possible operations:

|Operator |Description |Result type |Cast rules
|-------- |----------- |----------- |----------
|`concat`{:.param} |concatenate |String |Numbers are casted to String<br><br>Boolean are casted to "true/"false"
|`add`{:.param} |addition |Number |Strings are casted to a number if possible; otherwise the string is replaced by "0"<br><br>Booleans are casted to 1/0
|`sub`{:.param} | subtraction |Number |Strings are casted to a number if possible; otherwise the string is replaced by "0"<br><br>Booleans are casted to 1/0


## Invalid Rules

A Rule may become invalid if, for example, the source or destination devices are deleted. In this case, rather than returning the Rule body in `data`{:.param}, the APIs will return an error code:

~~~json
{
  {
    "error": {
      "code": 4001
      "message": "Validation Error",
      "errors": [  [
            {
               "field":"location of the error ('.' separated string)",
               "messages":["Reason of the error"]
            }, ...
      ] ]
    }
  }
...
}
~~~