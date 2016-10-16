# Inuendo
Inuendo - Data virtualization engine

Inuendo, in short, is the virtualization of data. Traditionally, data has been imprisoned in physical tables with fixed record layouts. The limitations of such structure have inhibited developers and the users they support, for decades. By virtualizing the data instead, the majority of these limitations are eliminated, resulting in simpler development, maintenance and troubleshooting of applications.  Inuendo treats all business objects (a.k.a. Entities) the same, regardless of their role in the supply chain. This allows entities of lesser obvious importance to produce equally valuable business intelligence.

The blueprint of any Inuendo entity is a class definition comprised of properties – a concept similar to object oriented design. Each property conforms to a specified data type. When an entity is instantiated (created), its unique identity and high priority metadata are stored in a header record.  The values of its properties are stored in an associative manner (by nickname) in a series of subtables –
one table per data type. As the values of properties change over time, each change is recorded chronologically in the subtables, providing a time indexed history at the property level. This is extremely useful in troubleshooting and trend analysis. Think of this as storing data at the "piece of information level".  In addition, the scattering of data in this fashion provides a layer of security not possible with traditional linear record formats.

As its name and logo suggests, Inuendo begins and ends with I/O (input/output). Therefore, in order to provide applications a simple and consistent way to extract and manipulate its scattered data, it is accompanied by a wealth of open source API’s to perform tasks such as entity creation and property value assignment. Various stored procedures produce result sets with useful collections of data
organized from the header and subtables.

Despite the fact that Inuendo is being deployed in live applications, it is still a work in progress. Please consider joining our grass roots effort to virtualize data by becoming a member of our LinkedIn group and contributing your technical expertise to help us improve the functionality of Inuendo. 
