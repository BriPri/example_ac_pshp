# RESTFul API
The EIP will use RESTFul best practices when possible.

## HTTP Verbs
GET: Read / query
POST: Create new
PUT: Full update based on the request body
PATCH: Partial update based on the request body
DELETE: Delete / cancel / ignore

## URL Path

.../{version}/{plural noun}

.../{version}/{plural noun}/{id}

.../{version}/{plural noun}/{id}/{plural noun}

.../{version}/{plural noun}/{id}/{plural noun}/{id}

## API Versions
The URL path contains the API version.

The numbering system used is SemVer (Semantic Versioning). In general its **v{major}.{minor}.{patch}**.

Changes in each number indicates the following:

- major: API contains breaking changes
- minor: API **does not** have breaking changes but contains new features
- patch: API contains bug fixes

The **EIP** excludes trailing numbers until required based on the above rules.

For example:
Initial release is **v1**
Next release with minor features is **v1.1**
Major next major release is **v2**

It is **unlikely** the patch level is exposed as part of the URL path. 

The EIP will expose multiple versions of the API depending on governance rules.
For example (2 versions of seat map):

.../v1/seatmaps

and

.../v1.1/seatmaps

## Complex GET and DELETE
GET and DELETE should **not** contain a body.  However, it's likely some queries may need to provide more information than recommended for a GET or DELETE.  For these situations, a **POST** is used with the "/get" or "/delete" appended to the URL path.

The API documentation explicitly indicates these situations.

For example:
Implementors should **POST** to .../v1/shopping/fares/calendar/get with the expectation it behaves like a **GET**.

## HTTP Status
The EIP respects the semantics of the HTTP status.

The EIP will return the following status
### Success

- 200: Success
- 201: Created
- 202: Accepted for processing but processing is not complete
- 204: Success but no content is returned.

### Error

- 400: Request failed.  Warnings or errors are returned in the body.
- 401: Unauthorized
- 403: Forbidden, most likely due to permissions.
- 404: Not Found, the requested resources cannot be found.
- 405: The URL path to resource is correct but the server cannot perform the HTTP Verb.
- 415: Unsupported media type, likely caused by submitting a non-JSON payload.

### Internal Error

- 500: Internal server error

Other 500 level errors may be returned due but are not directly generated by the EIP.
