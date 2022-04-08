# GENERATE UUID v5

BigQuery already has the function [GENERATE_UUID()](https://cloud.google.com/bigquery/docs/reference/standard-sql/uuid_functions), which creates a random GUID. 

This repo contains an SQL function that allows you to generate non random GUIDs, with UUID v5 it's possible to create the same GUID at any time and in diffenrents languages, since you give the same namespace and the same reference string during the creation.

Specifications about UUIDs versions can easily be found on internet, [UUUIDTools](https://www.uuidtools.com/uuid-versions-explained) is a good example of it.

## Namespace

The namespace is a GUID concatenated with the reference string when creating de UUIDv5, The UUID specification establishes 4 pre-defined namespaces, I've also including their value in bytes, which is necessary to use the function:

| Name      | GUID                                  | Bytes                                                      | 
| --------  | ------------------------------------  | ---------------------------------------------------------  |
| DNS       | 6ba7b810-9dad-11d1-80b4-00c04fd430c8  | b'k\xa7\xb8\x10\x9d\xad\x11\xd1\x80\xb4\x00\xc0O\xd40\xc8' |
| URL       | 6ba7b811-9dad-11d1-80b4-00c04fd430c8  | b'k\xa7\xb8\x11\x9d\xad\x11\xd1\x80\xb4\x00\xc0O\xd40\xc8' |
| OID       | 6ba7b812-9dad-11d1-80b4-00c04fd430c8  | b'k\xa7\xb8\x12\x9d\xad\x11\xd1\x80\xb4\x00\xc0O\xd40\xc8' |
| X.500 DN  | 6ba7b814-9dad-11d1-80b4-00c04fd430c8  | b'k\xa7\xb8\x14\x9d\xad\x11\xd1\x80\xb4\x00\xc0O\xd40\xc8' |

You can event use any other GUID as namespace, but then will be your job get its value in bytes.

## Proof of Concept

By coping the script inside `GENERATE_UUID_V5.sql` and running it on BigQuery we get the following result:

| Row | reference | UUID                                 | 
| --- | --------- | -----------------------------------  |
| 1   | 123       | 3bce8de0-ab5d-5f8d-9b53-f3adce131b94 |
| 2   | 123456    | b3dd142b-88f7-5062-ad06-c549441cd5ce |

As this script uses the OID namespace as default, we should also use it to be able to create the exactly same GUID in any other language. 

The following python scripts generates GUIDs for the same reference strings and namespace:

```
import uuid

print(uuid.uuid5(uuid.NAMESPACE_OID, "123"))
print(uuid.uuid5(uuid.NAMESPACE_OID, "123456"))
```

The result, as expected, is the same as we obtained when running on BigQuery

```
3bce8de0-ab5d-5f8d-9b53-f3adce131b94
b3dd142b-88f7-5062-ad06-c549441cd5ce
```

## Credits

Made with :heart: by Wuerike Cavalheiro