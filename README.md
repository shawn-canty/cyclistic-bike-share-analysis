# Cyclistic Bike-Share: Consumer Behavior & Membership Conversion Strategy

**Lead Analyst:** Shawn Canty

**Date:** June 2026

### 1. Business Context & Objective
Cyclistic, a leading Chicago bike-share network, relies on annual memberships as its main driver of long-term profitability. The Director of Marketing aims to maximize Annual Recurring Revenue (ARR) by converting existing "Casual" riders into "Annual Members" rather than investing heavily in new customer acquisition.

**Primary Objective:** Identify behavioral and usage differences between Casual riders and Annual Members and deliver targeted data-driven marketing strategies to increase membership conversions.

### 2. Key Stakeholders
* **Lily Moreno:** Director of Marketing (Project Sponsor)
* **Cyclistic Executive Team:** Strategic Approval
* **Marketing Analytics Team:** Implementation and Strategy Execution

### 3. Scope & Methodology
This analysis evaluates about 5.9 million first-party operational records logged over 12 months.
* **Methodology:** Because the dataset is fully anonymized, behavioral modeling relies exclusively on aggregate temporal and spatial trends.
* **Tech Stack:** Google BigQuery (SQL) for data ingestion, cleaning, and transformation; Tableau for interactive geographic and temporal data visualization.

### 4. Project Phases & Deliverables
* **Data Preparation & Processing:** An automated SQL pipeline audits, cleans, and consolidates 12 months of raw trip data to ensure accurate baseline metrics.
* **Exploratory Data Analysis (EDA):** Segmenting ride data by time, duration, and geographic location to identify measurable differences in consumer behavior.
* **Strategic Synthesis:** An executive-facing Tableau dashboard and strategic brief translating data findings into actionable marketing campaigns.

---

## Executive Summary

### Project Overview
This analysis evaluated 5.9 million historical Cyclistic bike-share trips to identify key behavioral differences between Casual riders and Annual Members. The objective is to use these insights to design targeted marketing strategies that convert active Casual riders into profitable Annual Members.

### Key Behavioral Insights
* **The Commuter vs. The Tourist:** Annual members display routine commuting behavior, with peak usage mid-week at downtown transit hubs. Conversely, Casual riders behave as tourists and leisure users, with ridership surging on weekends (peaking at over 413,000 casual rides on Saturdays) heavily concentrated at coastal landmarks like Navy Pier.
* **The Duration Gap:** Casual riders average over 19 minutes per trip, compared to 11.8 minutes for Annual Members. This gap widens to over 22 minutes on Sundays, confirming that Casual users use the network for extended leisure travel, not brief transit.
* **The Fair-Weather Rider:** Casual usage depends heavily on weather, rising to over 323,000 rides in August but dropping below 24,000 in January. Annual members maintain a stronger, consistent baseline throughout winter.

### Strategic Recommendations
Given these behavioral divides, standard 12-month commuter memberships will not appeal to Casual users. I recommend the following three-part strategy to drive conversions:
1. **Launch a "Summer Pass":** Offer a 90-day introductory summer tier aimed at Casual riders. This lowers the financial barrier to entry when their demand is at its peak, creating a warm pipeline for full-year upsells in the fall.
2. **Target Coastal Stations During Weekend Peaks:** Eliminate broad marketing spend and hyper-focus digital and physical weekend advertising exclusively on the ten busiest coastal stations (e.g., Navy Pier) where Casual ridership is guaranteed.
3. **Implement a "Weekend Explorer" Perk:** Increase the standard weekend ride time limit for Annual Members from 30 to 45 minutes. This directly addresses the 22-minute average Casual ride, offering them a clear financial incentive to upgrade and avoid overage fees on their long leisure rides.

**Next Steps:** Collaborate with the marketing team to model target pricing for the Summer Pass using seasonal volume forecasts to prepare for a late-April launch.
