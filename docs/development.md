# Development

## Updating a port

`simlink-source-sdk` installs the C++ archives from the SDK's GitHub releases. Each SDK release triggers
`.github/workflows/simlink-source-sdk.yml`, which points the port at the release's archives, checks it installs on
Linux, and commits the new version to `main`. To rerun it for a release, run the workflow by hand with the version.
