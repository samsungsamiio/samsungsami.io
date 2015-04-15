---
title: "Advanced Manifest examples"
---

# Advanced Manifest examples

You can use the APIs described in the [Manifest SDK API specification](/sami/demos-tools/manifest-sdk-javadoc/) and [Groovy utilities][1] to conveniently write Manifests to handle complicated data. Below, we give two examples of Advanced Manifests that illustrate how powerful the Groovy utilities can be, and one example of a [Manifest that supports actions][4].

These examples pertain to **Advanced Manifest** creation. Make sure to read the basics of the [Manifest](/sami/sami-documentation/the-manifest.html) and [Validate your Manifest](/sami/demos-tools/manifest-sdk.html) before proceeding. 

If you just want to quickly send data and skip the approval process, [**read these instructions**](https://blog.samsungsami.io/portals/development/data/2015/03/26/the-simple-manifest-device-types-in-1-minute.html) to create a Simple Manifest.
{:.info}

## Manifest example using JsonUtil

This example shows how to use the [`JsonUtil`][2] methods of [Groovy utilities][1]. As mentioned [earlier](/sami/sami-documentation/the-manifest.html#peek-into-the-basics), this Manifest is for the sample device type "Manifest SDK Sample Device". The data to be processed by the Manifest looks like:

~~~json
{
  "minTemp": 6,
  "maxTemp": 22.5,
  "distance": 150,
  "location": {
    "latitude": 37.422287,
    "longitude": -122.203766
  },
  "status": "on",
  "enabled": true,
  "disabled": false,
  "count": 22,
  "color": {
    "r": 1,
    "g": 2,
    "b": 3
    },
  "sampleBooleanArray": [true, false, true],
  "sampleDoubleArray": [1.23, 2.34, 3.45],
  "sampleFloatArray": [1.23, 2.34, 3.45],
  "sampleIntegerArray": [1, 2, 3],
  "sampleLongArray": [1, 2, 3],
  "sampleStringArray": ["1", "2", "3"]
}
~~~

Here is the Manifest that processed the above data:

~~~java
import groovy.json.JsonSlurper
import javax.measure.unit.NonSI
import com.samsung.sami.manifest.Manifest
import com.samsung.sami.manifest.fields.*
import static com.samsung.sami.manifest.fields.StandardFields.*
import static com.samsung.sami.manifest.groovy.JsonUtil.*

public class TestJsonUtilGroovyManifest implements Manifest {
    // Custom FieldDesc
    static final STATUS = new FieldDescriptor("status", String.class)
    static final SAMPLE_BOOLEAN_ARRAY = new FieldDescriptor("sampleBooleanArray", Boolean.class, true)
    static final SAMPLE_DOUBLE_ARRAY = new FieldDescriptor("sampleDoubleArray", Double.class, true)
    static final SAMPLE_FLOAT_ARRAY = new FieldDescriptor("sampleFloatArray", Float.class, true)
    static final SAMPLE_INTEGER_ARRAY = new FieldDescriptor("sampleIntegerArray", Integer.class, true)
    static final SAMPLE_LONG_ARRAY = new FieldDescriptor("sampleLongArray", Long.class, true)
    static final SAMPLE_STRING_ARRAY = new FieldDescriptor("sampleStringArray", String.class, true)

    @Override
    List<Field> normalize(String input) {
        def slurper = new JsonSlurper()
        def json = slurper.parseText(input)

        def fields = []

        addToList(fields, json, "minTemp", NonSI.FAHRENHEIT, MIN_TEMPERATURE)
        addToList(fields, json, "maxTemp", NonSI.FAHRENHEIT, MAX_TEMPERATURE)
        addToList(fields, json, NonSI.FOOT, DISTANCE)
        addToList(fields, json, ENABLED)
        addToList(fields, json, DISABLED)
        addToList(fields, json, COUNT)

        if (json.containsKey("location")) {
            def jsonLocation = json.location
            addToList(fields, jsonLocation, "latitude", LATITUDE)
            addToList(fields, jsonLocation, "longitude", LONGITUDE)
        }

        if (json.containsKey("color")) {
            def jsonColor = json.color
            def cfields = []
            addToList(cfields, jsonColor, COLOR_RED_COMPONENT)
            addToList(cfields, jsonColor, COLOR_GREEN_COMPONENT)
            addToList(cfields, jsonColor, COLOR_BLUE_COMPONENT)
            fields.add(new Field(COLOR_AS_RGB, false, cfields))
        }

        addToList(fields, json, STATUS)

        addToList(fields, json, SAMPLE_BOOLEAN_ARRAY)
        addToList(fields, json, SAMPLE_DOUBLE_ARRAY)
        addToList(fields, json, SAMPLE_FLOAT_ARRAY)
        addToList(fields, json, SAMPLE_INTEGER_ARRAY)
        addToList(fields, json, SAMPLE_LONG_ARRAY)
        addToList(fields, json, SAMPLE_STRING_ARRAY)

        return fields
    }

    @Override
    List<FieldDescriptor> getFieldDescriptors() {
        return [
            MIN_TEMPERATURE,
            MAX_TEMPERATURE,
            DISTANCE,
            LATITUDE,
            LONGITUDE,
            STATUS,
            ENABLED,
            DISABLED,
            COUNT,
            COLOR_AS_RGB,
            SAMPLE_INTEGER_ARRAY,
            SAMPLE_BOOLEAN_ARRAY,
            SAMPLE_DOUBLE_ARRAY,
            SAMPLE_FLOAT_ARRAY,
            SAMPLE_INTEGER_ARRAY,
            SAMPLE_LONG_ARRAY,
            SAMPLE_STRING_ARRAY
        ]
    }
}
~~~

## Manifest example using StringFieldUtil

This example shows how to use [`StringFieldUtil`][3] methods of [Groovy utilities][1]. The data to be processed by the Manifest looks like:

~~~xml
<xml>
    <fields>
        <field name="minTemp">6</field>
        <field name="maxTemp">22.5</field>
        <field name="distance">150</field>
        <fields name="location">
            <field name="latitude">37.422287</field>
            <field name="longitude">-122.203766</field>
        </fields>
        <field name="status">on</field>
        <field name="enabled">true</field>
        <field name="disabled">false</field>
        <field name="count">22</field>
        <fields name="color">
            <field name="r">1</field>
            <field name="g">2</field>
            <field name="b">3</field>
        </fields>
    </fields>
</xml>
~~~

Here is the Manifest that processed the above data:

~~~java
import javax.measure.unit.*
import com.samsung.sami.manifest.Manifest
import com.samsung.sami.manifest.fields.*
import static com.samsung.sami.manifest.fields.StandardFields.*
import static com.samsung.sami.manifest.groovy.StringFieldUtil.*

public class TestXmlUtilGroovyManifest implements Manifest {
    // Custom FieldDesc
    static final STATUS = new FieldDescriptor("status", String.class)

    @Override
    List<Field> normalize(String input) {
        def xml = new XmlSlurper().parseText(input)
        def fields = []

        for ( field in xml.fields.children()) {
            switch (field.@name) {
                case "minTemp":
                    addToList(fields, field.text(), NonSI.FAHRENHEIT, MIN_TEMPERATURE)
                    break;
                case "maxTemp":
                    addToList(fields, field.text(), NonSI.FAHRENHEIT, MAX_TEMPERATURE)
                    break;
                case "distance":
                    addToList(fields, field.text(), NonSI.FOOT, DISTANCE)
                    break;
                case "enabled":
                    addToList(fields, field.text(), ENABLED)
                    break;
                case "disabled":
                    addToList(fields, field.text(), DISABLED)
                    break;
                case "count":
                    addToList(fields, field.text(), COUNT)
                    break;
                case "status":
                    addToList(fields, field.text(), STATUS)
                    break;
                case "location":
                    addLocation(fields, field)
                    break;
                case "color":
                    addColor(fields, field)
                    break;
            }
        }
        return fields
    }

    static def addLocation(fields, parent) {
        for ( field in parent.children()) {
            switch (field.@name) {
                case "latitude":
                    addToList(fields, field.text(), LATITUDE)
                    break;

                case "longitude":
                    addToList(fields, field.text(), LONGITUDE)
                    break;
            }
        }
    }

    static def addColor(fields, parent) {
        def cfields = []
        for ( field in parent.children()) {
            switch (field.@name) {
                case "r":
                    addToList(cfields, field.text(), COLOR_RED_COMPONENT)
                    break;

                case "g":
                    addToList(cfields, field.text(), COLOR_GREEN_COMPONENT)
                    break;

                case "b":
                    addToList(cfields, field.text(), COLOR_BLUE_COMPONENT)
                    break;
            }
        }

        if (cfields.size() == 3) {
            fields.add(new Field(COLOR_AS_RGB, false, cfields))
        }
    }

    @Override
    List<FieldDescriptor> getFieldDescriptors() {
        return [
            MIN_TEMPERATURE,
            MAX_TEMPERATURE,
            DISTANCE,
            LATITUDE,
            LONGITUDE,
            STATUS,
            ENABLED,
            DISABLED,
            COUNT,
            COLOR_AS_RGB,
        ]
    }
}
~~~

## Manifest that supports actions

This Manifest example defines the actions that the device type can support. Below is an example of a message payload that includes actions. Once the target device receives such a message, it should perform `setOn` and `setColorAsRGB` using the corresponding parameters.

~~~json
{
  "actions": [
    {
        "name": "setOn",
        "parameters": {}
    },
    {
        "name": "setColorAsRGB",
        "parameters": {
            "colorRGB": {
                "r": 192,
                "g": 180,
                "b": 45
            },
            "intensity": 55
        }
    }
  ]
}
~~~

Here is the Manifest that defines the actions: 

~~~java
import com.samsung.sami.manifest.Manifest
import com.samsung.sami.manifest.actions.*
import com.samsung.sami.manifest.fields.*
import static com.samsung.sami.manifest.fields.StandardFields.*
import static com.samsung.sami.manifest.groovy.JsonUtil.*
import groovy.json.JsonSlurper
import javax.measure.unit.SI
 
public class SmartLightManifest implements Manifest, Actionable {
    public final static FieldDescriptor INTENSITY = new FieldDescriptor("intensity", "Changes the intensity of the hue light (value in percent)", Integer.class);

    @Override
    List<Field> normalize(String input) {
        def slurper = new JsonSlurper()
        def json = slurper.parseText(input)
        
        def fields = []
        
        addToList(fields, json, STATE)

        addToList(fields, json, INTENSITY)

        if (json.containsKey("colorRGB")) {
            def jsonColor = json.colorRGB
            def cfields = []
            addToList(cfields, jsonColor, COLOR_RED_COMPONENT)
            addToList(cfields, jsonColor, COLOR_GREEN_COMPONENT)
            addToList(cfields, jsonColor, COLOR_BLUE_COMPONENT)
            fields.add(new Field(COLOR_AS_RGB, false, cfields))
        }

        return fields
    }

    @Override
    List<FieldDescriptor> getFieldDescriptors() {
        return [STATE, COLOR_AS_RGB, INTENSITY]
    }
    @Override
    List<Action> getActions() {
        return [
            new Action("setOn", "Sets the light state to On"),
            new Action("setOff", "Sets the light state to Off"),
            new Action("setIntensity", "Changes the intensity of the hue light (value in percent)",
                    INTENSITY),
            new Action("setColorAsRGB", "Changes the light color with RGB values and set the intensity (value in percent)",
                    COLOR_AS_RGB, INTENSITY),
        ]
    }
}
~~~

[1]: /sami/sami-documentation/the-manifest.html#groovy-utilities "Groovy Utilities"
[2]: /sami/sami-documentation/the-manifest.html#jsonutil "JsonUtil"
[3]: /sami/sami-documentation/the-manifest.html#stringfieldutil "StringFieldUtil"
[4]: /sami/sami-documentation/the-manifest.html#manifests-that-support-actions "Manifest that supports Actions"