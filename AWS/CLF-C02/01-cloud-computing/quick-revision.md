# AWS Cloud Computing Fundamentals — Quick Revision

## 1. What Is Cloud Computing?

Cloud computing is the on-demand delivery of IT resources over a network, typically with usage-based pricing.

**Remember:** Instead of buying and maintaining all physical infrastructure, you can provision cloud resources as needed.

## 2. Five Essential Characteristics

| Characteristic | Meaning |
|---|---|
| On-demand self-service | Provision resources when needed without contacting the provider. |
| Broad network access | Access services over a network using supported devices. |
| Resource pooling | Provider resources serve multiple customers with isolation. |
| Rapid elasticity | Resources can expand or shrink quickly as demand changes. |
| Measured service | Resource usage is monitored and measured for billing and optimization. |

## 3. Major Benefits of Cloud Computing

- **Variable expense:** Pay for what you use.
- **Economies of scale:** Lower unit costs through large-scale operations.
- **Stop guessing capacity:** Adjust resources to workload demand.
- **Increased agility:** Provision resources faster.
- **Go global:** Deploy in supported AWS Regions.
- **High availability:** Design resilient architectures.
- **Rightsizing:** Match resource capacity to actual needs.
- **Sustainability:** Improve resource utilization and efficiency.

## 4. Traditional IT vs. Cloud

| Traditional IT | Cloud Computing |
|---|---|
| Purchase physical hardware | Provision cloud resources |
| High upfront investment | Start with current needs |
| Slow procurement | Provision quickly |
| Plan capacity before purchase | Adjust capacity as needed |
| Manage physical infrastructure | AWS manages cloud infrastructure; customers retain their responsibilities |

## 5. Scalability, Elasticity, and Agility

| Concept | Meaning | Example |
|---|---|---|
| Vertical scaling | Increase or decrease the capacity of one resource | Move to a larger EC2 instance |
| Horizontal scaling | Add or remove resource instances | Add more EC2 instances |
| Elasticity | Adjust resources to match demand, including scaling down afterward | Add capacity during a traffic spike, then remove it |
| Agility | Provision and change resources quickly | Launch an environment in minutes |

**Exam tip:** Scaling describes changing capacity; elasticity emphasizes responding to changing demand.

## 6. Availability and Recovery

| Concept | Purpose | Example |
|---|---|---|
| High availability | Minimize downtime | Use resources across multiple Availability Zones |
| Fault tolerance | Continue operating through failures | Design systems to withstand component failures |
| Disaster recovery | Restore systems and data after a major disruption | Maintain backups and a recovery plan |

**Exam tip:** High availability focuses on reducing downtime, fault tolerance on continued operation despite failures, and disaster recovery on restoring service after disruption.

## 7. Cloud Deployment Models

| Model | Description |
|---|---|
| Public cloud | Cloud services delivered over the internet by a cloud provider, such as AWS. |
| Private cloud | Cloud environment dedicated to one organization. |
| Hybrid cloud | Combines private infrastructure with public cloud services. |

## 8. Cloud Service Models

| Model | What you receive | Example |
|---|---|---|
| IaaS — Infrastructure as a Service | Compute, storage, networking, and infrastructure building blocks | Amazon EC2 |
| PaaS — Platform as a Service | A managed platform for developing or running applications | AWS Elastic Beanstalk |
| SaaS — Software as a Service | A complete application ready to use | Email software |

**Memory trick:**
- **IaaS:** Infrastructure
- **PaaS:** Platform
- **SaaS:** Software

As you move from IaaS to SaaS, the provider generally manages more of the underlying stack.

## 9. AWS Global Infrastructure

| Component | Meaning |
|---|---|
| Region | Separate geographical area containing multiple Availability Zones |
| Availability Zone (AZ) | Isolated location within a Region, consisting of one or more data centers |
| Edge Location | Part of AWS's edge network used to deliver content with low latency |

**Remember:**
- Regions provide geographical separation.
- Multiple AZs support resilient application design.
- Amazon CloudFront uses AWS edge locations to deliver content closer to users.

## 10. AWS Shared Responsibility Model

AWS security responsibilities and customer security responsibilities differ depending on the service used.

| AWS — Security *of* the Cloud | Customer — Security *in* the Cloud |
|---|---|
| Physical infrastructure | Data and access permissions |
| Hardware and networking | Identity and access management |
| Managed infrastructure | Guest OS and patching where applicable |
| Facilities | Application configuration and workloads |

**Important:** Responsibility varies by service. With Amazon EC2, customers manage the guest operating system. With more fully managed services, AWS manages more of the underlying infrastructure.

## 11. Cloud Economics

| Term | Meaning |
|---|---|
| CapEx — Capital Expenditure | Upfront investment in assets such as servers |
| OpEx — Operational Expenditure | Ongoing operating expenses |
| Pay-as-you-go | Charges based on resource usage |
| Rightsizing | Selecting suitable resource sizes |
| Economies of scale | Lower unit costs at large scale |
| AWS Pricing Calculator | Estimates costs for planned AWS workloads |
| Total Cost of Ownership (TCO) | Considers infrastructure, maintenance, facilities, and operating costs |

**Exam tip:** Cloud computing can reduce upfront hardware investment and shift spending toward usage-based operational expenses. It does not mean every cloud workload is automatically cheaper.

## 12. AWS Well-Architected Framework

The six pillars are:

1. **Operational Excellence** — Run and improve workloads.
2. **Security** — Protect systems, identities, and data.
3. **Reliability** — Recover from failures and meet availability needs.
4. **Performance Efficiency** — Use resources efficiently.
5. **Cost Optimization** — Avoid unnecessary costs.
6. **Sustainability** — Reduce environmental impact.

**Memory trick:** Operational Excellence, Security, Reliability, Performance Efficiency, Cost Optimization, Sustainability.

## 13. AWS Cloud Adoption Framework (AWS CAF)

AWS CAF helps organizations plan and manage cloud adoption across six perspectives.

| Perspective | Focus |
|---|---|
| Business | Business value and strategy |
| People | Skills and organizational change |
| Governance | Policies, controls, and oversight |
| Platform | Cloud infrastructure and applications |
| Security | Security and compliance |
| Operations | Running and managing workloads |

**Exam tip:** The Well-Architected Framework focuses on designing and operating individual workloads well. AWS CAF focuses on organizational readiness and cloud adoption.

## Final Memory Checklist

Before moving to the practice questions, make sure you can explain:

- The five essential characteristics of cloud computing.
- The major benefits of cloud computing.
- Vertical scaling vs. horizontal scaling vs. elasticity.
- High availability vs. fault tolerance vs. disaster recovery.
- Public vs. private vs. hybrid cloud.
- IaaS vs. PaaS vs. SaaS.
- Region vs. Availability Zone vs. Edge Location.
- AWS vs. customer responsibilities.
- CapEx vs. OpEx and the purpose of TCO.
- The six Well-Architected pillars.
- The six AWS CAF perspectives.

## Official References

- [AWS Certified Cloud Practitioner — CLF-C02 Exam Guide](https://docs.aws.amazon.com/aws-certification/latest/cloud-practitioner-02/cloud-practitioner-02.html)
- [AWS Global Infrastructure](https://aws.amazon.com/about-aws/global-infrastructure/)
- [AWS Shared Responsibility Model](https://aws.amazon.com/compliance/shared-responsibility-model/)
- [AWS Well-Architected](https://aws.amazon.com/architecture/well-architected/)
- [AWS Cloud Adoption Framework](https://aws.amazon.com/cloud-adoption-framework/)
- [AWS Pricing Calculator](https://calculator.aws/)
