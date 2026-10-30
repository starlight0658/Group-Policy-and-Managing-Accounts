# Publish the Group Policy and Managing Accounts lab

This archive contains a complete, ready-to-publish `Group-Policy-and-Managing-Accounts` repository with all 40 original screenshots visible directly in the README.

## Mac terminal workflow

1. Unzip the downloaded archive and open Terminal in the folder containing `Group-Policy-and-Managing-Accounts`.
2. Ensure that Git and GitHub CLI are installed, then authenticate to GitHub using `gh auth login`.
3. Run:

```bash
cd Group-Policy-and-Managing-Accounts
bash PUBLISH_TO_GITHUB.sh
```

The script checks GitHub authentication, creates the repository (if necessary), stages the README and 40 screenshots, and pushes to GitHub. It never force-pushes.

4. Copy the text from `PROFILE-README-ENTRY.md` into your public profile README at `https://github.com/starlight0658/starlight0658`, under the IT lab/project section.
5. Verify that all images render on `https://github.com/starlight0658/Group-Policy-and-Managing-Accounts`.

If `gh` is not installed on your Mac, run `brew install gh` first (requires Homebrew), then `gh auth login`.

**Important:** the screenshots include deliberately entered lab credentials; do not reuse those passwords on any active systems. Rotate or delete test credentials before publishing if the VMs remain accessible.
