  $ cat > test1.c <<-EOF
  > int main() {
  >   return 42;
  > }
  > EOF
$ cat test1.c
32 bit
$ arm-linux-gnueabi-gcc test1.c -o test1.exe -static
$ strip --strip-all test1.exe -o test1.exe
$ file test1.exe
  $ readelf -a fac2.exe
  $ readelf -h fac2.exe | grep Entry
  $ ls -l ../../../default/fac2.exe
  $ file ../../../default/fac2.exe
  $ cmake_build/bintra

