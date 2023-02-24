# Move AirDrop

### AirDrop for all Platform (Windows, Linux, Mac, Android, iOS)

## How to use


### Windows
Requirements: Windows 10

## Important Notice
- [sqflite ffi](https://pub.dev/packages/sqflite_common_ffi) is not supported on Windows yet. So, you can't use the database on Windows. You need to add following steps to use the database on Windows.
  Windows
  Should work as is in debug mode (sqlite3.dll is bundled).

In release mode, add sqlite3.dll in same folder as your executable.

sqfliteFfiInit is provided as an implementation reference for loading the sqlite library. Please look at sqlite3 if you want to override the behavior.
