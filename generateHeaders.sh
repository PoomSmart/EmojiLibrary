#!/bin/bash

for d in $(find . -type d ! -name .git ! -name .theos ! -name obj ! -name packages ! -name 'Font*' -depth 1); do
  D=${d/\.\//}
  cd ${D}
  find . -type f -name '*.h' ! -name ${D}.h | sed 's/\.\///g' | sed '/^ *$/d;s/.*/#import "&"/' > ${D}.h
  cd ..
done
