# Terraform module for AWS Integrations with Uptycs

This module allows you to Integrate an AWS account with Uptycs. So, required AWS telemetry and events Monitoring are accessible to CSPM and CIEM applications.

## Usage

All the modules in this Project are used to create required resources based on integration type with Uptycs

Supported Integrations

1.  [CSPM-Integration](modules/cspm_integration)
2.  [Cloudtrail-Integration](modules/cloudtrail_integration)

## CSPM-Integration

[This module](modules/cspm_integration) performs the creation of resources to make AWS telemetry accessible to Uptycs applications.

There are examples included in the [examples](examples) folder to illustrate [Cspm-Integration](examples/cspm_integration)

## Cloudtrail-Integration

[This module](modules/cloudtrail_integration) performs the creation of resources to access the s3bucket and kinesis stream to make cloud-trail events accessible to Uptycs applications.

There are examples included in the [examples](examples) folder to illustrate cloud-trail integration using [s3bucket](examples/cloudtrail_integration_s3) and [kinesis stream](examples/cloudtrail_integration_kinesis)
