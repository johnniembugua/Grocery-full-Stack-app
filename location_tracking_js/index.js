const http=require("http");
const server= http.createServer();
const { Server}=require("socket.io");
const io = new Server(server);

const PORT=process.env.PORT || 3700;

io.on("connection",(socket)=>{  socket.on("position-change",(data)=>{
    io.emit("position-change",data);

}) ;
socket.on("disconnect",()=>{});
   });

   server.listen(PORT,()=>{
    console.log(`server is running on port ${PORT}`);
});