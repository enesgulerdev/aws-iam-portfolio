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

### 2. `rds_database`

A lightweight workload module used primarily to simulate application databases and enforce strict resource tagging standards for governance testing.

## Departments & Environments Breakdown

### 1. Engineering Department

* **`engineering/dev`:**
* Manages core developer debugging rights, ECS execution roles, and an advanced **ABAC (Attribute-Based Access Control) Manager role**.
* **ABAC Demonstration:** Includes a deployed RDS instance (`eng-dev-database`) tagged with `Department = Engineering` and `Environment = development`. The `rds_abac_manager` role uses IAM `Condition` blocks (`aws:ResourceTag/Department` and `aws:ResourceTag/Environment`) to ensure administrative actions are strictly scoped to matching resources.


* **`engineering/prod`:** Hardened production roles with restricted permissions and strict least-privilege guardrails.

> **Architectural Note on Workloads:** While enterprise best-practices typically separate identity management layers from service/workload layers into distinct state files, an isolated RDS instance is deliberately included within the `engineering/dev` layer as a *Proof of Concept (PoC)*. This directly validates and enforces Tag-Based Access Control (ABAC) assertions against dynamic resource attributes.

### 2. HR Department

* **`hr/dev` & `hr/prod`:** Department-specific access models, handling developer debugging tools, secure cloud logging, and automated workflow service roles (`lambda_automation`) tailored to HR compliance requirements.

### 3. Shared Infrastructure (`shared/core`)

* Houses foundational cross-account services, including CI/CD build runner roles (`shared-cicd-runner-role`) and centralized CloudTrail logging integrations (`shared-central-logging-role`).

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