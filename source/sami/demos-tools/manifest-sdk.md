---
title: "Validate your Manifest"
---

# Validate your Manifest

As we mentioned in [The Manifest][1], validating your Manifest is a fundamental step before submitting it to SAMI. In this article, you'll learn how to use the Manifest SDK to test your Manifest [with a command-line tool](/sami/demos-tools/manifest-sdk.html#test-with-the-command-line-tool) and [in a Maven project.](/sami/demos-tools/manifest-sdk.html#test-in-a-maven-project)

We will be using a sample Manifest and a sample data file, which are included [at the end of this page.](/sami/demos-tools/manifest-sdk.html#sample-manifest-and-data-file)

In addition, please refer to the [Manifest SDK API specification](/sami/demos-tools/manifest-sdk-javadoc/) to learn a number of APIs that you can use to write Manifest tests. 

## Test with the command-line tool

To use the command-line tool, you will need the following:

 * Java 7
 * [Manifest SDK version 1.7](/sami/downloads/sami-manifest-sdk-1.7.jar)

The Manifest SDK is a JAR file that you can manually execute from the command line. The binary expects two files: the Manifest you want to test, and a file containing your sample data.

The binary can be executed in two ways. Longform:

~~~
java -jar sami-manifest-sdk-1.7.jar --manifest=<path_to_manifest_file> -data=<path_to_test_data_file>
~~~

And with more compact parameters:

~~~
java -jar sami-manifest-sdk-1.7.jar -m <path_to_manifest_file> -d <path_to_test_data_file>
~~~

The SDK will print straight to standard output. The output will include information on the file you tested, information on the `FieldDescriptors`  and a description of each processed field, including any conversions. You can catch Manifest errors by checking if any errors are recorded in the output and if all the fields look right to you.

Below is the sample output when executing the tool to validate the sample Manifest against the sample data file.

~~~
C:\manifest_learning>java -jar sami-manifest-sdk-1.7.jar -m MyDeviceManifest.groovy -d myDeviceData.csv
==============================================================================
Manifest File: MyDeviceManifest.groovy
Modified On: 11/06/2014 15:42:26
Manifest FieldDescriptors:
co2 FieldDescriptor[name: co2, normalizedUnit: ppm, valueClass: class java.lang.Integer]
temp FieldDescriptor[name: temp, normalizedUnit:  °C, valueClass: class java.lang.Integer]
noise FieldDescriptor[name: noise, normalizedUnit: dB, valueClass: class java.lang.Integer]
==============================================================================
Results after running manifest on provided data file:
Field[name: temp, value unit: °C, raw value unit: °F, value: 18, raw value: 65, field descriptor: FieldDescriptor[name: temp, normalizedUnit: °C, valueClass: class java.lang.Integer]]
Field[name: noise, value unit: dB, raw value unit: dB, value: 62, raw value: 62, field descriptor: FieldDescriptor[name: noise, normalizedUnit: dB, valueClass: class java.lang.Integer]]
Field[name: co2, value unit: ppm, raw value unit: ppm, value: 602, raw value: 602, field descriptor: FieldDescriptor[name: co2, normalizedUnit: ppm,valueClass: class java.lang.Integer]]
==============================================================================
~~~

The field `temp` above shows an example of [data normalization](/sami/sami-documentation/sami-basics.html#raw-and-normalized-data) in SAMI. The input value (raw value) `65` in raw value unit `°F` is converted to `18 °C` after normalization.

## Test in a Maven project

Testing your Manifest in a Maven project has two advantages over testing with the command-line tool:

- You can write more advanced tests to validate your Manifest more thoroughly.
- Manifest testing is automated as a part of the build process.

Let's use a sample Maven project to walk through the process of testing the Manifest in a Maven project using Eclipse IDE.

### Prerequisites

 * Java 7
 * [Eclipse](https://www.eclipse.org/)
 * [Maven Integration for Eclipse](https://www.eclipse.org/m2e/)
 * [Manifest SDK version 1.7](/sami/downloads/sami-manifest-sdk-1.7.jar)
 * [Sample Maven project](/sami/downloads/sami-manifest-demo.zip)

### Quick start

In Eclipse, import the downloaded sample Maven project as "Existing Maven Projects".

To use the downloaded Manifest SDK in the Maven project, you need to install the SDK JAR in the Maven repository. In Eclipse, click `Run` -> `Run Configurations` -> `Maven Build`. Then fill in the following information at the new configuration window:

- **Base directory:** The directory that Eclipse uses to search for SDK JAR file 
- **Goals:** install:install-file 
- Add the following parameters as "Parameter Name" and "Value" pairs:
  - **file:** path and name of SDK JAR file e.g. sami-manifest-sdk-1.7.jar
  - **groupId:** com.samsung.sami.manifest
  - **artifactId:** sami-manifest-sdk
  - **version:** 1.7
  - **packaging:** jar

![Alt Add Manifest SDK to Maven repository in Eclipse](/images/docs/sami/demos-tools/manifestsdk_install_to_maven_repository_eclipse.png){:.lightbox}

Click "Run" on the above "Run Configurations" window to install the Manifest SDK in your Maven repository. Now right-click the sample project in Eclipse, choose "Run As" and "Maven test". You should see that the test passes in Eclipse console as the following:

~~~
-------------------------------------------------------
 T E S T S
-------------------------------------------------------
Running com.mycompany.mydevice.TestMyDevice
=== runGroovyManifest ===
manifestFile:  /manifests/MyDeviceManifest.groovy - dataFile: /data/myDeviceData.csv
Reading resource file: /manifests/MyDeviceManifest.groovy
Reading resource file: /data/myDeviceData.csv
=== runGroovyManifest: done.
Field[name: temp, field descriptor: FieldDescriptor[name: temp, normalizedUnit: °C, valueClass: class java.lang.Integer], unit: °F, value: 18]
Field[name: co2, field descriptor: FieldDescriptor[name: co2, normalizedUnit: ppm, valueClass: class java.lang.Integer], unit: ppm, value: 602]
Field[name: noise, field descriptor: FieldDescriptor[name: noise, normalizedUnit: dB, valueClass: class java.lang.Integer], unit: dB, value: 62]
Tests run: 1, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 0.603 sec

Results :

Tests run: 1, Failures: 0, Errors: 0, Skipped: 0

[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 1.875 s
[INFO] Finished at: 2014-11-06T15:42:39-08:00
[INFO] Final Memory: 7M/154M
[INFO] ------------------------------------------------------------------------~~~
~~~

### The sample Maven project in detail

There are three important files in this sample project:

- `PROJECT_ROOT\src\test\resources\manifests\MyDeviceManifest.groovy`
- `PROJECT_ROOT\src\test\resources\data\MyDeviceData.csv`
- `PROJECT_ROOT\src\test\java\com\mycompany\mydevice\TestMyDevice.java`

The first two are the Manifest and data files. The last one is a unit test file, whose content is shown below:

~~~java
package com.mycompany.mydevice;

import com.samsung.sami.manifest.fields.Field;
import com.samsung.sami.manifest.test.ManifestTest;
import org.junit.Assert;
import org.junit.Test;

import java.io.IOException;
import java.util.Map;

/**
 * Sample test case
 */
public class TestMyDevice extends ManifestTest {

    @Test
    public void testMyDeviceManifest() throws IOException {
        String manifestPath = "/manifests/MyDeviceManifest.groovy";
        String dataPath = "/data/myDeviceData.csv";
        runManifestTest(manifestPath, dataPath);
    }

    private void runManifestTest(String manifestPath, String dataPath) throws IOException {
        Map<String, Field> fields = runGroovyManifest(manifestPath, dataPath);

        Assert.assertNotNull(fields);
        Assert.assertFalse(fields.isEmpty());
        printManifestRunResults(fields);

        // Verify that the Manifest produces the correct value for each field
        Assert.assertEquals(62, fields.get("noise").getValue());
        Assert.assertEquals(602, fields.get("co2").getValue());
        // Verify the value where there is data conversion.
        // The input raw unit is FAHRENHEIT while the normalized unit is CELSIUS 
        int tempInCelsius = (65-32)* 5/9;
        Assert.assertEquals(tempInCelsius, fields.get("temp").getValue());

    }

    private void printManifestRunResults(Map<String, Field> fields) {
        for (Field field : fields.values())
            System.out.println(field.toString());
    }
}
~~~

In the above test file, the data and Manifest files are provided. The test case does basic validation of the data against the Manifest, similarly to the SDK command-line tool. In addition, it also validates the values of the normalized data. You can add more validation to the test by using the [Manifest SDK Java APIs.](/sami/demos-tools/manifest-sdk-javadoc/)

### Integrate the Manifest SDK into your own Maven project

If you already have a Maven project, you can add Manifest SDK as a dependency, build Manifest tests and execute them as part of your project. 

To add the dependency, open your project's `pom` and add the following lines:

~~~xml
<dependency>
    <groupId>com.samsung.sami.manifest</groupId>
    <artifactId>sami-manifest-sdk</artifactId>
    <version>1.7</version>
</dependency>
~~~

> You also need to add the dependency to `junit` in your `pom` file if it is not already there. 

 Read more about [**project dependencies**](https://maven.apache.org/guides/introduction/introduction-to-dependency-mechanism.html) in Maven.
 {:.info}

Next, install Manifest SDK to the Maven repository. If you have [Eclipse](https://www.eclipse.org/) and [Maven Integration for Eclipse](https://www.eclipse.org/m2e/), you can follow the [installation steps detailed earlier](/sami/demos-tools/manifest-sdk.html#quick-start) to install the SDK to the repository. Otherwise, execute the following Maven command in the command-line to install:

~~~bash
mvn install:install-file -Dfile=sami-manifest-sdk-1.7.jar -DgroupId=com.samsung.sami.manifest -DartifactId=sami-manifest-sdk -Dversion=1.7 -Dpackaging=jar
~~~

Finally, you write your Manifest, a sample data file and unit tests. Add them to your project at the location similar to that in the above [sample Maven project.](#the-sample-maven-project-in-detail)

## Sample Manifest and data file

Here is `MyDeviceManifest.groovy` used for the above tests:

~~~java
import com.samsung.sami.manifest.Manifest
import com.samsung.sami.manifest.fields.*
import static com.samsung.sami.manifest.fields.StandardFields.*

import javax.measure.unit.NonSI

public class MyDeviceManifest implements Manifest {

  public final static FieldDescriptor TEMP_INTEGER = TEMPERATURE.alias(Integer.class);
  public final static FieldDescriptor NOISE = new FieldDescriptor("noise", NonSI.DECIBEL, Integer.class);
  public final static FieldDescriptor CO2 = new FieldDescriptor("co2", StandardUnits.PARTS_PER_MILLION, Integer.class);

  @Override
  List<Field> normalize(String input) {
    def fields = []
    def values = input.split(",")
    def tempInF = values[0].asType(Integer.class)
    def noise = values[1].asType(Integer.class)
    def co2 = values[2].asType(Integer.class)

    fields.add(new Field(TEMP_INTEGER, NonSI.FAHRENHEIT, tempInF))
    fields.add(new Field(NOISE, noise))
    fields.add(new Field(CO2, co2))

    return fields
  }
  
  @Override
  List<FieldDescriptor> getFieldDescriptors() {
    return [TEMP_INTEGER, NOISE, CO2]
  }
}
~~~

The data you put in the sample data file should be the content of the **data** field that is passed when sending messages with the messages API, without the metadata (`sdid`, `ts`, etc). The data file `myDeviceData.csv` looks like this:

~~~text
65,62,602
~~~

[1]: /sami/sami-documentation/the-manifest.html#manifest-certification "Manifest Certification"