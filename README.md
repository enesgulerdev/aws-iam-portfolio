# Enterprise Multi-Account IAM & Governance Portfolio

This repository demonstrates an enterprise-grade, multi-account AWS Identity and Access Management (IAM) and Governance architecture built entirely with Terraform. It eliminates code duplication by leveraging modular design, `locals` mapping, `for_each` iterations, and advanced security primitives such as cross-account `external_id` protection and Attribute-Based Access Control (ABAC).

## Architectural Overview & Directory Structure

The repository follows a clean, decoupled layout separating reusable infrastructure modules from environment-specific configurations across multiple simulated AWS accounts/departments:

```text
iam-portfolio/
├── modules/
│   ├── iam_role/          # Reusable IAM role and policy module with dynamic blocks
│   └── rds_database/      # Dedicated database module for ABAC validation & tagging
└── accounts/
    ├── engineering/
    │   ├── dev/           # Engineering development environment (includes ABAC PoC & RDS)
    │   └── prod/          # Engineering production environment
    ├── hr/
    │   ├── dev/           # HR development environment
    │   └── prod/          # HR production environment
    └── shared/
        └── core/          # Centralized shared infrastructure (CI/CD, Central Logging)

```

## Core Modules (`modules/`)

### 1. `iam_role`

A highly flexible, modular component designed to manage IAM roles, trust policies, and permission attachments uniformly.

* **Dynamic Trust Policies:** Automatically configures `AssumeRole` policies based on principal type (Service, AWS Account, etc.).
* **Confused Deputy Protection (`external_id`):** Utilizes `dynamic "condition"` blocks to conditionally inject `sts:ExternalID` checks only when explicitly required, keeping plan outputs clean for standard internal roles.
* **Custom Inline Policies:** Accepts dynamic JSON policies to handle department-specific permissions without hardcoding.
* **Permission Boundaries (`permissions_boundary_arn`):** Supports optional maximum permission enforcement on roles, preventing privilege escalation and bounding administrative authority during delegated workflows.

### 2. `rds_database`

A lightweight workload module used primarily to simulate application databases and enforce strict resource tagging standards for governance testing.

## Departments & Environments Breakdown

### 1. Engineering Department

* **`engineering/dev`:**
  * Manages developer debugging permissions (`Allow` scoped to HTTPS and `eu-central-1`, paired with an MFA `Deny` condition and explicit `Deny` guards on destructive log and IAM actions), ECS execution roles, and an **ABAC (Attribute-Based Access Control) Manager role** using a unified `statements` schema in `locals.tf` with centralized `common_tags` propagation.
  * **ABAC Demonstration:** Includes a PostgreSQL RDS instance (`eng-dev-database`) tagged with `Department = Engineering` and `Environment = development`. The `rds_abac_manager` role uses IAM `Condition` blocks (`aws:ResourceTag/Department` and `aws:ResourceTag/Environment`) to scope administrative access to matching resources.


* **`engineering/prod`:** Hardened production identity (`ops_readonly`) and ECS task execution roles structured around the unified `statements` schema in `locals.tf`, with `eu-central-1` and `aws:SecureTransport` (`true`) IAM `Condition` guardrails and centralized `common_tags` (`Compliance = "High"`) propagation.

> **Architectural Note on Workloads:** While enterprise best-practices typically separate identity management layers from service/workload layers into distinct state files, an isolated RDS instance is deliberately included within the `engineering/dev` layer as a *Proof of Concept (PoC)*. This directly validates and enforces Tag-Based Access Control (ABAC) assertions against dynamic resource attributes.

### 2. HR Department

* **`hr/dev`:** Development HR identity (`developer`) and `lambda_automation` workload roles structured around the unified `statements` schema in `locals.tf`, combining `eu-central-1` and `aws:SecureTransport` (`true`) conditions with `Allow` + `NotAction` experimentation and explicit `Deny` guardrails.
* **`hr/prod`:** Production HR access model and workload roles planned for stricter compliance guardrails, environment isolation, and tighter policy conditions.

### 3. Shared Infrastructure (`shared/core`)

Houses foundational cross-account services and high-security guardrails, featuring:

* **CI/CD Build Runner (`shared-cicd-runner-role`):** Secured with strict `NotAction` directives to isolate the pipeline entirely to S3 and ECR operations, alongside mandatory `aws:SecureTransport` (HTTPS-only) and `aws:RequestedRegion` (`eu-central-1`) enforcement.

* **Centralized Logging (`shared-central-logging-role`):** Dedicated to CloudTrail log ingestion, hardened with `aws:SourceArn` condition checks against Confused Deputy vulnerabilities and explicit Deny rules blocking any log group/stream deletion or tampering.

## Getting Started & Usage

**1. Initialize Terraform within any target environment:**
```bash
cd accounts/engineering/dev
terraform init
```

**2. Review the execution plan:**
```bash
terraform plan
```

**3. Apply the infrastructure:**
```bash
terraform apply
```