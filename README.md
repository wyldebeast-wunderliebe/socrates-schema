socrates-schema
===============

Introduction
------------

Survey schema tools for Socrates.

The schema is defined in survey.xsd. To test your survey model against the
schema, you might use xmllint like so:

    xmllint --schema survey.xsd --noout <your xml model>


The schema
----------

The survey consists of four (main) parts:

1. data
2. model
3. layout
4. submission

For i18n the new survey model uses the schema for i18n by Zope:

    http://xml.zope.org/namespaces/i18n

This allows the i18n:trans attribute on translatable items like label,
hint, alert, etc.


### Data

The data part defines the variables (or: fields) that will hold the
collected data. So, for instance, if you'd need to know someone's
address, the data could be:

    <data>
      <var name="address" />
      <var name="city" />
      <var name="zipcode" />
    </data>

Variables can be grouped together, to create a hierarchy or grouping:

    <data>
      <vargroup name="address">
        <var name="street" />
        <var name="city" />
        <var name="zipcode" />
      </vargroup>
    </data>

Groups can contain other groups, so nesting is unlimited.  This can be
used to address groups of variables in one go. See the section on the
model for more details.

A variable can also hold a default value:

      <var name="zipcode">9999..</a>


### Model

"It's only a model!"
"Shhhh!"

The model defines properties of the data, like whether a variable must
have a value for the data to be valid, or specifying the type of the
variable. The following properties may be set:

* relevant
* required
* readonly
* calculate
* constraint
* datatype

All properties except for the datatype can be specified in terms of an
expression, like:

    relevant="true()"
    required="foo == 1"

To apply properties to variables, 'binding' is used. This is done
through expressions that specify to what variables the properties
apply, using regular expressions:

    <properties id="required">
      <bind>/address/city</bind>
      <required>true</required>
    </properties>

or:

    <properties id="required">
      <bind>/address/.*</bind>
      <required>true</required>
    </properties>

You can specify as many bind tags on a properties element as you like.

#### relevant

Specify whether the variable is relevant for the complete data. For
example whenever someone filling in a survey says he has had no
education, a further question as to what type of school he/she went to
is irrelevant. Defaults to 'true'.


#### required

Specify whether some variable is required for the data to be
valid. Defaults to 'false'.


#### readonly

Specify whether some variable cannot be set. Defaults to 'false'.


#### constraint

Constrain possible values of a variable, like 'smaller than' or 'in
the range of ...'.


#### calculate

Calculate the value of a variable.


#### datatype

Specify the datatype of the variable. This places extra constraints on
the variable, but may also affect display.


### Layout

The view part of the survey specifies what it 'looks like', although
in theory the survey could also be converted to automated
speech...

The layout section enables grouping for example into pages, or
fieldsets. The grouping also enables you to say something about the
layout of the group, using the layout attribute.

So a group:

    <group id="some group" layout="page">
    ...
    </group>

will render all it's listed controls on a page, wheres a group like:

    <group id="some group" layout="flow">
        <property name="dir">h</property>
    ...
    </group>

will render it's controls in a horizontal flow.


### Submission

Specify the way the survey data should be handled.
