# frozen_string_literal: true

# stub module which won't work on ruby.wasm
# provides minimal constants needed by ipaddr.rb
module Socket
  # Address families
  AF_INET = 2
  AF_INET6 = 10
  AF_UNSPEC = 0
  AF_UNIX = 1

  # Protocol families
  PF_INET = 2
  PF_INET6 = 10
  PF_UNSPEC = 0
  PF_UNIX = 1

  # Socket types
  SOCK_STREAM = 1
  SOCK_DGRAM = 2
  SOCK_RAW = 3
  SOCK_RDM = 4
  SOCK_SEQPACKET = 5

  # Socket options
  SOL_SOCKET = 1
  SO_REUSEADDR = 2
  SO_KEEPALIVE = 9
  SO_ERROR = 4

  # IP protocols
  IPPROTO_IP = 0
  IPPROTO_TCP = 6
  IPPROTO_UDP = 17

  # Error codes
  EAI_AGAIN = 2
  EAI_BADFLAGS = 3
  EAI_FAIL = 4
  EAI_FAMILY = 5
  EAI_MEMORY = 6
  EAI_NODATA = 7
  EAI_NONAME = 8
  EAI_SERVICE = 9
  EAI_SOCKTYPE = 10
  EAI_SYSTEM = 11
  EAI_OVERFLOW = 12

  # Flags
  AI_PASSIVE = 1
  AI_CANONNAME = 2
  AI_NUMERICHOST = 4
  AI_NUMERICSERV = 8

  # Constants for getnameinfo
  NI_NUMERICHOST = 2
  NI_NUMERICSERV = 8
  NI_NOFQDN = 1
  NI_NAMEREQD = 4
  NI_DGRAM = 16

  # Socket constants
  MSG_OOB = 1
  MSG_PEEK = 2
  MSG_DONTROUTE = 4
  MSG_WAITALL = 256

  # SCM credentials
  SCM_RIGHTS = 1
  SCM_CREDENTIALS = 2

  # Sockaddr constants
  SOCKADDR_STORAGE_SIZE = 128
  SOCKADDR_IN_SIZE = 16
  SOCKADDR_IN6_SIZE = 28
  SOCKADDR_UN_SIZE = 110

  # INADDR constants
  INADDR_ANY = 0
  INADDR_LOOPBACK = 2130706433
  INADDR_BROADCAST = 4294967295
  INADDR_NONE = 4294967295

  # IPv6 constants
  IPV6_JOIN_GROUP = 12
  IPV6_LEAVE_GROUP = 13
  IPV6_MULTICAST_HOPS = 10
  IPV6_MULTICAST_IF = 9
  IPV6_MULTICAST_LOOP = 11
  IPV6_UNICAST_HOPS = 4
  IPV6_V6ONLY = 26
end

# Error class for socket operations
class SocketError < StandardError; end
