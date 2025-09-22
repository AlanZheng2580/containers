# OpenResty: Patch Generation Guide

This guide explains how to download the OpenResty source code, generate a patch to mask sensitive data in error logs.

## Prerequisites

Before starting, make sure you have the following packages installed:

```bash
sudo apt-get update
sudo apt-get install build-essential gdb psmisc
```

# Step 1: Install Extensions for Debugging

Install the necessary extensions for debugging:

C/C++, C/C++ Themes, and C/C++ Theme

# Step 2: Download OpenResty and Required Modules

Change to your workspace directory:

```bash
cd /home/kasm-user/workspace/containers/openresty
mkdir scr && cd src
```

Download OpenResty source code:

```bash
curl -O https://openresty.org/download/openresty-1.27.1.2.tar.gz
tar -zxvf ./openresty-1.27.1.2.tar.gz
git clone --branch 2.5.3 https://github.com/nginx-modules/ngx_cache_purge.git
git clone --branch v0.2.4 https://github.com/vozlt/nginx-module-vts.git
```

# Step 3: Build and Install OpenResty with Custom Modules

Change to the OpenResty directory:

```bash
cd openresty-1.27.1.2
```

Configure OpenResty with the desired module, Compile and install OpenResty:

```bash
./configure --with-debug --prefix=/home/kasm-user/workspace/containers/openresty/output --with-pcre-jit --with-http_realip_module --with-http_ssl_module --with-http_stub_status_module --with-http_v2_module --with-http_gzip_static_module --with-http_gunzip_module --with-http_auth_request_module --with-http_sub_module --with-mail_ssl_module --with-mail --with-compat --with-file-aio --with-http_addition_module --with-http_dav_module --with-http_flv_module --with-http_geoip_module=dynamic --with-http_image_filter_module=dynamic --with-http_mp4_module --with-http_random_index_module --with-http_secure_link_module --with-http_slice_module --with-http_xslt_module=dynamic --with-ipv6 --with-md5-asm --with-sha1-asm --with-stream_realip_module --with-threads --with-stream --add-dynamic-module=../ngx_cache_purge --add-module=../nginx-module-vts && make -j$(nproc) && make install
```

# Step 4: Modify Nginx Source Code for Masking Sensitive Data

Navigate to the source code directory:

```bash
cd src/openresty-1.27.1.2/bundle/nginx-1.27.1/src/
```

Backup the original ngx_http_request.c file:

```bash
cp openresty-1.27.1.2/bundle/nginx-1.27.1.2/src/http/ngx_http_request.c openresty-1.27.1.2/bundle/nginx-1.27.1.2/src/http/ngx_http_request.c.orig
```

Modify the ngx_http_request.c file to mask the Signature parameter in the request line.

Create a patch to record the changes:

```bash
diff -u openresty-1.27.1.2/bundle/nginx-1.27.1.2/src/http/ngx_http_request.c.orig openresty-1.27.1.2/bundle/nginx-1.27.1.2/src/http/ngx_http_request.c > ../mask-Signature.patch
```

This will generate a patch file mask-Signature.patch which can be applied to the source code later.

# Add the following configurations to nginx.conf for debugging.

```
ation /debug {
        content_by_lua_block {
        local vars = {
                "request",        -- whole request line: "GET /foo HTTP/1.1"
                "request_uri",    -- "/foo?bar=1"
                "uri",            -- "/foo" (without args)
                "args",           -- "bar=1"
                "unparsed_uri",   -- (same as request_uri usually)
                "scheme",         -- "http" or "https"
                "host",           -- request Host header
                "server_protocol",-- "HTTP/1.1"
                "remote_addr",    -- client IP
                "remote_port",    -- client port
                "server_addr",    -- local server IP
                "server_port",    -- local server port
                "request_length", -- total request size
                "query_string",   -- same as args
        }

        ngx.say("=== NGINX variable dump ===")
        for _, v in ipairs(vars) do
                ngx.say(string.format("%-16s : %s", v, ngx.var[v] or "nil"))
        end
        }
}
```