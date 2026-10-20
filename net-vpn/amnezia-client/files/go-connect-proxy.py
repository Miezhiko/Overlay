#!/usr/bin/env python3
# Miezhiko overlay: minimal local HTTP CONNECT forward proxy, used only to let
# the prebuilt `go` toolchain (fetched by the amnezia-xray-bindings Conan
# recipe) reach proxy.golang.org/sum.golang.org during `go mod download`.
#
# cmd/go's own hostname resolution never uses cgo/NSS (the go tool binary is
# always built without cgo support, even when CGO_ENABLED=1 is the default
# for *user* code) -- it always falls back to its pure-Go resolver, which
# reads /etc/resolv.conf directly and sends a raw UDP query straight to
# whatever nameserver is listed there. On hosts where that nameserver is a
# LAN router (as opposed to the local systemd-resolved stub at 127.0.0.53)
# and a firewall only permits DNS from the stub resolver, that raw UDP
# query is rejected and every later write on the socket fails with EPERM
# (the classic "ICMP admin-prohibited poisons the connected UDP socket"
# behavior) -- regardless of GODEBUG=netdns=cgo, which cmd/go silently
# ignores for exactly this reason.
#
# Go's HTTP client *does* honor the standard https_proxy/http_proxy env
# vars for its module-proxy fetches, and a CONNECT tunnel only requires Go
# to resolve this proxy's own address (a literal 127.0.0.1, so no DNS at
# all) -- the actual target hostname is resolved here, in Python, via the
# normal glibc/NSS path (which correctly goes through systemd-resolved and
# is not blocked). That sidesteps cmd/go's broken resolver entirely without
# touching the system's /etc/hosts or vendoring the whole go.sum closure.
import socket
import sys
import threading
from http.server import BaseHTTPRequestHandler
from socketserver import ThreadingMixIn, TCPServer


class ConnectHandler(BaseHTTPRequestHandler):
    protocol_version = "HTTP/1.1"

    def log_message(self, *_args):
        pass

    def do_CONNECT(self):
        host, _, port = self.path.partition(":")
        port = int(port or 443)
        try:
            upstream = socket.create_connection((host, port), timeout=15)
        except OSError as exc:
            self.send_error(502, str(exc))
            return

        self.send_response(200, "Connection Established")
        self.end_headers()

        client = self.connection
        for src, dst in ((client, upstream), (upstream, client)):
            threading.Thread(target=_pump, args=(src, dst), daemon=True).start()
        # Keep the handler thread alive for as long as the client socket is
        # open; the pump threads close both ends on EOF/error.
        while not client._closed:
            threading.Event().wait(0.2)


def _pump(src, dst):
    try:
        while True:
            data = src.recv(65536)
            if not data:
                break
            dst.sendall(data)
    except OSError:
        pass
    finally:
        for sock in (src, dst):
            try:
                sock.shutdown(socket.SHUT_RDWR)
            except OSError:
                pass
            sock.close()


class ThreadingTCPServer(ThreadingMixIn, TCPServer):
    allow_reuse_address = True
    daemon_threads = True


def main():
    port = int(sys.argv[1]) if len(sys.argv) > 1 else 0
    server = ThreadingTCPServer(("127.0.0.1", port), ConnectHandler)
    # Print the bound port so the caller (which may have asked for an
    # ephemeral port with 0) can pick it up.
    print(server.server_address[1], flush=True)
    server.serve_forever()


if __name__ == "__main__":
    main()
