# Basic Authentication
The EIP prefers Basic Authentication to authenticate applications to the API.

## Registering Applications
You must access Anypoint Exchange with proper credentials to see and register an application with the API's.

https://anypoint.mulesoft.com/exchange

Look for the Rest API of interest and select the API.

You'll see a *Request access* link near the top right of the page.  Further instructions will be provided on how to register.

## Client ID / Client Secret
The application must be approved internally.

After approval, the application is assigned a client id and client secret.

You'll use the client id as the username and the client secret as the password for Basic Authentication.

## Application Name
The application name must start with a know ID from a set known applications optionally followed by a '-' then additional parts of the name.

The name is case insensitive.

Example application names can be:

- FP
- AC2U-robot1
- ACV-main
- ACV-robot1

A list of known names will be provided.

# Access to Altea
The combination of

- client application name
- LSS user
- Office ID

is used to locate the appropriate Altea endpoint based on a lookup table.

The client provides the office id and a self generated transaction id as HTTP headers.
