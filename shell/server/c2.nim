import std/[asynchttpserver, asyncdispatch], uuid4


type
  Session* = object
   host*: string
   id*: string
   date*: string


  Endpoints* = object
   sessionCreate*: string
   commandGet*: string
   commandOutput*: string

  EndpointHandler* = proc (request: Request)

  EndpointHandlers* = object
   sessionCreate*: EndpointHandler
   commandGet*: EndpointHandler
   commandOutput*: EndpointHandler

  C2Handler* = proc (request: Request): Future[void] {.closure, gcsafe.}

  C2Server* = object
   server*: AsyncHttpServer
   id*: string
   sessions*: seq[Session]
   handler*: C2Handler

proc newC2Server*(): C2Server =
  return C2Server(server: newAsyncHttpServer(), sessions: @[], handler: nil, id: $uuid4())
  
proc listen*(server: C2Server, port: int) =
  var asyncHttpServer = server.server
  asyncHttpServer.listen(Port(port))


proc loop*(server: C2Server) {.async.} =
  var c2Serv = server.server
  
  while true:
    if c2Serv.shouldAcceptRequest():
      await c2Serv.acceptRequest(server.handler)
    else:
      await sleepAsync(500)