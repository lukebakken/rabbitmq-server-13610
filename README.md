# Environment

* OS - Windows 11 24H2, build 26100.3476
* Erlang - 27.3
* Active Directory Lightweight DS

# Setup

* Set up AD LDS according to my notes here: https://github.com/lukebakken/misc/blob/main/ad-lds/README.md
* Create certificates for my laptop using [`tls-gen`](https://github.com/rabbitmq/tls-gen) `basic` profile. Certs are committed to this repo.
* Import certs using MMC snap-in according to [these directions](https://learn.microsoft.com/en-us/troubleshoot/windows-server/active-directory/enable-ldap-over-ssl-3rd-certification-authority). Import both the server certificate (`prokofiev.pfx`) as well as the Root CA (`ca_certificate.pem` file).
* Ensure that `Everyone` has `Read` access to the server certificate's private key.

# Repro

* Start `bakken-io` AD LDS Windows service.
* Use `ldp.exe` to verify that SSL / TLS connection can be made to `prokofiev:636`
* Use `openssl.exe` to verify:
    ```
    openssl.exe s_client -debug -CAfile ./ca_certificate.pem -connect localhost:636 -tls1_2 2>&1 | Out-File -Encoding ascii -LiteralPath openssl-output.txt
    ```
* Use `tls_client.erl` to verify:
    ```
    erlc.exe +debug .\tls_client.erl; erl.exe -boot no_dot_erlang -noinput -s tls_client start 2>&1 | Out-File -Encoding ascii -LiteralPath tls_client-output.txt
    ```
