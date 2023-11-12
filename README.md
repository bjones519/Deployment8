
#### November 11, 2023
________________________________________________________	

# Two-Tier E-Commerce Application Deployment on ECS

Deployment Contributors:

**Project Manager**: Brittney Jones <br />
**Chief Architect**: Belinda Dunu <br />
**System Administrator**: Brittney Jones & Belinda Dunu

## Deployment Overview

In this deployment, we launched a two-tier, e-commerce application, on an AWS Elastic Container Service (ECS). Using Terraform allowed us to build out our infrastructure as code (IAC) for provisioning, and Jenkins for CI/CD automation. We chose this approach to enhance consistency, collaboration, security, and ease of maintenance compared to manual deployments.

## Infrastructure Overview

- Custom VPC with 10.0.0.0/16 CIDR block
  - Provides isolation and security for the application
- 2 public subnets in separate availability zones
  - Public subnets allow internet access for Jenkins and app servers
- Internet gateway attached to VPC
  - Enables public subnet internet connectivity
- 2 Ubuntu 18.04 t2.micro EC2 instances
  - Separate instances for Jenkins and app isolation
  - Security groups restricting access
    - Jenkins SG opens ports 22 and 8080
    - App SG opens ports 22 and 8000

## Jenkins Server Setup

- Launched Ubuntu EC2 instance in the public subnet
- Installed Jenkins and created an admin user account
- Dedicated server for CI/CD automation
- Enhanced security with user access controls
- Generated SSH key pair and copied the public key to the app server
  - Allows SSH access from Jenkins without a password

## Jenkins CI/CD Pipeline

- Created GitHub-integrated multibranch pipeline
- Automates build and deploy for all branches
- Jenkinsfile deploy stage executes setup scripts to deploy the latest app code
- Setup scripts install dependencies and start the application
  - Contains necessary steps to deploy the app

## Testing and Deployment

- Updated files in a separate Git branch
- Simulated code change to test pipeline
- Ran build on a new branch using Jenkinsfile
- Validated updated app functionality
- `git add .` `git commit -m "commit message"`, `git merge main` and `git merge` branch to trigger production deployment to main
- Jenkinsfile deploys the latest merged code

## Benefits Achieved

- Collaboration through infrastructure as code
- Security via isolated environments and access controls
- Maintainability with automated CI/CD deployments
- Consistency by defining infrastructure and deployments in code

## Issues Faced:

### Insufficient Jenkins Agent Resources

- **Issue:** Jenkins agent ran out of resources hosting Docker containers.
- **Resolution:** Increased volume size for Jenkins agent EC2 instance.
- **Takeaway:** Monitor and scale CI/CD resources appropriately based on utilization.

### Frontend and Backend Communication

- **Issue:** Frontend and backend unable to communicate properly.
- **Cause:** Missing route configuration between public subnets.
- **Resolution:** Added `aws_route` resource in Terraform config to enable communication.
- **Takeaway:** Validate network connectivity between application tiers.

### Application Dependency Drift

- **Issue:** Frontend running outdated Node.js version.
- **Resolution:**
  - Added `COPY package.json` in frontend Dockerfile to lock down versions.
  - Defined `babel.config.json` to configure JavaScript transpilation.
- **Takeaway:** Proactively manage application dependencies and configs to prevent drift.

## Optimizations

- Integrate Terraform and Jenkins for automated infrastructure provisioning
- Implement auto-scaling groups to scale infrastructure based on demand
- Break infrastructure into reusable Terraform modules
- Regularly monitor resource utilization for cost optimization
- Configure backups and disaster recovery for resilience

## Conclusion

This project demonstrated using Terraform IAC and Jenkins CI/CD to deploy a 2-tier e-commerce application on AWS. Some key benefits include improved collaboration, security, consistency, and maintainability of the deployment process. Proactively managing dependencies, resources, connectivity, and configurations is critical for smooth deployments. For future deployments, integrating Terraform with Jenkins, utilizing auto-scaling, and implementing backup/DR(disaster recovery) would further optimize the deployment architecture.
