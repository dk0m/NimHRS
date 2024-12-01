import sequtils, ./shell/server/c2, ./shell/prompt/prompt, cligen, os, parsetoml, std/[asynchttpserver, asyncdispatch]
import strformat


proc onSessionCreate(req: Request, c2: var C2Server) =
    success("Creating Session.")
    success(req.body)

proc onCommandGet(req: Request) = 
    success("Fetching Last Given Command.")

proc onCommandOutput(req: Request) =
    success("Got Command Output.")

proc main(profile: string) =

    if fileExists(profile) != true:
        failure("Profile Doesn't Exist.")
        return

    let tomlData = parseFile(profile)
    let c2ServerData = tomlData["c2Server"]

    var
        c2EndPoints = c2ServerData["endpoints"]
        c2Port = c2ServerData["port"].getInt()
        
    var
        sessionCreate = c2EndPoints["sessionCreate"].getStr()
        commandGet = c2EndPoints["commandGet"].getStr()
        commandOutput = c2EndPoints["commandOutput"].getStr()


    var c2Server = newC2Server()
    c2Server.listen(c2Port)

    proc c2ReqHandler(req: Request) {.async.} =
        var reqUrl = req.url
        var reqPath = reqUrl.path

        if reqPath == sessionCreate:
            onSessionCreate(req, c2Server)

        elif reqPath == commandGet:
            onCommandGet(req)

        elif reqPath == commandOutput:
            onCommandOutput(req)
        
        elif reqPath == "/favicon.ico":
            discard
        else:
            failure("Unknown Endpoint.")
            discard

        await req.respond(Http200, "WebServer Works!")

    c2Server.handler = c2ReqHandler

    success(fmt"Starting C2 Server On Port {$c2Port}..")
    success(fmt"Server ID: {c2Server.id}")

    waitFor loop(c2Server)


when isMainModule:
    dispatch main