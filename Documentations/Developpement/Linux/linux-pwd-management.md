**Table of contents :**
- [1. Introduction](#1-introduction)
- [2. Details of password management](#2-details-of-password-management)
  - [2.1. Fields format of `etc/shadow`](#21-fields-format-of-etcshadow)
- [3. How to set password ?](#3-how-to-set-password-)
  - [3.1. On target](#31-on-target)
    - [3.1.1. Set account password](#311-set-account-password)
    - [3.1.2. Useful options](#312-useful-options)
  - [3.2. On host](#32-on-host)
- [4. Ressources](#4-ressources)

# 1. Introduction

This tutorial is about : **How to set password on buildroot configuration ?**

Password management described below is for configuration build with **Buildroot**, and more precisely **Busybox** which provides well-known tools adapted for embedded platforms.

# 2. Details of password management

All passwords user's account are store into a file called : `etc/shadow`.  
The `etc/shadow` file stores actual password in encrypted format (more like the hash of the password) for user’s account with additional properties related to user password. 

## 2.1. Fields format of `etc/shadow`

All fields are separated by a colon `:` symbol. It contains one entry per line for each user listed in `/etc/passwd` file.  
We use some examples : 
1. `ramdomuser:$5$aojs0pPyhR$.pX42/RDJv4sbCG2f6sQDcolrgR89gCwfS9OPwDVMBD:13064:0:99999:6:::` (_passwd :_ `randompassword`)
2. `greatuser:$5$59UHJdFbDe$2ktuoKXapcLxfbDlxEXDqmzF7V4S.MJG4pI7iXx.bMB:::::::` (_passwd :_ `greatpassword`)

Let's cut all fields :

| N° | Username | Password | Last password change | Minimum | Maximum | Warn | Inactive | Expire |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
| 1 | randomuser | $5$aojs0pPyhR$.pX42/RDJv4sbCG2f6sQDcolrgR89gCwfS9OPwDVMBD | 13064 | 0 | 99999 | 6 |
| 2 | greatuser | $5$59UHJdFbDe$2ktuoKXapcLxfbDlxEXDqmzF7V4S.MJG4pI7iXx.bMB |

- **Username :** User login account
- **Password :** Encrypted password of the account. The password should be minimum 8-12 characters long including special characters, digits, lower case alphabetic and more.  
Usually password format is set to `$id$salt$hashed`, The `$id` is the algorithm used on GNU/Linux as follows :
    - `$1$` is _MD5_
    - `$2a$` is _Blowfish_
    - `$2y$` is _Blowfish_
    - `$5$` is _SHA-256_
    - `$6$` is _SHA-512_
- **Last password change (lastchanged) :** Days since `Jan 1, 1970` that password was last changed
- **Minimum** : The minimum number of days required between password changes i.e. the number of days left before the user is allowed to change his password
- **Maximum** : The maximum number of days the password is valid (after that user is forced to change his password)
- **Warn** : The number of days before password is to expire that user is warned that his password must be changed
- **Inactive** : The number of days after password expires that account is disabled
- **Expire** : Days since `Jan 1, 1970` that account is disabled i.e. an absolute date specifying when the login may no longer be used.

# 3. How to set password ?

## 3.1. On target

### 3.1.1. Set account password

Use `passwd <account>` :
```shell
Changing password for root
New password: 
Bad password: too short
Retype password: 
Password for root changed by root
```
> If your password seems to be too simple for the system it will tell it, but the password is **changed**. 

### 3.1.2. Useful options

1. Set algorithm to use

By default, `passwd` from **Busybox** will use _md5_ algorithm, better to use _sha256_ or _sha512_ algorighms :
```shell
passwd -a <alg> <account>
```
> Available algorithms can be displayed with `passwd --help`.  
> With **Busybox v1.31.1**, available algorithms are : _des_, _md5_, _sha256_ and _sha512_.

2. Set password to empty

This option can be useful in development phase, it used to completly removed usage of password for specified account :
```shell
passwd -d root
```

## 3.2. On host

If we have a big production of APF* to flash with the same default password it will be really painfull to change it on each boards. The best way is then to change it under your rootfs.

1. Download needed package `whois` which include **mkpasswd** tool.

2. Generate crypted password :
```shell
mkpasswd -m sha256crypt

# This will print (we used password `awesomepassword`) :
Password : 
$5$H61x6d7Aw35KqecN$TuAwiii2c./fdnbdzDW3wwGo3wm8Juzy8Wo8.7TD7E2
```
> Default algorithm used is **MD5** algorithm, so better to use **SHA-256/512** algorithms.  
> To get all available algorithms, use `-m` option with type equals to `help` : `mkpasswd -m help`.

3. Replace encrypted password into `etc/shadow` file :
```shell
# Original line :
greatuser:$5$59UHJdFbDe$2ktuoKXapcLxfbDlxEXDqmzF7V4S.MJG4pI7iXx.bMB:::::::

# Is replaced by :
greatuser:$5$H61x6d7Aw35KqecN$TuAwiii2c./fdnbdzDW3wwGo3wm8Juzy8Wo8.7TD7E2:::::::
```
> Use _buildroot-external/overlays_ to do that.

# 4. Ressources

- Tutorials :
  - https://www.cyberciti.biz/faq/understanding-etcshadow-file/
  - http://www.armadeus.org/wiki/index.php?title=How_to_set_the_default_root_password