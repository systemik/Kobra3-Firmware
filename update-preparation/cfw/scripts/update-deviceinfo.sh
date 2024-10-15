#!/bin/sh

DEVICE="-----BEGIN CERTIFICATE-----\\nMIIDNzCCAh8CFEHwer8CL4ncl5GcMROo5vXDrbdRMA0GCSqGSIb3DQEBCwUAMFgx\\nCzAJBgNVBAYTAkFVMRMwEQYDVQQIDApTb21lLVN0YXRlMSEwHwYDVQQKDBhJbnRl\\ncm5ldCBXaWRnaXRzIFB0eSBMdGQxETAPBgNVBAMMCFJvY2tjaGlwMB4XDTI0MTAw\\nMjEyMzczNFoXDTM0MDgxMTEyMzczNFowWDELMAkGA1UEBhMCQVUxEzARBgNVBAgM\\nClNvbWUtU3RhdGUxITAfBgNVBAoMGEludGVybmV0IFdpZGdpdHMgUHR5IEx0ZDER\\nMA8GA1UEAwwIUm9ja2NoaXAwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB\\nAQD5Cr65NCzNa7Dk4XkbRgLm/grwX7V54YK/fbjZvMvMokUvtXnr4a/o3nIXu8r8\\n3ASILfunN1YaDrdhHGCSiGDcbVFwqlLhjwVro2MbiE1G1CVfUZjvr64yFvhL0qy2\\nTZX0oqv6W6XAz/cXOa8xbanmilvKGjFn1wO/pjEwR1ZAZSMWpS62XVbUM1m3iVvV\\nY6NLS3K4KaOiXw8B3fFstskZ4QWaLXOH71EI2nrhH65MrWTXkWVpPaMZrN+kPMl1\\nvHv5NcvkpycaLT+Q2hsKKgM4993wzilBIJR0pIZXGhgbcJ1GskaMz8iixe/6ByL1\\nSN27un/OalKPogj1bzAsR7y7AgMBAAEwDQYJKoZIhvcNAQELBQADggEBAJ450fX9\\nDojXZ4RLStlzGVCsLMR1QK3Di3wdbKzgD5jdH/EZccBeYygQ7ohocaECS2RroKxo\\nxRZMO/pLMkV1rd9UuBi1iv0CTzGsmy5getLt7iQrnFxdRbaFHEpazkPA7MAO3NWu\\nBvgSPJbzEbmp8r4MevQC9nrp5bqQikEsuYxravn8DGJPAMeC7qYBePKBi2zSJ9NE\\n56aGPlXYzua8rK4xvm8Od3mQDfpGuZFuFShZV/6lEntkPpI+Gi56HkwQ4EQtQqoZ\\n/B0188iLOvMx5oFyNe9tGf95D1E6K8l/VWkepLqZ/xydT+7PIr42AbnckE9pIcKG\\nG/yUEfKKyBXGsnA=\\n-----END CERTIFICATE-----\\n"
DEVICEPK="-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQD5Cr65NCzNa7Dk\n4XkbRgLm/grwX7V54YK/fbjZvMvMokUvtXnr4a/o3nIXu8r83ASILfunN1YaDrdh\nHGCSiGDcbVFwqlLhjwVro2MbiE1G1CVfUZjvr64yFvhL0qy2TZX0oqv6W6XAz/cX\nOa8xbanmilvKGjFn1wO/pjEwR1ZAZSMWpS62XVbUM1m3iVvVY6NLS3K4KaOiXw8B\n3fFstskZ4QWaLXOH71EI2nrhH65MrWTXkWVpPaMZrN+kPMl1vHv5NcvkpycaLT+Q\n2hsKKgM4993wzilBIJR0pIZXGhgbcJ1GskaMz8iixe/6ByL1SN27un/OalKPogj1\nbzAsR7y7AgMBAAECggEAEPIQOYiOpoj2B7zn1q6UMqTamFyK0U5CQpwKtetzb+si\ntgpXz3BoiHnfst8OWCzzCf5xqdZ0FLXSTdihIZdcr+L9sE2GnN50dKHbc9t5wUtc\nzPg/ux9txO7B2mGYFZeAj/LPAkFg1+vOrlU4fIPaabDEaiNkyoyw2UY1AUn5WSGQ\n6Bz3bMU5myimC+b6rleip95dROlsprLo42xx9Is41Y1jUq/GF24d5EWDx8Xtxmyu\nByqUER1kLsAYmz9y8I/WWK78lP9jUzUzrgFmRIPsmvKYll7/+qkV4yosFrdIvbxp\neOvr1NUUDHhYDSYbHyLmee5sjWeYR5RPofql1H8IcQKBgQD+YAmBFE5gzgl8CklI\nuSBfq6cTm635mcg5QhrpydFI5XtfiId0XukBaY0dmF0XjpdGYRBm3i25FgSzzvCy\nF9b1aQqVPAqIrDuKvNDHExDjaFWT33A+Xid+KW9WoSTMcTsdseRlJyTdipwpeKR8\ndgU8qBHVIxEcL6Ngsiz16iKl/QKBgQD6ofylsAdSxdoxAEeK3Q7QEj7smvhDkqkn\nDrduTQ/Tq1VBo7UH+F6HNXn8f1o1lqPtow5C4D987noDm+Lo3a4EhiRAftIas7i+\nyUIlWuZjWlfqaM2mquHJUJnE63W6hJkgg53h91q6BIHY3eEVuF1LJavkWtDx1t8N\nPs2WC4UPFwKBgQCVL3XjgilFlRDy8oVwZUKbWWyvj0pFbO+ExURLgNWBTzVAHi5z\nDYbSETl19foC6tnFqP+ZlQxz1HoFioSXrmufmm9efswexARXpc08M+5fsL0f8Jc/\nvLCkyWBHClMuo+nrzH0K5h404CoeGGc/p2gC3v82ZU6PnVDQUS8VOq//cQKBgA3N\nR9Vz+SNEw/w40LfD7qHkr1RmQE+wTuJYvB813S5B3CMOOdTjh4kYl8wg0z3qOsLG\nXO2v3a8qjsuOFRPPyVp0bKCkmztfNEhFWwAlnlRQUFEXTmPkOyTT7HPcp5IK5UfW\nF6au8W8W+nOP3GpOycxumaWsnp8CvyvCjp25qq0nAoGBAMyzqkL7EYaKdfe6p2yO\nBzyJFc19kC8/pr+lxk66ISS3iezVQNkHwGx/JlZCi9mZeuCJBpi1Td8R/cgQY8kx\nnaH6th+RXWf1NilSWo/YF9U3Xe79VHBt6sRJcrVLYFPLKm+lSpsXegAmC2d14QMO\n7AHwHfmWd1TPesA/rUqs8tgl\n-----END PRIVATE KEY-----\n"

/useremain/cfw/binaries/jq --arg devicecrt "$DEVICE" --arg devicepk "$DEVICEPK" '.devicecrt = $devicecrt | .devicepk = $devicepk' /userdata/app/gk/config/device_account.json > tmp.json && mv tmp.json /userdata/app/gk/config/device_account_new.json 