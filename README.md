# Terraform module for AWS Integrations with Uptycs

This module allows you to integrate AWS account with Uptycs so required AWS telemetry and events Monitoring are accessible to CSPM and CIEM applications.

## Usage

All the modules in this Projects are used to create required resources based on integration type with uptycs

supported integrations

1.  [cloudtrail-integration](modules/cloudtrail_integration)
1.  [cspm-integration](modules/cspm_integration)

## cloudtrail-integration

[This module](modules/cloudtrail_integration) performs creation of resources to access s3bucket and kinesis Stream to make cloudtrail events accessible to uptycs applications.

## cspm-integration

[This module](modules/cloudtrail_integration) performs creation of resources to make aws telemetry accessible to uptycs applications.
