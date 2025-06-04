# Azure Public IP Terraform Module

[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-blue.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![OpenTofu Registry](https://img.shields.io/badge/opentofu-registry-yellow.svg)](https://search.opentofu.org/module/cloudastro/public-ip/azurerm/)

This module is designed to create and manage Azure Public IP addresses. It allows for the configuration of IP allocation methods, versioning, and zones, making it ideal for resources that need public internet connectivity.

## Features
- **Public IP Address Management**: Creates and manages Azure Public IP addresses within a specified resource group.
- **IP Allocation Methods**: Supports both Static and Dynamic allocation methods to provide flexibility in IP address assignment.
- **IP Versioning**: Allows the selection of either IPv4 or IPv6 for the IP address.
- **Availability Zones**: Supports assignment to specific availability zones for high availability and fault tolerance.
- **DNS Label Configuration**: Optionally configures a DNS label for the public IP, enabling DNS-based routing.

## Example Usage
This example demonstrates how to create a static public IPv4 address in a specified resource group with optional zone assignment.
