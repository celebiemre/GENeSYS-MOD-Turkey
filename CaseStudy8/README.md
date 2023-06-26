# GENeSYS-MOD-Turkey
GENeSYS-MOD Turkey (openENTRANCE CASE STUDY 8)
## Case Study 8: The role of natural gas storage for flexibility
This repo includes GENeSYS-MOD-Turkey model files for Case Study 8 (CS8) in openENTRANCE project. It includes modifications to GAMS files as well as input/output files (as much as GitHub storage limit allows for).
---

# INTRODUCTION
GENeSYS-MOD-Turkey is a version of the pan-EU GENeSYS-MOD v3.1, but includes updates for Turkish energy data from various sources. Detailed energy data for Turkey is available in the model:
*  Gas storage capacity of Turkey (from Petroleum Pipeline Corporation (BOTAŞ))
*   Hourly generation profiles, hourly load profiles (available in current GENeSYS-MOD v3.1 database)
*  Energy demand (updated for Turkey model from Ministry of Energy and Natural Resources)
*  Transportation data (from several sources, such as statistics from Ministry of Transport and Infrastructure, Ministry of Environment, Urbanisation and Climate Change)
*  Installed capacities and generation/production mix per technology and sector (from the transparency platform of Energy Exchange Istanbul (EXIST) i.e., EPİAŞ))
*  Energy balances (from Ministry of Energy and Natural Resources)
*  Emissions (from UNFCC, Turkey, 2022 National Inventory Report (NIR))
*  Generation/production costs (available in current GENeSYS-MOD v3.1 database)
*  Maximum storage capacities
*  Minimum storage requirements (assumed as 10% overall storage capacity)
*  Seasonal variations in natural gas imports (specifically between December & March, based on monthly variations, BOTAŞ)
*  73-hour steps for all scenarios

There is also modifications to GENeSYS-MOD v3.1 public files that can be observed from commit history.