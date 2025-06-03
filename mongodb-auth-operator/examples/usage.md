# Usage Guide for MongoDB Auth Operator CRDs

This guide provides usage examples for the `User` and `Role` Custom Resource Definitions (CRDs) deployed by the MongoDB Auth Operator.

## User

The `User` CRD is used to manage users in a MongoDB database. Here's an example of a `User` resource:

```yaml
apiVersion: mongo.facets.cloud/v1alpha1
kind: User
metadata:
  name: test-user
spec:
  connectionString: mongodb://root:xyz@mongodb-test.default.svc.cluster.local:27017
  database: testdb
  passwordRef:
    name: mongo
    namespace: default
  customData:
    custom: "Example data"
  mechanisms: ["SCRAM-SHA-1"]
  rolesToRole:
    - test-role-1
  dbRoles:
    - db: testdb
      role: test-role-1
  userNameOverride: actual-user-name
```

In this example, a new user named `actual-user-name` is being created with the password stored in the `mongo` Kubernetes secret. The user has the `test-role-1` role in the `testdb` database. If `userNameOverride` is not set the username is taken from name of the user crd created.

## Role

The `Role` CRD is used to manage roles in a MongoDB database. Here are a few examples of `Role` resources:

### Cluster Read Role

```yaml
apiVersion: mongo.facets.cloud/v1alpha1
kind: Role
metadata:
  name: cluster-read-role
spec:
  connectionString: mongodb://root:xyz@mongodb-test.default.svc.cluster.local:27017
  database: testdb
  privileges:
  - resource:
      cluster: true
    actions:
    - find
```

In this example, a new role named `cluster-read-role` is created that can read data from the entire cluster.

### Collection Read Role

```yaml
apiVersion: mongo.facets.cloud/v1alpha1
kind: Role
metadata:
  name: test-role-1
spec:
  connectionString: mongodb://root:xyz@mongodb-test.default.svc.cluster.local:27017
  database: testdb
  privileges:
  - resource:
      db: testdb
      collection: testing
    actions:
    - find
```

In this example, a new role named `test-role-1` is created that can read data from the `testing` collection in the `testdb` database.

### Collection Write Role

```yaml
apiVersion: mongo.facets.cloud/v1alpha1
kind: Role
metadata:
  name: test-role-2
spec:
  connectionString: mongodb://root:Nqjkbb12J8h2HffO@mongodb-alpha-mongo-0.mongodb-alpha-mongo-headless.default.svc.cluster.local:27017
  database: testdb
  privileges:
  - resource:
      db: testdb
      collection: testing
    actions:
      - find
      - update
      - insert
      - remove
  # inherit roles
  dbRoles:
  - db: testdb2
    role: test-role-2
```

In this example, a new role named `test-role-2` is created that can perform read and write operations in the `testing` collection in the `testdb` database. It also inherits the `test-role-2` role from the `testdb2` database.

Remember to replace the database names, roles, and other details with your own values. Consult the CRD specifications for more information on each field.