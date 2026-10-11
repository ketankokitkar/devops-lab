# AWS Cloud Practitioner (CLF-C02) — Cloud Computing Practice Questions

## Section 1: Cloud Computing Fundamentals

### Q1. What is cloud computing?

- [ ] A. Purchasing and maintaining physical servers for every application
- [ ] B. Delivering IT resources on demand over a network, typically with usage-based pricing
- [ ] C. Using only applications installed on a local computer
- [ ] D. Storing all business data on a single physical server

### Q2. A company wants to create a test environment quickly without purchasing physical servers. Which cloud benefit best addresses this requirement?

- [ ] A. Increased hardware maintenance
- [ ] B. Faster provisioning and increased agility
- [ ] C. Higher upfront capital expenditure
- [ ] D. Reduced access to computing resources

### Q3. Which cloud characteristic allows users to provision resources when required without contacting the provider for every request?

- [ ] A. Resource pooling
- [ ] B. Broad network access
- [ ] C. On-demand self-service
- [ ] D. Measured service

### Q4. A company automatically adds computing resources during periods of high traffic and removes them when traffic decreases. Which concept does this demonstrate?

- [ ] A. Elasticity
- [ ] B. Data residency
- [ ] C. Capital expenditure
- [ ] D. Resource ownership

### Q5. A cloud provider measures usage and charges customers according to the applicable service pricing model. Which cloud characteristic does this demonstrate?

- [ ] A. Resource pooling
- [ ] B. Measured service
- [ ] C. Fault tolerance
- [ ] D. Broad network access

---

## Section 2: Cloud Benefits and Economics

### Q6. A company previously purchased servers before knowing how much computing capacity it would need. It now wants to pay for resources as they are consumed. Which benefit is it seeking?

- [ ] A. Trading some upfront capital expenditure for variable expense
- [ ] B. Eliminating every IT-related cost
- [ ] C. Increasing physical data center ownership
- [ ] D. Removing the need to monitor resource usage

### Q7. An application uses an oversized EC2 instance that is consistently underutilized. What should the company consider to optimize costs?

- [ ] A. Rightsizing the instance based on workload requirements
- [ ] B. Increasing the instance size immediately
- [ ] C. Deploying the same oversized instance in every Region
- [ ] D. Disabling all performance monitoring

### Q8. Which statement best describes economies of scale in cloud computing?

- [ ] A. Every cloud customer receives identical bills
- [ ] B. Large-scale operations can allow a provider to achieve lower unit costs
- [ ] C. Cloud services never incur data transfer charges
- [ ] D. Customers must purchase all hardware before using cloud resources

### Q9. A company wants to estimate the cost of a proposed AWS environment before deploying it. Which tool should it use?

- [ ] A. AWS CloudTrail
- [ ] B. AWS Pricing Calculator
- [ ] C. AWS IAM
- [ ] D. Amazon Route 53

### Q10. Which two actions can help an organization manage AWS costs? **(Select TWO.)**

- [ ] A. Rightsize resources to match workload requirements
- [ ] B. Leave unused resources running indefinitely
- [ ] C. Monitor usage and review cost information
- [ ] D. Provision the largest available instance for every workload
- [ ] E. Ignore data transfer and storage costs

---

## Section 3: Scalability, Availability, and Deployment Models

### Q11. An application needs additional processing capacity. The team upgrades its existing server to a larger instance. What type of scaling is this?

- [ ] A. Horizontal scaling
- [ ] B. Vertical scaling
- [ ] C. Disaster recovery
- [ ] D. Resource pooling

### Q12. A company wants an application to remain available if one Availability Zone experiences a failure. Which approach best supports this goal?

- [ ] A. Deploy all application components in one Availability Zone
- [ ] B. Distribute suitable application components across multiple Availability Zones
- [ ] C. Store all data on a single local disk
- [ ] D. Disable application health checks

### Q13. A company keeps some applications in its own private infrastructure while using AWS for other workloads. Which deployment model does this describe?

- [ ] A. Public cloud only
- [ ] B. Private cloud only
- [ ] C. Hybrid cloud
- [ ] D. SaaS only

### Q14. Which statement best describes disaster recovery?

- [ ] A. Increasing the size of a running server
- [ ] B. Restoring systems and data after a major disruption
- [ ] C. Automatically removing unused resources
- [ ] D. Delivering cached content from edge locations

---

## Section 4: Service Models and AWS Global Infrastructure

### Q15. A developer launches an Amazon EC2 instance and is responsible for managing its guest operating system and installed applications. Which service model does this most closely represent?

- [ ] A. SaaS
- [ ] B. PaaS
- [ ] C. IaaS
- [ ] D. Private cloud

### Q16. A customer uses a complete web-based email application without managing the underlying servers or operating system. Which service model does this represent?

- [ ] A. IaaS
- [ ] B. PaaS
- [ ] C. SaaS
- [ ] D. Hybrid cloud

### Q17. Which statement about AWS Regions and Availability Zones is correct?

- [ ] A. An Availability Zone contains multiple AWS Regions
- [ ] B. A Region is a geographical area containing multiple Availability Zones
- [ ] C. Regions and Availability Zones mean exactly the same thing
- [ ] D. Edge locations are the same as Availability Zones

### Q18. A company wants to deliver cached website content to users around the world. Which AWS infrastructure component is particularly relevant?

- [ ] A. Edge locations
- [ ] B. Guest operating systems
- [ ] C. Local development environments
- [ ] D. Physical servers owned by the customer

---

## Section 5: AWS Shared Responsibility Model

### Q19. Under the AWS Shared Responsibility Model, who is responsible for the physical security of AWS data centers?

- [ ] A. The customer
- [ ] B. AWS
- [ ] C. The application developer alone
- [ ] D. The customer's internet service provider

### Q20. A customer runs an application on Amazon EC2. Who is generally responsible for patching and securing the guest operating system?

- [ ] A. AWS in every case
- [ ] B. The customer
- [ ] C. The internet service provider
- [ ] D. Amazon CloudFront

### Q21. A company stores confidential documents in Amazon S3. Which action is the customer's responsibility?

- [ ] A. Maintaining the physical security of AWS data centers
- [ ] B. Replacing failed physical storage hardware
- [ ] C. Configuring appropriate access permissions for its objects and data
- [ ] D. Managing the underlying physical storage infrastructure

### Q22. Which statement best describes the AWS Shared Responsibility Model?

- [ ] A. AWS is responsible for every aspect of customer security
- [ ] B. The customer is responsible for the physical security of AWS facilities
- [ ] C. AWS secures the underlying cloud infrastructure, while customers secure their workloads and configurations according to the service used
- [ ] D. Customers do not need to configure access permissions when using managed services

---

## Section 6: AWS Well-Architected Framework

### Q23. What is the primary purpose of the AWS Well-Architected Framework?

- [ ] A. To calculate employee salaries
- [ ] B. To evaluate architectures against AWS best practices and help make informed design decisions
- [ ] C. To replace all application testing
- [ ] D. To eliminate the need for security controls

### Q24. Which six pillars belong to the AWS Well-Architected Framework? **(Select SIX.)**

- [ ] A. Operational Excellence
- [ ] B. Security
- [ ] C. Reliability
- [ ] D. Performance Efficiency
- [ ] E. Cost Optimization
- [ ] F. Sustainability
- [ ] G. Employee payroll management
- [ ] H. Hardware procurement

### Q25. A company wants to improve its ability to recover from infrastructure failures and maintain consistent workload performance. Which Well-Architected pillar is most directly related?

- [ ] A. Reliability
- [ ] B. Cost Optimization
- [ ] C. Sustainability
- [ ] D. Performance Efficiency

### Q26. A company wants to select the right resource types and sizes to meet workload requirements efficiently as technology evolves. Which pillar is most directly relevant?

- [ ] A. Security
- [ ] B. Performance Efficiency
- [ ] C. Operational Excellence
- [ ] D. Sustainability

### Q27. A company wants to continuously improve operational procedures, monitor workloads, and learn from operational events. Which pillar is most relevant?

- [ ] A. Operational Excellence
- [ ] B. Cost Optimization
- [ ] C. Reliability
- [ ] D. Security

---

## Section 7: AWS Cloud Adoption Framework and Migration

### Q28. What is the main purpose of the AWS Cloud Adoption Framework (AWS CAF)?

- [ ] A. To provide guidance for assessing cloud readiness and planning organizational cloud transformation
- [ ] B. To replace all cloud security services
- [ ] C. To guarantee that every migration costs less than the existing environment
- [ ] D. To manage only physical server repairs

### Q29. Which set correctly identifies the six perspectives of the AWS Cloud Adoption Framework?

- [ ] A. Business, People, Governance, Platform, Security, Operations
- [ ] B. Compute, Storage, Networking, Databases, Analytics, Security
- [ ] C. Planning, Coding, Testing, Deployment, Monitoring, Billing
- [ ] D. Hardware, Software, Procurement, Payroll, Sales, Marketing

### Q30. A company wants to move an existing application to AWS quickly with minimal changes to its architecture. Which migration strategy best matches this requirement?

- [ ] A. Rehost
- [ ] B. Retire
- [ ] C. Retain
- [ ] D. Completely redesign the application before migration

### Q31. A company needs to keep its on-premises database synchronized with a database in AWS during a migration to reduce downtime. Which approach is most appropriate?

- [ ] A. Database replication
- [ ] B. Deleting the source database before migration
- [ ] C. Disabling database backups
- [ ] D. Manually recreating every record after the migration

---

## Section 8: Total Cost of Ownership, Managed Services, and Automation

### Q32. A company compares the cost of running its own data center with moving suitable workloads to AWS. Which costs should it consider when assessing its on-premises Total Cost of Ownership (TCO)?

- [ ] A. Hardware, facilities, power, cooling, maintenance, and relevant operational labor
- [ ] B. Only the purchase price of servers
- [ ] C. Only the electricity bill
- [ ] D. Only the cost of internet connectivity

### Q33. A company uses a managed AWS database service instead of installing and maintaining a database engine on its own EC2 instances. What is a key potential benefit?

- [ ] A. The customer has no security responsibilities
- [ ] B. AWS manages more of the underlying database infrastructure and routine maintenance tasks, depending on the service and configuration
- [ ] C. The database can never experience downtime
- [ ] D. The customer no longer needs to manage database users or data

### Q34. A team repeatedly creates development environments using manually executed commands. It wants consistent, repeatable infrastructure deployments. Which approach is most appropriate?

- [ ] A. Infrastructure as Code (IaC) and automation
- [ ] B. Manually configure each environment differently
- [ ] C. Avoid documenting infrastructure configurations
- [ ] D. Keep every test environment running permanently

---

## Answer Key and Explanations

**Complete all questions before reading this section.**

### Q1–Q10

| Q. | Correct answer | Explanation                                                                                                                     |
| -- | -------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| 1  | B              | Cloud computing delivers IT resources on demand over a network.                                                                 |
| 2  | B              | Rapid provisioning helps teams build and test environments faster.                                                              |
| 3  | C              | On-demand self-service allows users to provision resources when needed.                                                         |
| 4  | A              | Elasticity adjusts resources as workload demand changes.                                                                        |
| 5  | B              | Measured service tracks resource usage for monitoring and billing.                                                              |
| 6  | A              | Cloud adoption can reduce the need for large upfront infrastructure purchases and shift some costs toward usage-based spending. |
| 7  | A              | Rightsizing aligns resource capacity with actual workload needs.                                                                |
| 8  | B              | Large providers can spread costs across many customers and workloads.                                                           |
| 9  | B              | AWS Pricing Calculator estimates costs for planned AWS configurations.                                                          |
| 10 | A, C           | Rightsizing and monitoring usage help identify opportunities to control costs.                                                  |

### Q11–Q22

| Q. | Correct answer | Explanation                                                                                                                 |
| -- | -------------- | --------------------------------------------------------------------------------------------------------------------------- |
| 11 | B              | Vertical scaling increases or decreases the capacity of an individual resource.                                             |
| 12 | B              | A multi-AZ design can improve resilience to an Availability Zone failure when the application is architected appropriately. |
| 13 | C              | Hybrid cloud combines private infrastructure with public cloud resources.                                                   |
| 14 | B              | Disaster recovery focuses on restoring systems and data after disruption.                                                   |
| 15 | C              | EC2 is an IaaS example; customers generally manage their guest operating systems and applications.                          |
| 16 | C              | SaaS provides a complete application for the customer to use.                                                               |
| 17 | B              | A Region is a geographical area containing multiple Availability Zones.                                                     |
| 18 | A              | Edge locations help deliver content closer to end users, including through CloudFront.                                      |
| 19 | B              | AWS is responsible for physical data center security.                                                                       |
| 20 | B              | For a standard EC2 deployment, the customer is generally responsible for guest OS maintenance and patching.                 |
| 21 | C              | Customers must configure appropriate access and protect their data.                                                         |
| 22 | C              | Responsibilities are shared and depend on the AWS service and configuration.                                                |

### Q23–Q34

| Q. | Correct answer   | Explanation                                                                                                                                                        |
| -- | ---------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| 23 | B                | The Well-Architected Framework helps evaluate workloads against architectural best practices.                                                                      |
| 24 | A, B, C, D, E, F | The six pillars are Operational Excellence, Security, Reliability, Performance Efficiency, Cost Optimization, and Sustainability.                                  |
| 25 | A                | Reliability concerns a workload's ability to perform correctly and recover from disruptions.                                                                       |
| 26 | B                | Performance Efficiency focuses on using computing resources efficiently and adapting to changing requirements.                                                     |
| 27 | A                | Operational Excellence includes operating, monitoring, learning, and continually improving workloads and processes.                                                |
| 28 | A                | AWS CAF helps organizations assess readiness, identify opportunities, and plan cloud transformation.                                                               |
| 29 | A                | The six perspectives are Business, People, Governance, Platform, Security, and Operations.                                                                         |
| 30 | A                | Rehosting, often called lift and shift, moves an application with minimal changes.                                                                                 |
| 31 | A                | Database replication helps keep source and target databases synchronized during migration, depending on the solution used.                                         |
| 32 | A                | TCO analysis should account for relevant infrastructure, facility, maintenance, and operational costs—not just hardware purchases.                                 |
| 33 | B                | Managed database services take on more infrastructure and maintenance responsibilities, but customers retain responsibilities for data, access, and configuration. |
| 34 | A                | IaC and automation make infrastructure provisioning more consistent, repeatable, and easier to manage.                                                             |

---

## Review Your Mistakes

After checking your answers, mark the topics you need to revise.

- [ ] Cloud computing characteristics
- [ ] Cloud benefits and economics
- [ ] Scalability, elasticity, and availability
- [ ] Public, private, and hybrid cloud
- [ ] IaaS, PaaS, and SaaS
- [ ] Regions, Availability Zones, and edge locations
- [ ] AWS Shared Responsibility Model
- [ ] Well-Architected Framework and its six pillars
- [ ] AWS Cloud Adoption Framework perspectives
- [ ] Cloud migration strategies and database replication
- [ ] On-premises TCO and cloud cost considerations
- [ ] Managed services
- [ ] Infrastructure as Code and automation

**Revision rule:** For every incorrect answer, explain the correct concept in your own words before moving on.

---

## Official References

1. **AWS Certified Cloud Practitioner — Exam Guide**
   [https://docs.aws.amazon.com/aws-certification/latest/cloud-practitioner-02/cloud-practitioner-02.html](https://docs.aws.amazon.com/aws-certification/latest/cloud-practitioner-02/cloud-practitioner-02.html)

2. **CLF-C02 Domain 1: Cloud Concepts**
   [https://docs.aws.amazon.com/aws-certification/latest/cloud-practitioner-02/cloud-practitioner-02-domain1.html](https://docs.aws.amazon.com/aws-certification/latest/cloud-practitioner-02/cloud-practitioner-02-domain1.html)

3. **AWS Well-Architected Framework — Six Pillars**
   [https://docs.aws.amazon.com/wellarchitected/latest/framework/the-pillars-of-the-framework.html](https://docs.aws.amazon.com/wellarchitected/latest/framework/the-pillars-of-the-framework.html)

4. **AWS Cloud Adoption Framework Overview**
   [https://docs.aws.amazon.com/whitepapers/latest/overview-aws-cloud-adoption-framework/](https://docs.aws.amazon.com/whitepapers/latest/overview-aws-cloud-adoption-framework/)

5. **AWS Pricing Calculator**
   [https://calculator.aws/](https://calculator.aws/)

---

## Important Scope Note

This practice set focuses on foundational cloud computing and selected related CLF-C02 Cloud Concepts objectives. It is not a complete practice exam for the entire certification.

Other exam domains—Security and Compliance, Cloud Technology and Services, and Billing, Pricing, and Support—require their own dedicated notes and practice questions.

Use the current official exam guide to confirm the full exam scope before taking the certification.
