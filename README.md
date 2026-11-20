# Navigraph vcpkg registry

A [vcpkg registry](https://learn.microsoft.com/vcpkg/concepts/registries) for Navigraph's C++ libraries.

| Port | Library |
| --- | --- |
| `simlink-source-sdk` | [Navigraph Simlink Source SDK](https://github.com/Navigraph/simlink-source-sdk) |

## Using it

Add the registry to your `vcpkg-configuration.json`, with this repository's latest commit as the baseline:

```json
{
  "registries": [
    {
      "kind": "git",
      "repository": "https://github.com/Navigraph/vcpkg-registry",
      "baseline": "<commit>",
      "packages": ["simlink-source-sdk"]
    }
  ]
}
```

Then add the port to the dependencies in your `vcpkg.json`. Each port's `usage` file shows how to link it.
