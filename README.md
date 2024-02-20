# Terraform Module for AWS Integrations with Uptycs

This module integrates an AWS account with Uptycs, providing access to crucial AWS telemetry and event monitoring for CSPM and CIEM applications.

## Usage

All the modules in this Project are used to create required resources based on the integration type with Uptycs.

The following integratins are supported:

- [CSPM Integration](modules/cspm_integration)
- [CloudTrail Integration](modules/cloudtrail_integration)

## CSPM Integration

[This module](modules/cspm_integration) facilitates the creation of resources to enable the accessibility of AWS telemetry for Uptycs applications.

The [examples](examples) folder contains illustrative examples showcasing [CSPM Integration](examples/cspm_integration).

## CloudTrail Integration

[This module](modules/cloudtrail_integration) streamlines the creation of resources, enabling access to the S3 bucket and Kinesis stream, thereby making CloudTrail events accessible to Uptycs applications.

The [examples](examples) folder contains illustrative CloudTrail integration demonstrations utilizing [S3 Bucket](examples/cloudtrail_integration_s3) and [Kinesis stream](examples/cloudtrail_integration_kinesis).
