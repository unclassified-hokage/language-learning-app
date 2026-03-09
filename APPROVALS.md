# Approvals & Permissions

This file is how you communicate approvals to the daily autonomous task.
When Claude needs your permission for something, it will:
1. Add a question here under "PENDING"
2. Send you a Slack message with the question
3. On the next run, read your answer and proceed

---

## How to respond
Edit this file and move the item from PENDING to APPROVED or REJECTED.
Or simply write YES/NO next to the question.

---

## PENDING
*(none right now)*

---

## APPROVED
*(none yet)*

---

## REJECTED
*(none yet)*

---

## Standing Permissions (always approved, no need to ask each time)
- Write new files and documents to the project
- Commit and push code/docs to GitHub
- Send Slack notifications and email reports
- Install Flutter dependencies (pub packages)
- Create new folders in the project
- Run tests

## Always Ask First (never proceed without YES)
- Delete any existing files
- Change app store credentials or publish to stores
- Modify environment configs (dev/uat/prod switching)
- Add paid API keys or change billing-related settings
- Make the GitHub repo private or change repo settings
- Any action costing real money
