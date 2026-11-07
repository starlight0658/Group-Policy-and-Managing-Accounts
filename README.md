# Group Policy and Managing Accounts

**Hands-on Azure / Windows Server lab** · Active Directory · Group Policy · Account security · Windows Event Viewer · IT support

## Project overview

Configured an account-lockout policy for an Azure-hosted Active Directory test domain, validated policy application on a domain-joined Windows client, reproduced locked/disabled account sign-in failures, performed account recovery and lifecycle management in ADUC, and inspected Windows Security event logs.

**Skills demonstrated:** Group Policy Management (GPMC) · Active Directory Users and Computers (ADUC) · account lockout and password resets · group policy troubleshooting · Event Viewer · Windows authentication auditing · RDP troubleshooting.

## Lab environment

| Component | Lab configuration |
| --- | --- |
| Platform | Microsoft Azure virtual machines |
| Domain controller | `DC-1` — Windows Server, AD DS / DNS |
| Client | `Client-1` — domain-joined Windows 11 workstation |
| Test domain | `mydomain.com` / `MYDOMAIN` |
| Sample test account | `bame.siv` in `_EMPLOYEES` |
| Administration | Group Policy Management, ADUC, PowerShell, Event Viewer |

## Tasks performed and validated

1. **Account lockout policy:** Edited the isolated lab domain’s Default Domain Policy. Configured **5 invalid sign-in attempts**, **30-minute lockout**, and **10-minute lockout-counter reset**. Captured the resulting policy summary.
2. **Policy deployment:** Executed `gpupdate /force` on `Client-1`, confirmed successful computer/user policy refresh, and used `gpresult /r` to verify the applied Default Domain Policy.
3. **Account lockout response:** Reproduced incorrect-password attempts via Windows App / RDP, observed the account-locked error, located the affected employee object in ADUC, and selected the unlock operation.
4. **User administration:** Practiced account disable, enable, and password-reset workflows; observed the corresponding Active Directory confirmations and disabled-account RDP error. Validated a domain-user session with `whoami`.
5. **Event investigation:** Reviewed Windows Security logs on `DC-1` and `Client-1`, including **Event ID 4625** (failed logon), **4776** (credential validation), and **4634** (logoff). Examined the affected username and authentication status in event details.


**01. Located a sample AD employee account.**

Located the generated `bame.siv` user in Active Directory Users and Computers.

![Screenshot 01: Locate a sample AD employee account](screenshots/01-locate-a-sample-ad-employee-account.jpg)

**02. Tested a bad-password RDP sign-in.**

Submitted an intentionally incorrect password for the lab employee account.

![Screenshot 02: Test a bad-password RDP sign-in](screenshots/02-test-a-bad-password-rdp-sign-in.jpg)

**03. Observed an authentication failure after trying to login 10 times with an incorrect password.**

Windows App rejects the incorrect credentials.

![Screenshot 03: Observe an authentication failure](screenshots/03-observe-an-authentication-failure.jpg)

**04. Next, we tried to login with the correct password, hoping that the account is now locked after 10 failed login attempts.
However, we were able to login sucessfully.**

Reason: The account lockout policy was not set in AD, so I'm going to configure a Group Policy for that.

![Screenshot 04: Inspect the employee client session](screenshots/04-inspect-the-employee-client-session.jpg)

**05. Opened Group Policy Management in the Domain Controller DC-1.**

Launched the GPMC console against the lab domain (Click "Windows" icon > Run > gpmc.msc > OK)

![Screenshot 05: Open Group Policy Management](screenshots/05-open-group-policy-management.jpg)

**06. Reviewed the Default Domain Policy link**

Inspected the policy scope and security filtering for `mydomain.com`.

![Screenshot 06: Review the Default Domain Policy link](screenshots/06-review-the-default-domain-policy-link.jpg)

**07. Opened the policy editor**

Selected **Edit** to configure domain account policy settings.

![Screenshot 07: Open the policy editor](screenshots/07-open-the-policy-editor.jpg)

**08. Navigated to the existing Account Lockout Policy**

Expanded in the following order: Computer Configuration>Policies>Windows Settings>Security Settings>Account Policies>Account Lockout Policy.

![Screenshot 08: Inspect the existing Account Lockout Policy](screenshots/08-inspect-the-existing-account-lockout-policy.jpg)

**09. Configured the 30-minute lockout duration**

Double clicked on "Account lockout duration" and set the period that a locked account stays locked before automatic release - 30 minutes.

![Screenshot 09: Configure the 30-minute lockout duration](screenshots/09-configure-the-30-minute-lockout-duration.jpg)

**10. Set a five-attempt lockout threshold**

Double clicked on Account lockout threshold and set the account-lockout threshold as 5 invalid logon attempts.

![Screenshot 10: Set a five-attempt lockout threshold](screenshots/10-set-a-five-attempt-lockout-threshold.jpg)

**11. Verifed the configured domain lockout policy**

Clicked on "Default Domain Policy" and then "Settings" in the right menu. Reviewed the resulting policy settings: 5 attempts, 30-minute lockout duration, and 10-minute counter reset.

![Screenshot 11: Verify the configured domain lockout policy](screenshots/11-verify-the-configured-domain-lockout-policy.jpg)

### Applied the GPO and reproduced account lockout

**12. Reconnected with the Client-1 as administrator using RDP App for Windows**

![Screenshot 12: Reconnect with the domain administrator](screenshots/12-reconnect-with-the-domain-administrator.jpg)

**13. Forced a client Group Policy refresh**

Opened Command line by clicking Windows icon, then typed cmd and opened Command line, then Run `gpupdate /force`; observed computer and user policy updates report success.

![Screenshot 13: Force a client Group Policy refresh](screenshots/13-force-a-client-group-policy-refresh.jpg)

**14. Confirmed the applied Group Policy**

Then I opened Command Prompt in Administrative Mode by clicking Windows icon, typed cmd and chose Command Prompt in Admin mode. Then I run `gpresult /r` to identify the applied Default Domain Policy on `Client-1`. Observed that the Policy was applied few minutes ago and is recent.

![Screenshot 14: Confirm the applied Group Policy](screenshots/14-confirm-the-applied-group-policy.jpg)

**15. Repeated the invalid sign-in attempts**

Submitted a deliberately incorrect password to test the configured lockout behavior.

![Screenshot 15: Repeat invalid sign-in attempts](screenshots/15-repeat-invalid-sign-in-attempts.jpg)

**16. Verifed the lockout error**

RDP reports the account is locked after too many sign-in/password attempts.

![Screenshot 16: Verify the lockout error](screenshots/16-verify-the-lockout-error.jpg)

### Unlock, disable, enable, and reset a domain account

**17. Found the affected user in ADUC**

Used the directory search workflow to locate `bame.siv` for remediation.

![Screenshot 17: Find the affected user in ADUC](screenshots/17-find-the-affected-user-in-aduc.jpg)

**18. Reviewed directory search results**

Found the target employee account among matching users.

![Screenshot 18: Review directory search results](screenshots/18-review-directory-search-results.jpg)

**19. Inspected the locked account properties**

Examined the Account tab and its account-lockout controls.

![Screenshot 19: Inspect the locked account properties](screenshots/19-inspect-the-locked-account-properties.jpg)

**20. Unlocked the account**

Selected the unlock option and applied the change in ADUC.

![Screenshot 20: Unlock the account](screenshots/20-unlock-the-account.jpg)

**21. Tested the valid domain-user password**

Retried authentication with the lab user’s normal test password.

![Screenshot 21: Test the valid domain-user password](screenshots/21-test-the-valid-domain-user-password.jpg)

**22. Verified the authenticated domain identity**

Run `whoami` in PowerShell and confirmed `mydomain\bame.siv`.

![Screenshot 22: Verify the authenticated domain identity](screenshots/22-verify-the-authenticated-domain-identity.jpg)

**23. Disabled the employee account**

Used ADUC to disable the sample account for the lifecycle-management exercise.

![Screenshot 25: Re-enable the employee account](screenshots/25-re-enable-the-employee-account.jpg)


**24. Confirmed the account has been disabled**

Observed the Active Directory success message for the disable action.

![Screenshot 26: Verify account re-enablement](screenshots/26-verify-account-re-enablement.jpg)

**25. Validated the disabled-account sign-in restriction**

Captured the RDP error produced during the disabled-account access test.

![Screenshot 27: Validate the disabled-account sign-in restriction](screenshots/27-validate-the-disabled-account-sign-in-restriction.jpg)

**26. Re-enabled the employee account**

Used the directory context menu to enable the user again.

![Screenshot 28: Start the password reset workflow](screenshots/28-start-the-password-reset-workflow.jpg)

**27. Verified account re-enablement**

Observed the Active Directory success message for enabling the account.

![Screenshot 29: Inspect password reset and unlock options](screenshots/29-inspect-password-reset-and-unlock-options.jpg)


**28. Started the password reset workflow**

Located **Reset Password** for the selected employee account.

![Screenshot 23: Disable the employee account](screenshots/23-disable-the-employee-account.jpg)

**29. Inspected password reset and unlock options**


![Screenshot 24: Confirm the account has been disabled](screenshots/24-confirm-the-account-has-been-disabled.jpg)


**30. Confirmed that the user login with the new password is successful**

![Screenshot 30: Review the active user session](screenshots/30-review-the-active-user-session.jpg)

### Reviewed authentication and security audit logs

**31. Launched Windows Event Viewer**

Located `eventvwr.msc` for the next audit-evidence stage.

![Screenshot 31: Launch Windows Event Viewer](screenshots/31-launch-windows-event-viewer.jpg)

**32. Inspected domain-controller security events**

Opened the Security log on `DC-1`; noted logon and credential-validation activity.

![Screenshot 32: Inspect domain-controller security events](screenshots/32-inspect-domain-controller-security-events.jpg)

**33. Located the Security log search tool**

Used the Event Viewer Find control for targeted security-event investigation.

![Screenshot 33: Locate the Security log search tool](screenshots/33-locate-the-security-log-search-tool.jpg)

**34. Searched domain-controller events for the employee**

Searched for `bame` and inspect matching account activity such as Event ID 4634.

![Screenshot 34: Search domain-controller events for the employee](screenshots/34-search-domain-controller-events-for-the-employee.jpg)

**35. Opened Event Viewer on the client**

Inspected the client computer’s local event log console.

![Screenshot 35: Open Event Viewer on the client](screenshots/35-open-event-viewer-on-the-client.jpg)

**36. Started Event Viewer with elevation**

Choose **Run as administrator** to access protected event logs.

![Screenshot 36: Start Event Viewer with elevation](screenshots/36-start-event-viewer-with-elevation.jpg)

**37. Authorized the administrative tool**

Used User Account Control to elevate Microsoft Management Console.

![Screenshot 37: Authorize the administrative tool](screenshots/37-authorize-the-administrative-tool.jpg)

**38. Reviewed the client Event Viewer console**

Navigated to Windows Logs for local authentication-event evidence.

![Screenshot 38: Review the client Event Viewer console](screenshots/38-review-the-client-event-viewer-console.jpg)

**39. Inspected failed logon audit events**

Selected Security Event ID 4625, indicating a failed account logon.

![Screenshot 39: Inspect failed logon audit events](screenshots/39-inspect-failed-logon-audit-events.jpg)

**40. Reviewed the failed-logon event details**

Inspected Event 4625 for `bame.siv`, including authentication failure data and network source.

![Screenshot 40: Review the failed-logon event details](screenshots/40-review-the-failed-logon-event-details.jpg)

## Commands used

```powershell
gpupdate /force         # Refresh computer and user policies
gpresult /r             # Identify applied GPOs
whoami                  # Verify signed-in domain identity
gpmc.msc                # Group Policy Management
eventvwr.msc            # Event Viewer
```
