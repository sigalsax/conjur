# Conjur has a UI
This project will encapsulate the effort to bring the Conjur UI (currently only for the Enterprise) into the open source project.

- [Current Challenges](#current-challenges)
- [Open Questions](#open-questions)
- [Benefits](#benefits)
- [Risks](#risks)
- [Costs](#costs)
- [Experience (Summary)](#experience-summary)
- [Experience (Detailed)](#experience-detailed)
- [Technical Details](#technical-details)
- [Testing](#testing)
- [Stories](#stories)
- [Future Work](#future-work)

### Current Challenges
- Customers want an UI to visually confirm and view policy resources
- Customers want a UI that allows them to perform basic operations

### Open Questions
- `<open questions that need to be answered>`
​
### Experience (Summary)
1. A users connects to Conjur using the default domain (ex: `https://conjur.mycompany.com`)
1. The user is redirected automatically to `https://conjur.mycompany.com/ui`
1. The user enters their username, password, and the account they would like to log into.
1. If the user has entered valid credentials, they are logged into the Dashboard.  If they have not entered valid credentials, they are redirected to the login screen with a warning message.
1. All current OS components are visible.  Enterprise features are hidden (audit, ldap-sync, clustering).
1. The user can navigate to view all Conjur resources.
1. The user user logs out successfully, and is redirected to the login screen.

### Experience (Detailed)
##### Assumptions
- `<list of assumptions being made>`

##### Workflow
1. `<step by step flow of configuring and using this feature>`

### Technical Details
This project will be broken up into a couple of different phases:
1. PoC implementation - focus on simply getting the UI functioning against the UI


`<technical details required for developing the above workflow>`

### Testing
`<overview of unit and integration tests to be added>`

### Benefits
- `<list of benefits>`

### Risks
- `<list of risk>`

### Costs
- `<list of costs>`
​
### Stories
- (PoC) UI is available (`kind/spike`)
  - tests
  - only
- UI login allows account specific login (`kind/enhancement`)
- UI uses native data objects (`kind/technical-debt`)
- UI specific API endpoints have been removed (`kind/technical-debt`)
- Javascript and Stylesheets compilation utilizes native Rails functionality (`kind/technical-debt`)
- LDAP-Sync UI is available in the appliance (`kind/enhancement`)
- Cluster dashboard is available in the appliance (`kind/enhancement`)


### Future Work
- `<list of potential future work>`
​
