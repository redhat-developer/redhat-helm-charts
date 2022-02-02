# REST HTTP Spring Boot Example
A Helm chart for building and deploying the [Spring Boot REST](https://github.com/snowdrop/rest-http-example) example on OpenShift.

## Values
Below is a table of each value used to configure this chart.

| Value | Description | Default |
| ----- | ----------- | ------- |
| `spring-boot-example-app.name` | Name of the application you want to build/deploy | `rest-http` |
| `spring-boot-example-app.version` | Version that you want to build/deploy | `0.0.1` |
| `spring-boot-example-app.s2i.source.repo` | Git URI that references the Spring Boot REST example git repo | `https://github.com/snowdrop/rest-http-example` |
| `spring-boot-example-app.s2i.source.ref` | Git ref that references the Spring Boot REST example git repo | `sb-2.5.x` |

## Overwrite the GIT S2i values
You can overwrite the GIT S2i values by using the `--set` option when installing the chart:

```
helm install rest-http ./ --set spring-boot-example-app.s2i.source.repo=<repo-to-use> --set spring-boot-example-app.s2i.source.ref=<ref-to-use>
```