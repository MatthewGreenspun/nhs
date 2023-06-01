# NHS

App for National Honor Society.

## Running Code

The code uses libraries that rely on generated files that are not included in version control. To generate these files, run

```
dart run build_runner build
```

in the root directory.
On debug mode, the app uses Firebase Emulators rather than the production database. Download and configure Firebase Emulators using the instructions [here](https://firebase.google.com/docs/emulator-suite).
