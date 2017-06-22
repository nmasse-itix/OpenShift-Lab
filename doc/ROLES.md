# Roles description

## Bootstrap roles

| Role | Description |
| --- | --- |
| [bootstrap](../roles/bootstrap/) | adds your SSH key to `authorized_keys`, creates users, configures sudo |
| [register-rhn](../roles/register-rhn/) | registers the target machine on RHN (Red Hat Network) and attaches a subscription pool |

## Regular roles

| Role | Description |
| --- | --- |
| [base](../roles/base/) | configures SSH to forbid password authentication, installs basic software and sets the hostname |
| [name-resolution](../roles/name-resolution/) | ensures name resolution through the whole cluster |
| [docker](../roles/docker/) | installs docker and configures docker storage |
| [openshift-prereq](../roles/openshift-prereq/) | ensures the system meet the pre-requisites for the OpenShift installation |
| [openshift-postinstall](../roles/openshift-postinstall/) | installs the latest JBoss ImageStreams |
| [3scale](../roles/3scale/) | deploys 3scale |
| [sso](../roles/sso/) | deploys Red Hat SSO |
