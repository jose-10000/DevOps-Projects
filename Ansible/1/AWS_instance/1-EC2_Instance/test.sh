#!/bin/bash

# edit a file with tee

sudo tee -a test.txt <<EOF
zend_extension=opcache.so
opcache.enable=1
opcache.enable_cli=1
opcache.jit_buffer_size=500000000
opcache.jit=1235
EOF


sudo tee -a test1.txt <<EOF
[opcache]
opcache.enable=1
; 0 means it will check on every request
; 0 is irrelevant if opcache.validate_timestamps=0 which is desirable in production
opcache.revalidate_freq=0
opcache.validate_timestamps=1
opcache.max_accelerated_files=10000
opcache.memory_consumption=192
opcache.max_wasted_percentage=10
opcache.interned_strings_buffer=16
opcache.fast_shutdown=1
EOF