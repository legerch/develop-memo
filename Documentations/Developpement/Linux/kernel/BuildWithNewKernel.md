# Procédure de build avec nouveau kernel

Veuillez vérifier au préalable que tous les paquets nécessaires à la compilation du noyau sont présents : [Minimal requirements to compile the Kernel](https://www.kernel.org/doc/html/latest/process/changes.html)  

1 - Télécharger le kernel depuis le site officiel : [https://www.kernel.org/](https://www.kernel.org/ "https://www.kernel.org/")  
2 - Appliquer les patches :
```shell
cd linux-x.y.z/

# Unique patch
patch -p1 < /pathToPatches/myPatch.patch

# Multiple patch from directory
for p in `ls -v /path/to/patches/*.patch`; do patch -p1 < /path/to/patches/$p; done
```

3 - Copier la configuration à partir d'un _defconfig_ (car si le defconfig est un peu ancien, il sera modifié pour être mis à jour, l'ancien prendra alors l'extension `.old`):
```shell
cp path/to/defconfig path/to/linux-kernel/
```

4 - Charger la configuration à partir d'un _defconfig_ (menu based program | QT based front-end | GTK based front-end):
```shell
# Configure
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- O=build-linux-borea_rp2 menuconfig|xconfig|gconfig

# Load
# Open defconfig file and save
```

5 - Compiler le kernel :
```shell
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- O=build-linux-borea_rp2 -j8
```
**Attention** : L'option _O=_ prend en paramètre un répertoire qui doit appartenir au répertoire des sources du kernel  
> To locate output files in a separate directory two syntaxes are supported.  
> In both cases the working directory must be the root of the kernel src.  
> Use "make O=dir/to/store/output/files/"

6 - Compiler les modules :
```shell
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- O=build-linux-borea_rp2 -j8 INSTALL_MOD_PATH=modules-borea modules
```

7 - Déployer les modules :
```shell
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- O=build-linux-borea_rp2 -j8 INSTALL_MOD_PATH=modules-borea modules_install
```

# Astuces

## Recompiler seulement les device-tree

```shell
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- O=build-linux-borea_rp2 dtbs
```

# Problèmes rencontrés et solutions 
- Le fichier **imx6q-ciele_borea_rp2.dtb** (fichier source placé dans _arch/`<arch>`/boot/dts) n'est pas généré    
L'entrée dans le Makefile n'est pas présente, il faut l'ajouter dans _arch/`<arch>`/boot/dts/Makefile_
```Makefile
[...]
    imx6q-b650v3.dtb \
	imx6q-b850v3.dtb \
	imx6q-ciele_borea_rp2.dtb \
	imx6q-cm-fx6.dtb \
	imx6q-cubox-i.dtb \
[...]
```

- Le module **mt9m114.ko** n'est pas généré  
Comme expliqué dans la description :  
> To compile this driver as a module, choose M here: the module will be called mt9m114  

Ainsi, veuillez vérifier dans le _.config_ que la valeur associée est bien **M** (Autres valeurs : _N/Y_)  

# Liens utiles
- [Documentation du Cobra : compilation et installation](../../../InstallAndUpdate/Compilation%20%5Bapp%2C%20modules%5D.md)  
- [Documentations kernel linux](https://www.kernel.org/doc/html/latest/index.html)  
- [Tutoriel linux : chapitre des patches](https://www.linuxtopia.org/online_books/linux_kernel/kernel_configuration/ch07s02.html)
  
  