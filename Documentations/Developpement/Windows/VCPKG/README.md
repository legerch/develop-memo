1. Cloner projet VCPKG (microsoft) : (dans le C:)
2. Ouvre un terminal dans VCPKG
3. Lancer le script
4. Ouvrir un terminal admin dans le vcpkg
5. vcpkg integrate install
6. Ajouter la ligne "-DCMAKE_TOOLCHAIN_FILE=[path to vcpkg]/scripts/buildsystems/vcpkg.cmake" dans le toolkit Qt CMake utilisé (sans le -D)
7. Installer le package nécessaire en précisant la board utilisé (ex: vcpkg install zlib:x64-windows) (liens liste packages : https://vcpkg.io/en/packages.html)
8. Peut être nécessaire d'ajouter le package linguistique EN en passant par le visual studio installer (modifier -> composant linguistique -> anglais)