# OpenFaaS Functions
[![Build Status](https://travis-ci.com/MartinHeinz/openfaas-functions.svg?branch=master)](https://travis-ci.com/MartinHeinz/openfaas-functions)

This is repository for various function that use OpenFaaS platform.

## Using Custom Templates

Custom templates are stored in [openfaas-templates](https://github.com/MartinHeinz/openfaas-templates) repository.

To pull those template use:

```shell
export OPENFAAS_TEMPLATE_URL=
export OPENFAAS_TEMPLATE_STORE_URL=https://raw.githubusercontent.com/MartinHeinz/openfaas-templates/master/templates.json

faas-cli template store list
faas-cli template store pull golang-mod --overwrite
```

And then create new function from pulled ones:

```shell
cd functions
faas-cli new --lang golang-mod test-func --prefix="martinheinz"
```

### Resources

- [Using template from external repository](https://github.com/openfaas/faas-cli/blob/master/guide/TEMPLATE.md)
- [OpenFaaS Function Store](https://github.com/openfaas/store/)
- [Customise a template](https://docs.openfaas.com/cli/templates/#80-customise-a-template)
