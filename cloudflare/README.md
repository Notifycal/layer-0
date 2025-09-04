# Cloudflare Configuration for Notifycal

This repository contains the OpenTofu configuration for managing Notifycal's Cloudflare resources.

## Logical Units

This project is divided into the following logical units:

### ACM SSL Certificates

This project manages the creation of ACM SSL certificates for both production and non-production environments. These certificates are used to secure the Notifycal web application. The certificates are validated using DNS records that are automatically created in Cloudflare.

### GitHub IDP

This project configures a GitHub Identity Provider (IDP) in Cloudflare Access. This allows developers to log in to development (and more generally, nonprod environments) using their GitHub accounts, providing a secure and convenient way to access protected resources.

### Google Domain Verification

This project manages the Google domain verification process for the Notifycal domains. This is necessary for Google to verify ownership of the domains, which is a prerequisite for using Google services such as Google Search Console and Google Workspace.

### Email Redirection

This project configures email redirection rules in Cloudflare to forward emails sent to various addresses at `notifycal.com` to a single Gmail account. This allows for the creation of multiple email aliases without the need to manage multiple email inboxes.
